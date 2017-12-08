//
//  ChoosenParamsTableView.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 27/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class EditParamsTableView: UITableView {
    
    fileprivate var controller: BaseViewController!
    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    fileprivate var modelSelectedParams: [String:Any]!
    
    fileprivate var blocks: [String]!
    fileprivate var paramsInBlock = [String]()
    
    fileprivate let noChoosenLabel: UILabel! = {
        let label: UILabel = UILabel()
        label.text = "No selected parameters."
        label.textColor = .customBlueColor()
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    init(modelName: String, modelDict: [String:Any], viewController: BaseViewController) {
        super.init(frame: .zero, style: .plain)
        self.modelName = modelName
        self.modelDict = modelDict
        self.controller = viewController
        
        setupView()
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.loadTableData()
        
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = true
        self.alwaysBounceVertical = true
        self.backgroundColor = UIColor.clear
        self.showsVerticalScrollIndicator = false
        self.separatorStyle = .singleLine
        self.register(SimulationTableViewCell.self, forCellReuseIdentifier: "simulationCell")
    }
    
    func loadTableData() {
        modelSelectedParams = getDictionary(forKey: "\(self.modelName as String)SelectedParams")
        if modelSelectedParams != nil {
            blocks = Array(modelSelectedParams.keys).sorted(by: <)
        }
        else {
            blocks = [String]()
        }
    }
}

extension EditParamsTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if blocks.count == 0 {
            self.backgroundView  = noChoosenLabel
            self.separatorStyle = .none
        }
        else {
            self.backgroundView  = nil
            self.separatorStyle = .singleLine
        }
        return blocks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return blocks[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.backgroundView?.backgroundColor = .customBlueColor()
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
        
        let cell = SimulationTableViewCell(text: paramName, paramInfo: paramInfo, reuseIdentifier: "simulationCell", viewController: controller)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension EditParamsTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            if editingStyle == .delete {
                
                let tmpKey = Array(modelSelectedParams.keys).sorted(by: <)[indexPath.section]
                var block = modelSelectedParams[tmpKey] as! [String]
                block.remove(at: indexPath.row)
                
                if block.count > 0 {
                    modelSelectedParams[tmpKey] = block
                }
                else {
                    modelSelectedParams.removeValue(forKey: tmpKey)
                }
            
                saveDictionary(dict: modelSelectedParams, forKey: "\(modelName as String)SelectedParams")
                print(modelSelectedParams as Any)
                self.loadTableData()
                self.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 0 {
            return false
        }
        return true
    }
}
