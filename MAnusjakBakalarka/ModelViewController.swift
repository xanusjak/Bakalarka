//
//  ModelViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 05/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class ModelViewController: BaseViewController {
    
    fileprivate var modelName: String!
    
    fileprivate var modelDict: [String:Any]!
    
    fileprivate var chooseParamsButton = MAButton(title: "Select Parameters", color: .customBlueColor(), target: self, action: #selector(openChoseParamsVC))
    
    fileprivate var choosenParamsButton = MAButton(title: "Edit Parameters", color: .customBlueColor(), target: self, action: #selector(openChoosenParamsVC))
    
    fileprivate var uploadButton = MAButton(title: "Save", color: .customBlueColor(), target: self, action: #selector(uploadModel))
    
    fileprivate var startSimButton = MAButton(title: "Simulation", color: .customBlueColor(), target: self, action: #selector(openSimulationVC))
    
    fileprivate var alertController: UIAlertController!
    
    init(modelName: String) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dict = MatlabService.sharedClient.getModelInfo(self.modelName)
            self.modelDict = dict
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = modelName
    }
    
    override func setupLoadView() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeMatlabModel))
        self.navigationItem.rightBarButtonItem?.tintColor = .red
        
        view.addSubview(chooseParamsButton)
        view.addSubview(choosenParamsButton)
        view.addSubview(startSimButton)
        view.addSubview(uploadButton)
    }
    
    override func setupConstraints() {
        
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        
        choosenParamsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        choosenParamsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        choosenParamsButton.autoPinEdge(.top, to: .bottom, of: chooseParamsButton, withOffset: 20)
        
        uploadButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        uploadButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        uploadButton.autoPinEdge(.top, to: .bottom, of: choosenParamsButton, withOffset: 20)
        
        startSimButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        startSimButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        startSimButton.autoPinEdge(.top, to: .bottom, of: uploadButton, withOffset: 20)
    }
}

//BUTTONS ACTIONS
extension ModelViewController {
    
    @objc func openChoseParamsVC() {
        self.navigationController?.pushViewController(SelectBlockViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func openChoosenParamsVC() {
        self.navigationController?.pushViewController(EditParamsViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func openSimulationVC() {
        
        self.navigationController?.pushViewController(StartSimulationViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func uploadModel() {
        alertController = UIAlertController(title: nil, message: "Save as:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            if let fileName = self.alertController.textFields![0].text {
                //TODO: Upload/Save model
                print("Save as: \(fileName)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = "File name"
        }
        
        alertController.addAction(confirmAction)
        alertController.actions[0].isEnabled = false
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func closeMatlabModel() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Closing model...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.closeModel(self.modelName)
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion:  {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }
    }
}


extension ModelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location - range.length > 1) { //minimum 3 chars
            alertController.actions[0].isEnabled = true
        }else{
            alertController.actions[0].isEnabled = false
        }
        
        return true;
    }
}
