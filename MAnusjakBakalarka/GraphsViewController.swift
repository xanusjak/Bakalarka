//
//  GraphsViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 24/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class GraphsViewController: BaseViewController {

    fileprivate let graphsView : GraphsView! = {
        var view = GraphsView()
        return view
    }()
    
    fileprivate let backButton: BackButton! = {
        var button = BackButton()
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupTitle() {
        self.title = "Graphs"
    }
    
    override func setupLoadView() {
        
        self.view.addSubview(graphsView)
        self.view.addSubview(backButton)
    }
    
    override func setupConstraints() {
        
        graphsView.autoPinEdgesToSuperviewEdges()
        
        backButton.autoPinEdge(toSuperviewEdge: .top)
        backButton.autoPinEdge(toSuperviewEdge: .left)
    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
}
