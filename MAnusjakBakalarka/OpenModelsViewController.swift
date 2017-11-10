//
//  OpenModelsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 08/11/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class OpenModelsViewController: BaseViewController {

    fileprivate var openModels: [String]!
    
    fileprivate let noOpenModels: UILabel = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        label.text = "No open models."
        return label
    }()
    
    init(openModels: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.openModels = openModels
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        
        if openModels.count == 0 {
            self.view.addSubview(noOpenModels)
        }
        else {
            for index in 0..<openModels.count {
                
                let button = UIButton()
                button.setTitle(openModels[index], for: .normal)
                button.setTitleColor(.customBlueColor(), for: .normal)
                button.addTarget(self, action: #selector(openModel(_:)), for: .touchUpInside)
                button.backgroundColor = .white
                
                button.layer.borderColor = UIColor.customBlueColor().cgColor
                button.layer.cornerRadius = 15
                button.layer.borderWidth = 1.5
                self.view.addSubview(button)
                
                button.autoSetDimension(.height, toSize: 70)
                button.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
                button.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
                button.autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(20 + index*90))
            }
        }
    }
    
    override func setupConstraints() {
        
        if openModels.count == 0 {
            noOpenModels.autoPinEdgesToSuperviewEdges()
        }
    }
    
    @objc func openModel(_ sender: MAButton!) {
    
        if let modelName = sender.titleLabel!.text {
            self.navigationController?.pushViewController(ModelViewController(modelName: modelName), animated: true)
        }
    }
}
