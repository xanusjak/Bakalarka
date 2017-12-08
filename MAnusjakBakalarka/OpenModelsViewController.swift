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
                button.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
                button.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
                button.autoPinEdge(toSuperviewEdge: .top, withInset: CGFloat(30 + index*100))
                
                let closeButton = UIButton()
                closeButton.addTarget(self, action: #selector(closeModel(_:)), for: .touchUpInside)
                closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                closeButton.tag = index
                
                self.view.addSubview(closeButton)
                
                closeButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
                closeButton.autoPinEdge(.bottom, to: .top, of: button)
                closeButton.autoPinEdge(.right, to: .right, of: button)
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
    
    @objc func closeModel(_ sender: UIButton) {
        
        let modelName = openModels[sender.tag]
            
        let alert = UIAlertController(title: nil, message: "Close model?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) in
            
            let alertController = SpinnerAlertViewController(title: " ", message: "Closing model...", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            DispatchQueue.global(qos: .userInitiated).async {
                MatlabService.sharedClient.closeModel(modelName)
                DispatchQueue.main.async {
                    alertController.dismiss(animated: true, completion:  {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
