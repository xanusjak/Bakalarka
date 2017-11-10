//
//  StartViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {
    
    fileprivate var modelName: String!
    
    fileprivate var modelsList = [String]()
    
    fileprivate var openModels = [String]()
    
    fileprivate let logoView = UIImageView(image: #imageLiteral(resourceName: "bakalarkaLogo"))
    
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
    
    fileprivate let showOpenModelsButton = MAButton(title: "Show open Models", color: .customBlueColor(), target: self, action: #selector(openModelsVC))
    
    fileprivate let uploadButton = MAButton(title: "TODO:// Upload", color: .customBlueColor(), target: self, action: #selector(stopMatlabAdapter))
    
    fileprivate let startMatlabButton = MAButton(title: "Start Matlab", color: .customGreenColor(), target: self, action: #selector(startMatlabAdapter))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(openSettings))
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
        view.addSubview(openModelButton)
        view.addSubview(showOpenModelsButton)
        view.addSubview(startMatlabButton)
        view.addSubview(uploadButton)
    }
    
    func checkMatlabStatus() {

        if MatlabService.sharedClient.isMatlabRuning() {
            
            modelsList = MatlabService.sharedClient.getModels()
            
            startMatlabButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "STOP", style: .done, target: self, action: #selector(stopMatlabAdapter))
            self.navigationItem.rightBarButtonItem?.tintColor = .red
            
            uploadButton.isHidden = false
            openModelButton.isHidden = false
            showOpenModelsButton.isHidden = false
            
        }
        else {
            
            startMatlabButton.isHidden = false
            self.navigationItem.rightBarButtonItem = nil
            
            uploadButton.isHidden = true
            openModelButton.isHidden = true
            showOpenModelsButton.isHidden = true
        }
    }
    
    override func setupConstraints() {
        
        logoView.autoPinEdge(toSuperviewEdge: .left, withInset: (UIScreen.main.bounds.size.width-logoView.bounds.size.width)/2)
        logoView.autoPinEdge(.bottom, to: .top, of: matlabAdapterLabel)
        
        matlabAdapterLabel.autoSetDimension(.height, toSize: 50)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        matlabAdapterLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        matlabAdapterLabel.autoPinEdge(.bottom, to: .top, of: openModelButton, withOffset: -15)
        
        openModelButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        openModelButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        openModelButton.autoPinEdge(.bottom, to: .top, of: showOpenModelsButton, withOffset: -15)
        
        showOpenModelsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        showOpenModelsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        showOpenModelsButton.autoPinEdge(.bottom, to: .top, of: uploadButton, withOffset: -15)
        
        uploadButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        uploadButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        uploadButton.autoPinEdge(.bottom, to: .top, of: startMatlabButton, withOffset: -15)
        
        startMatlabButton.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 15, bottom: 25, right: 15), excludingEdge: .top)
    }
}
    
//BUTTONS ACTIONS
extension StartViewController {
    
    @objc func openSettings() {
        if MatlabService.sharedClient.isMatlabRuning() {
            let alert = UIAlertController(title: "Stop Matlab", message: "To change settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.navigationController?.pushViewController(SettingsViewController(haveConnection: true), animated: true)
        }
    }
    
    @objc func openMatlabModel() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for enumString in modelsList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                self.modelName = enumString
                
                let alertController = SpinnerAlertViewController(title: " ", message: "Opening \(self.modelName as String)...", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)

                DispatchQueue.global(qos: .userInitiated).async {
                    if !MatlabService.sharedClient.isModelOpened(modelName: self.modelName) {
                        MatlabService.sharedClient.openModel(self.modelName)
                    }
                    DispatchQueue.main.async {
                        alertController.dismiss(animated: true, completion: {
                            self.navigationController?.pushViewController(ModelViewController(modelName: self.modelName), animated: true)
                        })
                    }
                }

            }
            alert.addAction(choise)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func openModelsVC() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Checking...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
         openModels.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            for name in self.modelsList {
                if (MatlabService.sharedClient.isModelOpened(modelName: name)) {
                    self.openModels.append(name)
                }
            }
            
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: {
                    self.navigationController?.pushViewController(OpenModelsViewController(openModels: self.openModels), animated: true)
                })
            }
        }
        
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
