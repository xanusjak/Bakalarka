//
//  ChoosenParamsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 27/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class EditParamsViewController: BaseViewController {

    fileprivate var modelName: String!
    fileprivate var modelDict: [String:Any]!
    fileprivate var savedCombinations: [String:Any]!
    
    fileprivate var tableView: EditParamsTableView!
    
    fileprivate var alertController: UIAlertController!
    
    fileprivate let saveButton = MAButton(title: "Save combination", color: .customBlueColor(), target: self, action: #selector(saveCombination), rounded: false)
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .done, target: self, action: #selector(selectSavedParams))
        self.navigationItem.rightBarButtonItem?.tintColor = .customBlueColor()
        
        tableView.loadTableData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = "Edit"
    }
    
    override func setupLoadView() {
        
        tableView = EditParamsTableView(modelName: modelName, modelDict: modelDict, viewController: self)
        tableView.tag = 1
        self.view.addSubview(tableView)
        
        self.view.addSubview(saveButton)
    }
    
    override func setupConstraints() {
        
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        tableView.autoPinEdge(.bottom, to: .top, of: saveButton)
        
        saveButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func selectSavedParams() {
        
        self.navigationController?.pushViewController(SavedParamsTableViewController(modelName: modelName), animated: true)
    }
    
    @objc func saveCombination() {
        alertController = UIAlertController(title: nil, message: "Save as:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let combinationName = self.alertController.textFields![0].text {
                
                if let dict = getDictionary(forKey: "\(self.modelName as String)SavedCombinations") {
                    self.savedCombinations = dict
                }
                else {
                    self.savedCombinations = [String:Any]()
                }
                
                let modelSelectedParams = getDictionary(forKey: "\(self.modelName as String)SelectedParams") as Any
                self.savedCombinations[combinationName] = modelSelectedParams
                
                saveDictionary(dict: self.savedCombinations, forKey: "\(self.modelName as String)SavedCombinations")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = "Combination name"
        }
        
        alertController.addAction(confirmAction)
        alertController.actions[0].isEnabled = false
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension EditParamsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location - range.length > 1) { //minimum 3 chars
            alertController.actions[0].isEnabled = true
        }else{
            alertController.actions[0].isEnabled = false
        }
        
        return true;
    }
}
