//
//  ChoosenParamsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 27/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class ChoosenParamsViewController: BaseViewController {

    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    
    fileprivate var tableView: ChoosenParamsTableView!
    
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
        self.title = "Params"
    }
    
    override func setupLoadView() {
        
        tableView = ChoosenParamsTableView(modelName: modelName, modelDict: modelDict, viewController: self)
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
}
