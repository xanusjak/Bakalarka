//
//  ChooseParamsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 10/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class ChooseParamsViewController: BaseViewController {
    
    fileprivate var modelName: String!
    
    fileprivate var blockName: String!
    
    fileprivate var modelDict: [String:Any]!
    
    fileprivate var modelSelectedParams: [String:Any]!
    
    fileprivate var blockParams = [String]()
    
    fileprivate var table: UITableView! = {
        var table = UITableView(frame: .zero, style: .plain)
        table.isScrollEnabled = true
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .singleLine
        table.allowsMultipleSelection = true
        table.register(TableViewCell.self, forCellReuseIdentifier: "paramCell")
        return table
    }()
    
    fileprivate let saveButton = MAButton(title: "Save", color: .customBlueColor(), target: self, action: #selector(saveSelectedParameters))
    
    init(modelName: String, blockName: String, modelDict: [String:Any]) {
        super.init(nibName: nil, bundle: nil)
        self.modelName = modelName
        self.blockName = blockName
        self.modelDict = modelDict
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadModelSelectedParams()
    }
    
    func loadModelSelectedParams() {
        
        if let dict = getDictionary(forKey: "\(modelName)SelectedParams") {
            modelSelectedParams = dict
        }
        else {
            modelSelectedParams = [String:Any]()
        }
        
        if let paramsDict = modelDict[blockName] as? [Dictionary<String, Any>] {
            for param in paramsDict {
                if let string = param["displayName"] as? String {
                    blockParams.append(string)
                }
            }
        }
    }
    
    override func setupTitle() {
        self.title = blockName
    }
    
    override func setupLoadView() {
        table.dataSource = self
        table.delegate = self
        
        self.view.addSubview(table)
        self.view.addSubview(saveButton)
    }
    
    override func setupConstraints() {

        table.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        table.autoPinEdge(.bottom, to: .top, of: saveButton)
        
        saveButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func saveSelectedParameters() {
        
        var selectedParams = [String]()
        for cell in table.visibleCells {
            if cell.isSelected {
                selectedParams.append((cell.textLabel?.text)!)
            }
        }
        
        modelSelectedParams[blockName] = selectedParams
        if !(selectedParams.count > 0) {
            modelSelectedParams.removeValue(forKey: blockName)
        }
        saveDictionary(dict: modelSelectedParams, forKey: "\(modelName)SelectedParams")
        
        self.navigationController?.popViewController(animated: true)
    }
}


extension ChooseParamsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockParams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "paramCell")
        cell.textLabel?.text = blockParams[indexPath.row]
        
        if let selectedParams = modelSelectedParams[blockName] as? [String] {
            for nameText in selectedParams {
                if cell.textLabel?.text == nameText {
                    cell.accessoryType = .checkmark
                }
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


extension ChooseParamsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.accessoryType == .checkmark) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
