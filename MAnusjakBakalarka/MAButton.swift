//
//  MAButton.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 30/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class MAButton: UIButton {

    
    init(title: String, color: UIColor, target: Any, action: Selector) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = color
        self.addTarget(target, action: action, for: .touchUpInside)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        
        self.autoSetDimension(.height, toSize: 50)
    }
}
