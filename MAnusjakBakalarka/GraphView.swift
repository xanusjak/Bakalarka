//
//  GraphView.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 27/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit
import ScrollableGraphView

class GraphView: UIView {
    
    fileprivate var graph: ScrollableGraphView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.customBlueColor()
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        graph = createGraph(.zero)
        self.addSubview(graph)
    }
    
    fileprivate func createGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        //TODO:
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the first plot.
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineColor = UIColor.blue
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineColor = UIColor.orange
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.relativePositions = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.white
        
        graphView.dataPointSpacing = 3
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
        
        return graphView
    }
    
    func setupConstraints() {
    
        graph.autoPinEdgesToSuperviewEdges()
    }
}

extension GraphView: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return 10
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return 100
    }
}
