//
//  SimulationViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 09/11/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SimulationViewController: BaseViewController {

    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    
    fileprivate let intervalLabel: UILabel! = {
        var label = UILabel()
        label.text = "Interval simulation"
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        label.sizeToFit()
        return label
    }()
    
    fileprivate let intervalSwitcher: UISwitch! = {
        var switcher = UISwitch()
        switcher.isOn = true
        switcher.onTintColor = .customBlueColor()
        return switcher
    }()
    
    fileprivate let stepperLabel: UILabel! = {
        var label = UILabel()
        label.text = "10 s"
        label.textAlignment = .center
        label.textColor = .customBlueColor()
        return label
    }()
    
    fileprivate let stepper: UIStepper! = {
        var stepper = UIStepper()
        stepper.minimumValue = 1.0
        stepper.value = 10.0
        stepper.maximumValue = 100.0
        stepper.addTarget(self, action: #selector(changedSteper(_:)), for: .valueChanged)
        return stepper
    }()
    
    fileprivate let startButton = MAButton(title: "Start Simulation", color: .customGreenColor(), target: self, action: #selector(startSimulation), rounded: true)
    
    init(modelName: String, modelDict: [String:Any]) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
        self.modelDict = modelDict
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
        
        self.view.addSubview(intervalLabel)
        self.view.addSubview(intervalSwitcher)
        
        self.view.addSubview(stepperLabel)
        self.view.addSubview(stepper)
        
        self.view.addSubview(startButton)
    }
    
    override func setupConstraints() {
        
        intervalLabel.autoSetDimension(.height, toSize: 30)
        intervalLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        intervalLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 25)
        
        intervalSwitcher.autoPinEdge(toSuperviewEdge: .right, withInset: 40)
        intervalSwitcher.autoPinEdge(.top, to: .top, of: intervalLabel)
        
        stepperLabel.autoSetDimension(.height, toSize: 30)
        stepperLabel.autoPinEdge(.right, to: .right, of: intervalLabel)
        stepperLabel.autoPinEdge(.left, to: .left, of: intervalLabel)
        stepperLabel.autoPinEdge(.top, to: .bottom, of: intervalLabel, withOffset: 15)
        
        stepper.autoPinEdge(toSuperviewEdge: .right, withInset: 25)
        stepper.autoPinEdge(.top, to: .top, of: stepperLabel)
        
        startButton.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 15, bottom: 25, right: 15), excludingEdge: .top)
    }
    
    @objc func changedSteper(_ sender: UIStepper) {
        stepperLabel.text = String(Int(sender.value)) + " s"
    }
    
    @objc func startSimulation() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let alertController = SpinnerAlertViewController(title: " ", message: "Starting simulation...", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            MatlabService.sharedClient.startSimulation(self.modelName)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepper.value) {
                MatlabService.sharedClient.stopSimulation(self.modelName)
                self.navigationController?.pushViewController(StartSimulationViewController(modelName: self.modelName, modelDict: self.modelDict), animated: true)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
