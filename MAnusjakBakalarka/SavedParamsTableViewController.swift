//
//  SavedParamsTableViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 29/11/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SavedParamsTableViewController: BaseViewController {

    fileprivate var modelName: String!
    
    fileprivate var combinations = [String]()
    
    fileprivate var tableView = UITableView()
    
    init(modelName: String) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTableData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = "Select combination"
    }
    
    override func setupLoadView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges()
    }

    func loadTableData() {
        if let dict = getDictionary(forKey: "\(self.modelName as String)SavedCombinations") {
            combinations = Array(dict.keys).sorted(by: <)
        }
    }
}

extension SavedParamsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = combinations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension SavedParamsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let combination = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            if let savedCombinations = getDictionary(forKey: "\(self.modelName as String)SavedCombinations") {
                if let selected = savedCombinations[combination] as? [String:Any] {
                    saveDictionary(dict: selected, forKey: "\(self.modelName as String)SelectedParams")
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if var savedCombinations = getDictionary(forKey: "\(self.modelName as String)SavedCombinations") {
                
                if let key = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                    savedCombinations.removeValue(forKey: key)
                    saveDictionary(dict: savedCombinations, forKey: "\(self.modelName as String)SavedCombinations")
                }
            }
            
            self.loadTableData()
            tableView.reloadData()
        }
        
    }
}
