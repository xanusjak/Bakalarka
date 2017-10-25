//
//  ConfigViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 10/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class ConfigViewController: BaseViewController {

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
    
    fileprivate let saveButton: UIButton! = {
        var button = UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveChangedIp), for: .touchUpInside)
        button.backgroundColor = UIColor.customBlueColor()
        return button
    }()
    
    init(trueOrFalse: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isPinging = trueOrFalse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        saveButton.autoSetDimension(.height, toSize: 50)
        saveButton.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    @objc func saveChangedIp() {
        
        let alertController = SpinnerAlertViewController(title: " ", message: "Checking ip...", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.isPinging = MatlabService.sharedClient.checkIpPing()
            DispatchQueue.main.async {
                alertController.dismiss(animated: true, completion: nil)
                self.upadateStatusLabel()
            }
        }
    }
}


extension ConfigViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Path.changeIp = self.ipTextField.text!
        Path.ip = "http://" + Path.changeIp + ":8080/matlabadapter/api/matlab/"
        print(Path.ip)
        self.view.endEditing(true)
        return true
    }
}
