//
//  StartViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {
    
    fileprivate var modelName = "none"
    
    fileprivate var modelsList = Array<String>()
    
    fileprivate let logoView = UIImageView(image: #imageLiteral(resourceName: "bakalarkaLogo"))
    
    fileprivate var modelNameLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        label.text = "Tap to choose model"
        return label
    }()
    
    fileprivate var matlabAdapterLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "Avenir-BlackOblique", size: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        label.text = "MatlabAdapter"
        return label
    }()
    
    fileprivate let openModelButton = MAButton(title: "Open Model", color: .customBlueColor(), target: self, action: #selector(openMatlabModel))
    
    fileprivate let downloadModelButton = MAButton(title: "Download Model", color: .customBlueColor(), target: self, action: #selector(openMatlabModel))
    
    fileprivate let startMatlabButton = MAButton(title: "Start Matlab", color: .customGreenColor(), target: self, action: #selector(startMatlabAdapter))
    
    fileprivate let stopMatlabButton = MAButton(title: "Stop Matlab", color: .customRedColor(), target: self, action: #selector(stopMatlabAdapter))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(openSettings))
        self.checkMatlabStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        
        view.addSubview(logoView)
        view.addSubview(matlabAdapterLabel)
        
        view.addSubview(modelNameLabel)
        view.addSubview(openModelButton)
        view.addSubview(downloadModelButton)
        view.addSubview(startMatlabButton)
        view.addSubview(stopMatlabButton)
    }
    
    func checkMatlabStatus() {

        if MatlabService.sharedClient.isMatlabRuning() {
            
            modelsList = MatlabService.sharedClient.getModels()
            let tap = UITapGestureRecognizer(target:self, action:#selector(chooseModel))
            modelNameLabel.addGestureRecognizer(tap)
            
            for name in modelsList {
                if (MatlabService.sharedClient.isModelOpened(modelName: name)) {
                    self.navigationController?.pushViewController(ModelViewController(modelName: name), animated: true)
                }
            }
            
            startMatlabButton.isHidden = true
            stopMatlabButton.isHidden = false
            
            modelNameLabel.isHidden = false
            openModelButton.isHidden = false
            downloadModelButton.isHidden = false
            
        }
        else {
            
            startMatlabButton.isHidden = false
            stopMatlabButton.isHidden = true
            
            modelNameLabel.isHidden = true
            openModelButton.isHidden = true
            downloadModelButton.isHidden = true
        }
    }
    
    override func setupConstraints() {
        
        logoView.autoPinEdge(toSuperviewEdge: .left, withInset: (UIScreen.main.bounds.size.width-logoView.bounds.size.width)/2)
        logoView.autoPinEdge(.bottom, to: .top, of: matlabAdapterLabel)
        
        matlabAdapterLabel.autoSetDimension(.height, toSize: 50)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        matlabAdapterLabel.autoPinEdge(.bottom, to: .top, of: modelNameLabel, withOffset: -15)
        
        modelNameLabel.autoSetDimension(.height, toSize: 50)
        modelNameLabel.autoPinEdge(toSuperviewEdge: .left)
        modelNameLabel.autoPinEdge(toSuperviewEdge: .right)
        modelNameLabel.autoPinEdge(.bottom, to: .top, of: openModelButton, withOffset: -15)
        
        openModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        openModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        openModelButton.autoPinEdge(.bottom, to: .top, of: downloadModelButton, withOffset: -15)
        
        downloadModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        downloadModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        downloadModelButton.autoPinEdge(.bottom, to: .top, of: startMatlabButton, withOffset: -15)
        
        startMatlabButton.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 15, bottom: 25, right: 15), excludingEdge: .top)
        
        stopMatlabButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func openSettings() {
        if MatlabService.sharedClient.isMatlabRuning() {
            let alert = UIAlertController(title: "Stop Matlab", message: "to change settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.navigationController?.pushViewController(SettingsViewController(haveConnection: true), animated: true)
        }
    }
    
    @objc func chooseModel() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for enumString in modelsList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                self.modelNameLabel.text = enumString
                self.modelName = enumString
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
                self.checkMatlabStatus()
            }
        }
    }
    
    @objc func openMatlabModel() {
        
        if modelName == "none" {
            let alert = UIAlertController(title: "Please", message: "Choose model", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alertController = SpinnerAlertViewController(title: " ", message: "Opening model...", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)

            DispatchQueue.global(qos: .userInitiated).async {
                MatlabService.sharedClient.openModel(self.modelName)
                DispatchQueue.main.async {
                    alertController.dismiss(animated: true, completion: {
                        self.navigationController?.pushViewController(ModelViewController(modelName: self.modelName), animated: true)
                    })
                }
            }
        }
    }
    
    @objc func downloadMatlabModel() {
        print("Download Model")
    }
    
    @objc func stopMatlabAdapter() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Stoping...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.stopMatlab()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                self.checkMatlabStatus()
            }
        }
    }
}
