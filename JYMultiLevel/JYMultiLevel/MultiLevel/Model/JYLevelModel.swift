//
//  JYLevelModel.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import HandyJSON

class JYLevelModel: HandyJSON {
    
    var courseSectionID : String?
    var level = 0                               // 目录层次 1 2 3 4
    var sectionName : String?                   // 目录名
    var orderNum : String?
    var questionNum : String?
    var isOn = false                            // 是否展开
    var list : [JYLevelModel]?                  // 包含的下一层级
    
    required init() {}
    
}
