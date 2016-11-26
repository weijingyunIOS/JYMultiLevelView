//
//  JYLevelModel.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import HandyJSON
import ReactiveSwift

class JYLevelModel : HandyJSON {
    
    var courseSectionID : String?
    var level = 0                               // 目录层次 1 2 3 4
    var sectionName : String?                   // 目录名
    var orderNum : String?
    var questionNum : String?
    lazy var isOn : MutableProperty<Bool>? = {  // 是否展开
        return MutableProperty(false)
    }()
    
    var list : [JYLevelModel]?                  // 包含的下一层级
    
    required  init() {}
    
    func getLevelList() -> [JYLevelModel]? {
        
        if (list == nil) {
            return nil;
        }
        
        var lists : [JYLevelModel]! = []
        for leveModel in list! {
            lists = lists + [leveModel]
            let ll : [JYLevelModel]! = isOn!.value ? leveModel.getLevelList() : nil
            if (ll != nil) {
                lists = lists + ll!
            }
        }
        return lists
    }

}
