//
//  JYMultiLevelViewModel.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift
import HandyJSON

class JYMultiLevelViewModel: NSObject {
    
    private var levelModelS : JYLevelModel?
    

    func fetchMultiLevelList(jsonName:String) -> Signal<Any, NSError>{
    
        let result = Signal<Any, NSError>.pipe()
        let observer = result.1
        
        // 异步模拟网络请求
        DispatchQueue.global().async {
            
            do {
                let filePath = try Bundle.main.path(forResource: jsonName, ofType: "json").unwrap("jsonName 找不到该文件")
                let fileURL =  URL.init(fileURLWithPath: filePath)
                let jsonData = try Data.init(contentsOf: fileURL)
                let dic = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                DispatchQueue.main.async(execute: {
                    self.levelModelS = JSONDeserializer<JYLevelModel>.deserializeFrom(dict: dic)
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
        
        
        return result.0
    }
    
}
    

