//
//  GraphViewController.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 24/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit

class GraphViewController: BaseViewController {

    fileprivate let graphsView : GraphView! = {
        var view = GraphView()
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
        self.title = ""
    }
    
    override func setupLoadView() {
        
        self.view.addSubview(graphsView)
        self.view.addSubview(backButton)
    }
    
    override func setupConstraints() {
        
        graphsView.autoPinEdgesToSuperviewEdges(with: .init(top: 50, left: 10, bottom: 0, right: 10))
        
        backButton.autoPinEdge(toSuperviewEdge: .top)
        backButton.autoPinEdge(toSuperviewEdge: .left)
    }

    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
}
