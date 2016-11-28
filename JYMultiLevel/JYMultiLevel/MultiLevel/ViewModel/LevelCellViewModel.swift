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
    
    private let levelModel : LevelModel
    private var isOn : MutableProperty<Bool>
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
    
    // 收起条件 互斥收起的条件是 第2级 目录 以及它是 打开的
    func isPackUp(_ cellViewModel : LevelCellViewModel) -> Bool {
        return levelModel.isOn && levelModel.level == 2
    }
    
    // 展开收起对应列表
    func switchList(_ cellViewModel : LevelCellViewModel){
        
        if (levelModel.level == cellViewModel.levelModel.level) {
            if (self != cellViewModel) {
                isOn.swap(false)
            }
        }
    }
    
    func bingCell(_ cell : LevelCell, operation:@escaping ((ELevelCellOperation, LevelCellViewModel)->Void)){
        
        cell.titleLabel.text = levelModel.sectionName
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
        cell.butClick = {[unowned self] (x : Bool) ->() in
            self.isOn.swap(x)
        }
        
        // 1.disposable 手动管理 2.重设 isOn 让其失效 操作符 行为会在其释放时释放
        isOn = MutableProperty(levelModel.isOn)
        cell.rightBut.reactive.isSelected <~ isOn.map({[unowned self] (isOn) -> Bool in

            if self.levelModel.isOn == isOn{
                return isOn
            }
            // 模型更新
            self.levelModel.isOn = isOn
            
            if(self.levelModel.level == 4){
                return isOn
            }
            
            if(isOn){
                operation(ELevelCellOperation.insertLevel,self)
            }else{
                operation(ELevelCellOperation.moveLevel,self)
            }
            return isOn
        })
//        disposable?.dispose()
//        disposable = isOn.producer.startWithValues {[unowned self](isOn) in
//            
//            print("44444", cell.rightBut.isSelected , self.isOn.value , self.levelModel.isOn, self)
//                if self.levelModel.isOn == isOn{
//                    return
//                }
//                // 模型更新
//                self.levelModel.isOn = isOn
//    
//                if(self.levelModel.level == 4){
//                    return
//                }
//    
//                if(isOn){
//                    operation(ELevelCellOperation.insertLevel,self)
//                }else{
//                    operation(ELevelCellOperation.moveLevel,self)
//                }
//        }
    }
    
    func didSelect(){
        if (levelModel.level != 4) {
            isOn.swap(!isOn.value)
        }
    }
    
    deinit {
        print((#file as NSString).lastPathComponent, #function)
    }
}
