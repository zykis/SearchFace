//
//  DashedImageView.swift
//  SearchFace
//
//  Created by Артём Зайцев on 01/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class BorderView: UIView {
    var gr: UITapGestureRecognizer!
    let border: CAShapeLayer = CAShapeLayer()
    public weak var delegate: BorderViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addStroke()
        addTapGestureRecognizer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addStroke()
        addTapGestureRecognizer()
    }
    
    @objc func tapped() {
        delegate?.borderViewTapped()
    }
    
    func addTapGestureRecognizer() {
        self.isUserInteractionEnabled = true
        gr = UITapGestureRecognizer(target: self, action: #selector(BorderView.tapped))
        self.addGestureRecognizer(gr!)
    }
    
    func addStroke() {
        border.cornerRadius = 6.0
        border.strokeColor = Style.lightBlueColor?.cgColor
        border.fillColor = nil
        border.lineWidth = 3
        border.lineDashPattern = [8, 8]
        
        self.layer.addSublayer(border)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
    }
}

protocol BorderViewDelegate: AnyObject {
    func borderViewTapped()
}
