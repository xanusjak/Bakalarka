//
//  SimulationViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 09/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class StartSimulationViewController: BaseViewController {

    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    fileprivate var graphData: [[Double]]!
    
    open var graphView: GraphView!
    
    fileprivate let backButton: BackButton! = {
        var button = BackButton()
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    fileprivate let startSimulationButton = MAButton(title: "Start Simulation", color: .customGreenColor(), target: self, action: #selector(startSimulation))
    
    fileprivate let stopSimulationButton = MAButton(title: "Stop Simulation", color: .customRedColor(), target: self, action: #selector(stopSimulation))
    
    init(modelName: String, modelDict: [String:Any]) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
        self.modelDict = modelDict
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        
        self.view.addSubview(backButton)
        self.view.addSubview(startSimulationButton)
        
        stopSimulationButton.isHidden = true
        self.view.addSubview(stopSimulationButton)
        
        graphView = GraphView(modelName: modelName)
        self.view.addSubview(graphView)
    }
    
    override func setupConstraints() {
        
        backButton.autoPinEdge(toSuperviewEdge: .top)
        backButton.autoPinEdge(toSuperviewEdge: .left)
        
        startSimulationButton.autoSetDimensions(to: CGSize(width: 150, height: 30))
        startSimulationButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        startSimulationButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        
        stopSimulationButton.autoSetDimensions(to: CGSize(width: 150, height: 30))
        stopSimulationButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        stopSimulationButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)

        graphView.autoPinEdgesToSuperviewEdges(with: .init(top: 50, left: 10, bottom: 10, right: 10))
    }
    
    @objc func startSimulation() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.startSimulation(self.modelName)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.graphView.setupDataTimer()
            }
        }
        
        startSimulationButton.isHidden = true
        
        stopSimulationButton.isHidden = false
        backButton.isEnabled = false
    }
    
    @objc func stopSimulation() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            MatlabService.sharedClient.stopSimulation(self.modelName)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.graphView.timer.invalidate()
            }
        }
        
        startSimulationButton.isHidden = false
        
        stopSimulationButton.isHidden = true
        backButton.isEnabled = true
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
}
