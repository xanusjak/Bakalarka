//
//  StartViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {
    
    fileprivate var modelsList = Array<String>()
    
    fileprivate var modelNameLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Choose model"
        return label
    }()
    
    fileprivate var openModelButton: UIButton! = {
        var openModelButton = UIButton()
        openModelButton.setTitle("Open Model", for: .normal)
        openModelButton.addTarget(self, action: #selector(openMatlabModel), for: .touchUpInside)
        openModelButton.backgroundColor = UIColor.customBlueColor()
        return openModelButton
    }()
    
    fileprivate var downloadModelButton: UIButton! = {
        var button = UIButton()
        button.setTitle("Download Model", for: .normal)
        //        button.addTarget(self, action: #selector(openMatlabModel), for: .touchUpInside) //TODO: download model from cloud
        button.backgroundColor = UIColor.customBlueColor()
        return button
    }()
    
    fileprivate var startCloseButton: UIButton! = {
        var button = UIButton()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkMatlabStatus()
    }
    
    override func setupTitle() {
        self.title = "Home"
    }
    
    override func setupLoadView() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: UIBarButtonItemStyle.done, target: self, action: #selector(openSettings))
        
        view.addSubview(modelNameLabel)
        view.addSubview(openModelButton)
        view.addSubview(downloadModelButton)
        view.addSubview(startCloseButton)
    }
    
    func checkMatlabStatus() {

        if MatlabService.sharedClient.isMatlabRuning() {
            
            //TODO: If model is open
            if (MatlabService.sharedClient.isModelOpened(modelName: "vrmaglev")) {
                self.navigationController?.pushViewController(ModelViewController(modelName: "vrmaglev"), animated: true)
            }
            
            modelsList = MatlabService.sharedClient.getModels()
            let tap = UITapGestureRecognizer(target:self, action:#selector(chooseModel))
            modelNameLabel.addGestureRecognizer(tap)
            
            startCloseButton.setTitle("Stop Matlab", for: .normal)
            startCloseButton.addTarget(self, action: #selector(closeMatlabAdapter), for: .touchUpInside)
            startCloseButton.backgroundColor = UIColor.customRedColor()
            
            openModelButton.isEnabled = true
            openModelButton.backgroundColor = UIColor.customBlueColor()
            downloadModelButton.isEnabled = true
            downloadModelButton.backgroundColor = UIColor.customBlueColor()
        }
        else {
            startCloseButton.setTitle("Start Matlab", for: .normal)
            startCloseButton.addTarget(self, action: #selector(startMatlabAdapter), for: .touchUpInside)
            startCloseButton.backgroundColor = UIColor.customGreenColor()
            
            openModelButton.isEnabled = false
            openModelButton.backgroundColor = UIColor.customBlueColor(withAlpha: 0.5)
            downloadModelButton.isEnabled = false
            downloadModelButton.backgroundColor = UIColor.customBlueColor(withAlpha: 0.5)
        }
    }
    
    override func setupConstraints() {
        
        modelNameLabel.autoSetDimension(.height, toSize: 50)
        modelNameLabel.autoPinEdge(toSuperviewEdge: .left)
        modelNameLabel.autoPinEdge(toSuperviewEdge: .right)
        modelNameLabel.autoPinEdge(.bottom, to: .top, of: openModelButton, withOffset: -15)
        
        openModelButton.autoSetDimension(.height, toSize: 50)
        openModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        openModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        openModelButton.autoPinEdge(.bottom, to: .top, of: downloadModelButton, withOffset: -15)
        
        downloadModelButton.autoSetDimension(.height, toSize: 50)
        downloadModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        downloadModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        downloadModelButton.autoPinEdge(.bottom, to: .top, of: startCloseButton, withOffset: -25)
        
        startCloseButton.autoSetDimension(.height, toSize: 50)
        startCloseButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func openSettings() {
        self.navigationController?.pushViewController(SettingsViewController(haveConnection: true), animated: true)
    }
    
    @objc func chooseModel() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for enumString in modelsList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                self.modelNameLabel.text = enumString
            }
            alert.addAction(choise)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func startMatlabAdapter() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Starting...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.startMatlab()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
            }
            self.checkMatlabStatus()
        }
    }
    
    @objc func openMatlabModel() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Opening model...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.openModel("vrmaglev") //TODO: modelNameLabel.text
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                self.navigationController?.pushViewController(ModelViewController(modelName: "vrmaglev"), animated: true)
            }
        }
    }
    
    @objc func closeMatlabAdapter() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Stoping...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.stopMatlab()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
            }
            self.checkMatlabStatus()
        }
    }
}
