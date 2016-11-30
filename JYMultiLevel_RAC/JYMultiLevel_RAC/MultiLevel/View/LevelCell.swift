//
//  LevelCellOne.swift
//  MultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit

class LevelCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var rightBut: UIButton!
    
    @IBOutlet weak var leftLabelLeading: NSLayoutConstraint!
    
    var butClick =  { (x: Bool ) ->() in
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
        rightBut.setImage(UIImage(named:"icon_bank_treeview_add"), for: UIControlState.normal)
        rightBut.setImage(UIImage(named:"icon_bank_treeview_minus"), for: UIControlState.selected)
        rightBut.addTarget(self, action: #selector(rightButClick(but:)), for: UIControlEvents.touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func rightButClick(but:UIButton) {
        butClick(!but.isSelected)
    }

    deinit {
        print((#file as NSString).lastPathComponent, #function)
    }
}
