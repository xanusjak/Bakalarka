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
    
    fileprivate var chooseParamsButton: UIButton! = {
        var chooseParamsButton = UIButton()
        chooseParamsButton.setTitle("Chose parameters", for: .normal)
        chooseParamsButton.addTarget(self, action: #selector(openChoseParamsVC), for: .touchUpInside)
        chooseParamsButton.backgroundColor = UIColor.customBlueColor()
        return chooseParamsButton
    }()
    
    fileprivate var choosenParamsButton: UIButton! = {
        var choosenParamsButton = UIButton()
        choosenParamsButton.setTitle("Choosen Params", for: .normal)
        choosenParamsButton.addTarget(self, action: #selector(openChoosenParams), for: .touchUpInside)
        choosenParamsButton.backgroundColor = UIColor.customBlueColor()
        return choosenParamsButton
    }()
    
    fileprivate var startSimButton: UIButton! = {
        var startSimButton = UIButton()
        startSimButton.setTitle("Simulation", for: .normal)
        startSimButton.addTarget(self, action: #selector(openSimulationVC), for: .touchUpInside)
        startSimButton.backgroundColor = UIColor.customBlueColor()
        return startSimButton
    }()
    
    fileprivate var uploadButton: UIButton! = {
        var uploadButton = UIButton()
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadModel), for: .touchUpInside)
        uploadButton.backgroundColor = UIColor.customBlueColor()
        return uploadButton
    }()
    
    fileprivate var closeModelButton: UIButton! = {
        var closeModelButton = UIButton()
        closeModelButton.setTitle("Close Model", for: .normal)
        closeModelButton.addTarget(self, action: #selector(closeMatlabModel), for: .touchUpInside)
        closeModelButton.backgroundColor = UIColor.customRedColor()
        return closeModelButton
    }()
    
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
        
        chooseParamsButton.autoSetDimension(.height, toSize: 50)
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        chooseParamsButton.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        
        choosenParamsButton.autoSetDimension(.height, toSize: 50)
        choosenParamsButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        choosenParamsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        choosenParamsButton.autoPinEdge(.top, to: .bottom, of: chooseParamsButton, withOffset: 20)
        
        startSimButton.autoSetDimension(.height, toSize: 50)
        startSimButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        startSimButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        startSimButton.autoPinEdge(.top, to: .bottom, of: choosenParamsButton, withOffset: 20)
        
        uploadButton.autoSetDimension(.height, toSize: 50)
        uploadButton.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        uploadButton.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        uploadButton.autoPinEdge(.top, to: .bottom, of: startSimButton, withOffset: 20)
        
        closeModelButton.autoSetDimension(.height, toSize: 50)
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
    
    @objc func openSimulationVC() {
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
                alertController.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
