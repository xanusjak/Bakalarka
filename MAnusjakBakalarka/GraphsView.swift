//
//  GraphsView.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 18/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class GraphsView: UIView {

    fileprivate let testLabel: UILabel = {
        var label = UILabel()
        label.text = "TEST"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.customBlueColor()
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.addSubview(testLabel)
        testLabel.autoPinEdgesToSuperviewEdges()
    }
}
