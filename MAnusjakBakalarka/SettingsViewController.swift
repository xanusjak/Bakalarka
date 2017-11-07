//
//  SettingsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 10/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    fileprivate var isPinging: Bool!
    
    fileprivate var ipStatusLabel: UILabel! = {
        var label = UILabel()
        label.text = "Good IP"
        label.textColor = UIColor.customGreenColor()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate var ipTextField: UITextField! = {
        var textField = UITextField()
        textField.text = Path.changeIp
        textField.textAlignment = .center
        return textField
    }()
    
    fileprivate let saveButton = MAButton(title: "Done", color: .customBlueColor(), target: self, action: #selector(saveChangedIp))
    
    init(haveConnection: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isPinging = haveConnection
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upadateStatusLabel()
    }
    
    func upadateStatusLabel() {
        if isPinging {
            ipStatusLabel.text = "Good IP"
            ipStatusLabel.textColor = UIColor.customGreenColor()
        }
        else {
            ipStatusLabel.text = "Wrong IP"
            ipStatusLabel.textColor = UIColor.customRedColor()
        }
    }
    
    override func setupTitle() {
        self.title = "Change IP"
    }
    
    override func setupLoadView() {
        self.view.addSubview(ipStatusLabel)
        ipTextField.delegate = self
        self.view.addSubview(ipTextField)
        self.view.addSubview(saveButton)
    }
    
    override func setupConstraints() {
        
        ipStatusLabel.autoSetDimension(.height, toSize: 50)
        ipStatusLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        ipStatusLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        ipStatusLabel.autoPinEdge(.bottom, to: .top, of: ipTextField, withOffset: 0)
        
        ipTextField.autoSetDimension(.height, toSize: 50)
        ipTextField.autoPinEdge(toSuperviewEdge: .left, withInset: 15)
        ipTextField.autoPinEdge(toSuperviewEdge: .right, withInset: 15)
        ipTextField.autoPinEdge(toSuperviewEdge: .top, withInset: (UIScreen.main.bounds.size.height-200)/2)
        
        saveButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func saveChangedIp() {
        if isPinging {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let alert = UIAlertController(title: "Enter", message: "correct IP address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
}


extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        Path.changeIp = self.ipTextField.text!
        Path.ip = "http://" + Path.changeIp + ":8080/matlabadapter/api/matlab/"
        
        isPinging = MatlabService.sharedClient.checkIpPing()
        self.upadateStatusLabel()
        
        self.view.endEditing(true)
        return true
    }
}
