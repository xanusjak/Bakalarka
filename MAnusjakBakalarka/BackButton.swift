//
//  BackButton.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 25/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    fileprivate let arrow: UIImageView = {
        var arrowView = UIImageView(image: #imageLiteral(resourceName: "iOSback"))
        return arrowView
    }()
    
    fileprivate let label: UILabel = {
        var label = UILabel()
        label.text = "Back"
        label.textColor = .black
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.addSubview(arrow)
        self.addSubview(label)
    }
    
    func setupConstraints() {
        
        self.autoSetDimensions(to: CGSize(width: 77, height: 44))
        
        arrow.autoSetDimensions(to: CGSize(width: 30, height: 30))
        arrow.autoPinEdge(toSuperviewEdge: .top, withInset: 7)
        arrow.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        
        label.autoPinEdge(.left, to: .right, of: arrow, withOffset: -3)
        label.autoPinEdge(toSuperviewEdge: .top, withInset: 11.5)
    }
}
