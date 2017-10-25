//
//  SimulationTableViewCell.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 17/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SimulationTableViewCell: UITableViewCell {

    fileprivate var controller: BaseViewController!
    fileprivate var paramInfo: [String:Any]!
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
        switcher.onTintColor = UIColor.customBlueColor()
        return switcher
    }()
    
    fileprivate var enumLabel: UILabel! = {
        var label = UILabel()
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init(text: String, paramInfo: [String:Any], reuseIdentifier: String, viewController: BaseViewController) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        label.text = text
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
            setupEnumButton(value: paramInfo["defaultValue"] as! String)
        }
    }

    func setupFieldView(value: String){
        
        field.delegate = self
        field.text = value
        self.addSubview(field)
        
        field.autoSetDimension(.width, toSize: 50)
        field.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 10, bottom: 10, right: 15), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: field, withOffset: -10)
    }
    
    func setupSwitcherView(value: Bool){
        
        switcher.isOn = value
        self.addSubview(switcher)
        
        switcher.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 0, bottom: 10, right: 15), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: switcher, withOffset: -20)
    }
    
    func setupEnumButton(value: String) {
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(openVolaco))
        enumLabel.addGestureRecognizer(tap)
        enumLabel.text = value
        self.addSubview(enumLabel)
        
        enumLabel.autoSetDimension(.width, toSize: 100)
        enumLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 0, left: 0, bottom: 0, right: 5), excludingEdge: .left)
        
        label.autoPinEdge(.right, to: .left, of: enumLabel, withOffset: -10)
    }
    
    @objc func openVolaco() {
        
        let alert = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)
        
        for enumString in enumList {
            let choise = UIAlertAction(title: enumString, style: .default) {
                _ in
                self.enumLabel.text = enumString
            }
            alert.addAction(choise)
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
}

extension SimulationTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if (allowedCharacters.isSuperset(of: characterSet)) {
            return true
        }
        else {
            return false
        }
    }
}

extension SimulationTableViewCell: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return enumList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return enumList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
