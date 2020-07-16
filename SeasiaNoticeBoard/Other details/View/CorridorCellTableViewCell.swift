//
//  CorridorCellTableViewCell.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit

class CorridorCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtView.delegate = self
        
        if str_Role == "other" {
         txtView.isUserInteractionEnabled = false
            txtView.backgroundColor = UIColor.lightGray
            lblPlaceholder.isHidden = true
                        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 

}

