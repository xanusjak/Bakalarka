//
//  SpinnerAlertViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 02/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class SpinnerAlertViewController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let spinner = UIActivityIndicatorView(frame: CGRect(x: 115, y: 20, width: 20, height: 20))
        spinner.color = .black
        spinner.startAnimating()
        
        self.view.addSubview(spinner)
    }
}
