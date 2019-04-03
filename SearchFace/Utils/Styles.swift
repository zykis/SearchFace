//
//  Styles.swift
//  SearchFace
//
//  Created by Артём Зайцев on 01/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class Style {
    static var lightBlueColor: UIColor?
    static var darkBlueColor: UIColor?
    
    static func defaultTheme() {
        self.lightBlueColor = UIColor(red: 174/255.0, green: 204/255.0, blue: 220/255.0, alpha: 1.0)
        self.darkBlueColor = UIColor(red: 20/255.0, green: 66/255.0, blue: 70/255.0, alpha: 1.0)
    }
    
    static func update() {
        let buttonProxy = UIButton.appearance()
        buttonProxy.setTitleColor(UIColor.black, for: .normal)
        
//        let labelInCellProxy = UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
//        labelInCellProxy.textColor = UIColor.white
        
        let resultCellProxy = ResultCell.appearance()
        resultCellProxy.backgroundColor = self.lightBlueColor
    }
}
