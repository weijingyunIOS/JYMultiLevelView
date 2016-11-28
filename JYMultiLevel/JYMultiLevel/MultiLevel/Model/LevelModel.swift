//
//  LevelModel.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import HandyJSON

class LevelModel : HandyJSON {
    
    var courseSectionID : String?
    var level = 0                               // 目录层次 1 2 3 4
    var sectionName : String?                   // 目录名
    var orderNum : String?
    var questionNum : String?
    var list : [LevelModel]?                   // 包含的下一层级
    var isOn = false                           // 是否展开
    
    
    required  init() {}
    
    func getLowerLevelList() -> [LevelModel]? {
        
        var lists : [LevelModel]! = []
        for model in list! {
            lists = lists + [model]
            let ll = model.getLevelList()
            if (ll != nil) {
                lists = lists + ll!
            }
        }
        return lists
    }
    
    // 根据是否展开 获取 下级需要展现的所有model
    private func getLevelList() -> [LevelModel]? {
        
        if (list == nil || isOn == false) {
            return nil;
        }
        return getLowerLevelList()
    }
    
    deinit {
        print((#file as NSString).lastPathComponent, #function)
    }
}
