//
//  SimulationViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 09/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SimulationViewController: BaseViewController {

    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    fileprivate var modelSelectedParams: [String:Any]!
    
    fileprivate var blocks: [String]!
    fileprivate var paramsInBlock = [String]()
    
    fileprivate var tableView: UITableView! = {
        var table = UITableView(frame: .zero, style: .plain)
        table.isScrollEnabled = true
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.register(TableViewCell.self, forCellReuseIdentifier: "simulationCell")
        return table
    }()
    
    fileprivate let graphsView = GraphsView()
    
    //////////////////////////////////////////////////////////////////////////////////////////////
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
        
        modelSelectedParams = getDictionary(forKey: "\(modelName)SelectedParams")
        if modelSelectedParams != nil {
            blocks = Array(modelSelectedParams.keys).sorted(by: <)
        }
        else {
            blocks = [String]()
        }
    }
    
    override func setupTitle() {
        self.title = "Simulation"
    }
    
    override func setupLoadView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(openGraphs))
        graphsView.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(graphsView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        tableView.autoPinEdge(.bottom, to: .top, of: graphsView, withOffset: 0)
        
        graphsView.autoSetDimension(.height, toSize: 200)
        graphsView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func openGraphs() {
        self.navigationController?.pushViewController(GraphsViewController(), animated: true)
    }
}

extension SimulationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return blocks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return blocks[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        paramsInBlock = modelSelectedParams[blocks[section]] as! [String]
        return paramsInBlock.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let blockName = blocks[indexPath.section]
        
        paramsInBlock = modelSelectedParams[blockName] as! [String]
        let paramName = paramsInBlock[indexPath.row]
        var paramInfo: [String:Any]!
        
        if let block = modelDict[blockName] as? [Dictionary<String, Any>] {
            for param in block {
                if param["displayName"] as? String == paramName {
                    paramInfo = param
                }
            }
        }
        
        let cell = SimulationTableViewCell(text: paramName, paramInfo: paramInfo, reuseIdentifier: "simulationCell", viewController: self)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension SimulationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}
