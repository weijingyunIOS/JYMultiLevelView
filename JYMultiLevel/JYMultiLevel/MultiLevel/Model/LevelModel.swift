//
//  LevelModel.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import HandyJSON
import ReactiveSwift

class LevelModel : HandyJSON {
    
    var courseSectionID : String?
    var level = 0                               // 目录层次 1 2 3 4
    var sectionName : String?                   // 目录名
    var orderNum : String?
    var questionNum : String?
    var list : [LevelModel]?                  // 包含的下一层级

    // HandyJSON 对非基本类型 要使用 可选类型 否则转换会 崩溃，但要保证有值所以用懒加载实现
    lazy var isOn : MutableProperty<Bool>? = {  // 是否展开
        return MutableProperty(false)
    }()
    
    
    required  init() {}
    
    // 根据是否展开 获取 下级需要展现的所有model
    func getLevelList() -> [LevelModel]? {
        
        if (list == nil) {
            return nil;
        }
        
        var lists : [LevelModel]! = []
        for leveModel in list! {
            lists = lists + [leveModel]
            let ll : [LevelModel]! = isOn!.value ? leveModel.getLevelList() : nil
            if (ll != nil) {
                lists = lists + ll!
            }
        }
        return lists
    }

}
