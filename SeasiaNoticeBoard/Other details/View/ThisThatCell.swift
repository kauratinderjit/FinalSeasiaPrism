//
//  ThisThatCell.swift
//  SeasiaNoticeBoard
//
//  Created by Atinder Kaur on 5/29/20.
//  Copyright © 2020 Poonam Sharma. All rights reserved.
//

import UIKit
import WMSegmentControl

class ThisThatCell: UITableViewCell {

    @IBOutlet weak var customSegment: WMSegment!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        customSegment.type = .normal // normal (Default),imageOnTop, onlyImage
        customSegment.selectorType = .normal //normal (Default), bottomBar
        // If you want round selector
        customSegment.isRounded = true //By default flase
        //Set titles of your segment
       // customSegment.buttonTitles = "Cofee,Tea"
        // set text color for non - selected segment values
        customSegment.textColor = .white
        // set text color for selected segment value
        customSegment.selectorTextColor = .white
        //set Color for selected segment
        customSegment.selectorColor =   UIColor.init(red: 24/255, green: 174/255, blue: 122/255, alpha: 1)
        //set font for selcted segment value
        customSegment.SelectedFont = UIFont.boldSystemFont(ofSize: 15)
        // set font for segment options
        customSegment.normalFont = UIFont.systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            customSegment.backgroundColor = UIColor.placeholderText
        } else {
           customSegment.backgroundColor = UIColor.lightGray
        }
        //self.contentView.addSubview(anotherSegment)
        if str_Role == "other" {
                       customSegment.isUserInteractionEnabled = false

                   }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
