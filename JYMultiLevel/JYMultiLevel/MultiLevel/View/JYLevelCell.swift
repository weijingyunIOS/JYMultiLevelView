//
//  JYLevelCellOne.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import UIKit

class JYLevelCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rightBut: UIButton!
    
    @IBOutlet weak var leftLabelLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
