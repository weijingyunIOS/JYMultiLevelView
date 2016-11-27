//
//  LevelCellViewModel.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/27.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit
import ReactiveSwift

enum ELevelCellOperation {
    
    case insertLevel   // 插入cell 展开
    case moveLevel     // 移除cell 收起
}

class LevelCellViewModel: NSObject {
    
    let levelModel : LevelModel
    var isOn = MutableProperty(false)
    var cellIdentifier : String {
        get{
            return "LevelCell"
        }
    }
    
    init(_ levelModel : LevelModel) {
        
        self.levelModel = levelModel
        self.isOn = MutableProperty(levelModel.isOn)
    }
    
    // 用于将model 包装为 ViewModel
    class func createLevelModelList(_ list : [LevelModel]) -> [LevelCellViewModel]{
        
        var viewModelList : [LevelCellViewModel] = []
        for model in list{
            viewModelList.append(LevelCellViewModel.init(model))
        }
        return viewModelList
    }
    
    func getListLevelViewModel() -> [LevelCellViewModel]? {
        
        let list = levelModel.getLowerLevelList()
        if (list != nil) {
            return LevelCellViewModel.createLevelModelList(list!)
        }
        return nil
    }
    
    func bingCell(_ cell : LevelCell) -> Signal<(ELevelCellOperation, LevelCellViewModel), NSError>{
        
        cell.titleLabel.text = levelModel.sectionName
        cell.rightBut.reactive.isSelected <~ isOn
        cell.leftLabelLeading.constant = CGFloat((levelModel.level - 1) * 10)
        switch levelModel.level {
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
            cell.countLabel.text = levelModel.questionNum
            cell.rightBut.isHidden = true
            cell.countLabel.isHidden = false
            break
        default:
            break
        }
    
        // 事件触发
        cell.butClick = { (x : Bool) ->() in
            self.isOn.swap(x)
        }
        
        let (signal, observer) = Signal<(ELevelCellOperation, LevelCellViewModel), NSError>.pipe()
        isOn.producer.startWithValues {(isOn) in
            
                if self.levelModel.isOn == isOn{
                    return
                }
                
                if(self.levelModel.level == 4){
                    return
                }
                
                print(isOn)
                // 模型更新
                self.levelModel.isOn = isOn
                if(isOn){
                    observer.send(value: (ELevelCellOperation.insertLevel,self))
                }else{
                    observer.send(value: (ELevelCellOperation.moveLevel, self))
                }
            
        }
        

        return signal
    }
    
    func didSelect(){
        if (levelModel.level != 4) {
            isOn.swap(!isOn.value)
        }
    }
}
