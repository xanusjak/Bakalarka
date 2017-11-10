//
//  ChooseBlockViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 09/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SelectBlockViewController: BaseViewController {

    fileprivate var modelName: String!
    
    fileprivate var modelDict: [String:Any]!
    
    fileprivate var blocks: [String]!
    
    fileprivate var tableView: UITableView! = {
        var table = UITableView(frame: .zero, style: .plain)
        table.isScrollEnabled = true
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.register(TableViewCell.self, forCellReuseIdentifier: "blockCell")
        return table
    }()
    
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
        
        blocks = Array(modelDict.keys).sorted(by: <)
    }
    
    override func setupTitle() {
        self.title = ""
    }
    
    override func setupLoadView() {
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
}


extension SelectBlockViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TableViewCell(style: .default, reuseIdentifier: "blockCell")
        cell.textLabel?.text = blocks[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension SelectBlockViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = SelectParamsViewController(modelName: modelName, blockName: blocks[indexPath.row], modelDict: modelDict)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
