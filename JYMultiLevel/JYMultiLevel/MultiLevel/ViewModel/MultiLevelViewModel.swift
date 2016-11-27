//
//  MultiLevelViewModel.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import HandyJSON

class MultiLevelViewModel: NSObject {
    
    private var levelModelS : LevelModel?
    var showLists:[LevelModel]?

    func fetchMultiLevelList(jsonName:String) -> Signal<Any, NSError>{
    
         let (signal, observer) = Signal<Any, NSError>.pipe()
        
        // 异步模拟网络请求
        DispatchQueue.global().async {
            
            do {
                let filePath = try Bundle.main.path(forResource: jsonName, ofType: "json").unwrap("jsonName 找不到该文件")
                let fileURL =  URL.init(fileURLWithPath: filePath)
                let jsonData = try Data.init(contentsOf: fileURL)
                let dic = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                DispatchQueue.main.async(execute: {
                    self.levelModelS = JSONDeserializer<LevelModel>.deserializeFrom(dict: dic)
                    self.showLists = self.levelModelS?.getLevelList()
                    observer.sendCompleted()
                })
                
            } catch{
                
                let aError = NSError.error(from: error)
                print(error)
                // 主线程异步执行
                DispatchQueue.main.async(execute: {
                    observer.send(error:aError)
                })
            }
        }
        
        return signal
    }
    
    func bing(_ tableView:UITableView,cell:LevelCell,model:LevelModel) -> Signal<(Int,[IndexPath]), NSError>{
        
        let (signal, observer) = Signal<(Int,[IndexPath]), NSError>.pipe()
//        cell.titleLabel.reactive.text <~ MutableProperty(model.sectionName)
        cell.titleLabel.text = model.sectionName
        cell.leftLabelLeading.constant = CGFloat((model.level - 1) * 10)
        model.isOn!.producer.startWithValues { (isOn) in
            if(model.level == 4){
                return
            }
            let imageName = isOn ? "icon_bank_treeview_minus" : "icon_bank_treeview_add"
            cell.rightBut .setImage(UIImage(named: imageName), for: UIControlState.normal)
        }
        switch model.level {
        case 2:
            cell.contentView.backgroundColor = UIColor.white
            cell.rightBut.isHidden = false
            cell.countLabel.isHidden = true
            break
        case 3:
            cell.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            cell.rightBut.isHidden = false
            cell.countLabel.isHidden = true
            break
        case 4:
            cell.contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            cell.countLabel.text = model.questionNum
            cell.rightBut.isHidden = true
            cell.countLabel.isHidden = false
            break
        default:
            break
        }
        
        
        cell.rightBut.addTarget(self, action:#selector(MultiLevelViewModel.butClick(but:)), for: UIControlEvents.touchUpInside)
    
        
        // MARK: tableView代理 事件模拟
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
           
            do {
                let currentIndex = try tableView.indexPath(for: cell).unwrap()
                let currentModel = self.showLists![currentIndex.row]
                let lists = try currentModel.getLevelList().unwrap()
                
                if(currentModel.isOn!.value){
                    return
                }
                currentModel.isOn!.swap(true)
                self.showLists!.insert(contentsOf: lists, at: currentIndex.row + 1)
                var indexs : [IndexPath] = []
                for idx in 1...lists.count {
                    indexs = indexs + [IndexPath(row: currentIndex.row + idx, section: currentIndex.section)]
                }
                observer.send(value: (0,indexs))
                
            } catch{
            }
        }
        
        return signal
    }
    
    func butClick(but : UIButton){
        print(but)
        
    }
 
}
