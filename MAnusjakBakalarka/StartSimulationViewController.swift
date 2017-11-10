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
    
    fileprivate var tableView: EditParamsTableView!
    
    fileprivate var graphView: GraphView!
    
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
        
        graphView = GraphView(modelName: modelName, withAnimation: true)
        graphView.layer.borderColor = UIColor.customBlueColor().cgColor
        graphView.layer.borderWidth = 1.0
        
        tableView = EditParamsTableView(modelName: modelName, modelDict: modelDict, viewController: self)
        tableView.tag = 0
        self.view.addSubview(tableView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(openGraph))
        graphView.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(graphView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        tableView.autoPinEdge(.bottom, to: .top, of: graphView, withOffset: 0)
        
        graphView.autoSetDimension(.height, toSize: UIScreen.main.bounds.size.height/2.5)
        graphView.autoPinEdgesToSuperviewEdges(with: .init(top: 2, left: 2, bottom: 2, right: 2), excludingEdge: .top)
    }
    
    @objc func openGraph() {
        self.navigationController?.pushViewController(GraphViewController(modelName: modelName), animated: true)
    }
}
