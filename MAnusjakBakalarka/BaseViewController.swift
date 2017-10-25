//
//  BaseViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 19/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var didSetupConstrainst: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTitle()
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        setupLoadView()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstrainst {
            self.setupConstraints()
            self.didSetupConstrainst = true
        }
        super.updateViewConstraints()
    }

    func setupTitle() {
        fatalError("should be overwritten")
    }
    
    func setupLoadView() {
        fatalError("should be overwritten")
    }
    
    func setupConstraints() {
        fatalError("should be overwritten")
    }
}
