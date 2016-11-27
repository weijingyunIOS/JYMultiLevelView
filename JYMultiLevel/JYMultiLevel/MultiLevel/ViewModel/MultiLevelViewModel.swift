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
    
    var showLists:[LevelCellViewModel] = []

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
                    
                    do{
                        let models = try JSONDeserializer<LevelModel>.deserializeFrom(dict: dic).unwrap()
                        let list = try models.list.unwrap()
                        self.showLists = LevelCellViewModel.createLevelModelList(list)
                        observer.sendCompleted()
                    
                    }catch{
                        print(error)
                        observer.sendCompleted()
                    }
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
    
    // 辅助功能
    func updateTableView(_ tableView: UITableView, operation:ELevelCellOperation,cellViewModel: LevelCellViewModel){
        
        do {
            let lists = try cellViewModel.getListLevelViewModel().unwrap()
            let currentIndex = try getIndexBy(cellViewModel).unwrap()
            var indexs : [IndexPath] = []
            for idx in 1...lists.count {
                indexs = indexs + [IndexPath(row: currentIndex + idx, section: 0)]
            }
            print(indexs)
            tableView.beginUpdates()
            switch operation {
            case .insertLevel:
                showLists.insert(contentsOf: lists, at: currentIndex + 1)
                tableView.insertRows(at: indexs, with: UITableViewRowAnimation.none)
                break
            case .moveLevel:
                for idx in 1...lists.count {
                    showLists.remove(at:  currentIndex + idx)
                }
                tableView.deleteRows(at: indexs, with: UITableViewRowAnimation.none)
                break
            default:
                break
            }
            tableView.endUpdates()
        } catch {
            print(error)
        }
    }
    
    func getIndexBy(_ cellViewModel: LevelCellViewModel) -> Int?{
    
        for (idx,cellVM) in showLists.enumerated()
        {
            if (cellVM == cellViewModel) {
                return idx
            }
        }
        return nil
    }
}
