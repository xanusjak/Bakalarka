//
//  SimulationTableViewCell.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 17/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class EditParamCell: UITableViewCell {

    fileprivate var modelName: String!
    fileprivate var blockName: String!
    fileprivate var paramInfo: [String:Any]!
    fileprivate var controller: BaseViewController!
    
    fileprivate var enumList: [String]!
    
    fileprivate var label: UILabel! = {
        var label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    fileprivate var field: UITextField! = {
        var field = UITextField()
        field.textAlignment = .center
        field.keyboardType = .numbersAndPunctuation
        return field
    }()
    
    fileprivate let switcher: UISwitch! = {
        var switcher = UISwitch()
        switcher.isOn = true
        switcher.onTintColor = .customBlueColor()
        return switcher
    }()
    
    fileprivate var enumLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    func getCellName() -> String {
        return label.text!
    }
    
    init(modelName: String, blockName: String, paramInfo: [String:Any], reuseIdentifier: String, viewController: BaseViewController) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.modelName = modelName
        self.blockName = blockName
        self.paramInfo = paramInfo
        self.controller = viewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        
        label.text = paramInfo["displayName"] as? String
        self.addSubview(label)
        label.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 15, bottom: 0, right: 0), excludingEdge: .right)
        
        if paramInfo["type"] as? String == "STRING" {
            let value = paramInfo["defaultValue"] as! String
            setupFieldView(value: value)
        }
        else if paramInfo["type"] as? String == "BOOLEAN" {
            let value: Bool!
            if paramInfo["defaultValue"] as! String == "on" {
                value = true
            }
            else {
                value = false
            }
            setupSwitcherView(value: value)
        }
        else if paramInfo["type"] as? String == "ENUM" {
            enumList = [String]()
            for eachEnum in paramInfo["enumList"] as! [String] {
                enumList.append(eachEnum)
            }
            setupEnumLabel(value: paramInfo["defaultValue"] as! String)
        }
    }

    func setupFieldView(value: String){
        
        field.delegate = self
        field.text = value
        self.addSubview(field)
        
        field.autoSetDimension(.width, toSize: 100)
        field.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 10, bottom: 10, right: 15), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: field, withOffset: -10)
    }
    
    func setupSwitcherView(value: Bool){
        
        switcher.isOn = value
        switcher.addTarget(self, action: #selector(switcherChangeState(_:)), for: .valueChanged)
        self.addSubview(switcher)
        
        switcher.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 0, bottom: 10, right: 15), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: switcher, withOffset: -30)
    }
    
    @objc func switcherChangeState(_ sender: UISwitch) {
        //TODO: change param value after switcher
        print("\n" + self.modelName)
        print(self.blockName)
        print(self.paramInfo["simulinkName"] as! String)
        let param = self.paramInfo["simulinkName"] as! String
        
        if sender.isOn {
            print("VALUE: on")
            MatlabService.sharedClient.getParamValue(modelName: self.modelName, blockName: self.blockName, paramName: param)
        }
        else {
            print("VALUE: off")
            MatlabService.sharedClient.getParamValue(modelName: self.modelName, blockName: self.blockName, paramName: param)
        }
    }
    
    func setupEnumLabel(value: String) {
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(chooseEnumValue))
        enumLabel.addGestureRecognizer(tap)
        enumLabel.text = value
        self.addSubview(enumLabel)
        
        enumLabel.autoSetDimension(.width, toSize: 100)
        enumLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: 0, right: 15), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: enumLabel, withOffset: -10)
    }
    
    @objc func chooseEnumValue() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for enumString in enumList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                self.enumLabel.text = enumString
                
                //TODO: change param value after enum
                print("\n" + self.modelName)
                print(self.blockName)
                print(self.paramInfo["simulinkName"] as! String)
                print("VALUE: " + enumString)
                let param = self.paramInfo["simulinkName"] as! String
                MatlabService.sharedClient.getParamValue(modelName: self.modelName, blockName: self.blockName, paramName: param)
            }
            alert.addAction(choise)
        }
        
        controller.present(alert, animated: true, completion: nil)
        
    }
}

extension EditParamCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        //TODO: change param value after textfield
        print("\n" + self.modelName)
        print(self.blockName)
        print(self.paramInfo["simulinkName"] as! String)
        print("VALUE: " + textField.text!)
        let param = self.paramInfo["simulinkName"] as! String
        MatlabService.sharedClient.getParamValue(modelName: self.modelName, blockName: self.blockName, paramName: param)
        return true
    }
}


