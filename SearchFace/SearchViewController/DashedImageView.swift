//
//  DashedImageView.swift
//  SearchFace
//
//  Created by Артём Зайцев on 01/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

@IBDesignable class DashedImageView: UIImageView {
    let border: CAShapeLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addStroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addStroke()
    }
    
    func addStroke() {
        border.cornerRadius = 6.0
        border.strokeColor = Style.lightBlueColor?.cgColor
        border.fillColor = nil
        border.lineWidth = 2
        border.lineDashPattern = [8, 8]
        
        self.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
    }
}
