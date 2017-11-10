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
    
    fileprivate let startButton = MAButton(title: "Start Simulation", color: .customGreenColor(), target: self, action: #selector(startSimulation), rounded: false)
    
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
        self.view.addSubview(startButton)
    }
    
    override func setupConstraints() {
        startButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    func getGraphData() -> [[Double]]{
        let data = MatlabService.sharedClient.getScopeData(modelName)
        var graphData = [[Double]]()
        if let scope = data[modelName + "/Scope"] as? Dictionary<String,Any> {
            if let arrays = scope["1.0"] as? [[Any]] {
                for arr in arrays {
                    let doubleValues = arr as! [Double]
                    print("\n\nDOUBLE: \(doubleValues)")
                    graphData.append(doubleValues)
                }
            }
        }
        return graphData
    }
    
    @objc func startSimulation() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let alertController = SpinnerAlertViewController(title: " ", message: "Starting simulation...", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            MatlabService.sharedClient.startSimulation(self.modelName)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                MatlabService.sharedClient.stopSimulation(self.modelName)
                self.navigationController?.pushViewController(StartSimulationViewController(modelName: self.modelName, modelDict: self.modelDict), animated: true)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
