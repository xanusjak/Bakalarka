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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllSelectedParams))
        self.navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        
        tableView = ChoosenParamsTableView(modelName: modelName, modelDict: modelDict, viewController: self)
        tableView.tag = 1
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    @objc func deleteAllSelectedParams() {
        
        let modelSelectedParams = [String:Any]()
        saveDictionary(dict: modelSelectedParams, forKey: "\(modelName)SelectedParams")
       
        tableView.loadTableData()
        tableView.reloadData()
    }
}
