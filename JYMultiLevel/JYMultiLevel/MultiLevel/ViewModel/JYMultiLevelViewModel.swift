//
//  JYMultiLevelViewModel.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import HandyJSON

class JYMultiLevelViewModel: NSObject {
    
    private var levelModelS : JYLevelModel?
    var showLists:[JYLevelModel]?

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
                    self.levelModelS = JSONDeserializer<JYLevelModel>.deserializeFrom(dict: dic)
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
    
    func bing(_ tableView:UITableView,cell:JYLevelCell,model:JYLevelModel) -> Signal<(Int,[IndexPath]), NSError>{
        
        let (signal, observer) = Signal<(Int,[IndexPath]), NSError>.pipe()
        cell.titleLabel.reactive.text <~ MutableProperty(model.sectionName)
        cell.leftLabelLeading.constant = CGFloat((model.level - 1) * 10)
        model.isOn!.producer.startWithValues { (ison) in
            let imageName = ison ? "icon_bank_treeview_minus" : "icon_bank_treeview_add"
            cell.rightBut .setImage(UIImage(named: imageName), for: UIControlState.normal)
        }
        cell.rightBut.addTarget(self, action:#selector(JYMultiLevelViewModel.butClick(but:)), for: UIControlEvents.touchUpInside)
    
        
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
