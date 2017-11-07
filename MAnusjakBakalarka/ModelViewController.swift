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
    
    fileprivate var choosenParamsButton = MAButton(title: "Edit Parameters", color: .customBlueColor(), target: self, action: #selector(openChoosenParams))
    
    fileprivate var uploadButton = MAButton(title: "Upload Model", color: .customBlueColor(), target: self, action: #selector(uploadModel))
    
    fileprivate var startSimButton = MAButton(title: "Start Simulation", color: .customGreenColor(), target: self, action: #selector(startSimulation))
    
    fileprivate var closeModelButton = MAButton(title: "Close Model", color: .customRedColor(), target: self, action: #selector(closeMatlabModel))
    
    init(modelName: String) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
        
        let dict = MatlabService.sharedClient.getModelInfo(modelName)
        saveDictionary(dict: dict, forKey: modelName + "Dict") //TODO: do I need this?
        self.modelDict = dict
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = modelName
    }
    
    override func setupLoadView() {
        
        view.addSubview(chooseParamsButton)
        view.addSubview(choosenParamsButton)
        view.addSubview(startSimButton)
        view.addSubview(uploadButton)
        view.addSubview(closeModelButton)
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
        
        closeModelButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
}

//BUTTONS ACTIONS
extension ModelViewController {
    
    @objc func openChoseParamsVC() {
        self.navigationController?.pushViewController(ChooseBlockViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func openChoosenParams() {
        self.navigationController?.pushViewController(ChoosenParamsViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func startSimulation() {
        self.navigationController?.pushViewController(SimulationViewController(modelName: modelName, modelDict: modelDict), animated: true)
    }
    
    @objc func uploadModel() {
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
