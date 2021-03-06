//
//  GraphsView.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 18/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import UIKit
import ScrollableGraphView

class GraphView: UIView{
    
    fileprivate var graphView: ScrollableGraphView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.backgroundColor = .white
        
        graphView = createMultiPlotGraphOne(self.frame)
        self.addSubview(graphView)
    }
    
    func setupConstraints() {
        graphView.autoPinEdgesToSuperviewEdges()
    }
    
    fileprivate func createMultiPlotGraphOne(_ frame: CGRect) -> ScrollableGraphView {
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
        referenceLines.referenceLineLabelColor = UIColor.black
        referenceLines.positionType = .relative
        referenceLines.referenceLineNumberOfDecimalPlaces = 1
        referenceLines.referenceLineNumberStyle = .decimal
        referenceLines.relativePositions = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
        referenceLines.dataPointLabelColor = UIColor.black
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.white
        graphView.dataPointSpacing = 3
        graphView.shouldAnimateOnStartup = false
        graphView.shouldAdaptRange = false
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.rangeMax = 1
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
        
        return graphView
    }
    
    func getDat() -> [[Double]] {
        var myScopeData = [[Double]]()
        var scopeData = MatlabService.sharedClient.getTestScopeData()
    
        if let scope = scopeData["vrmaglev/Scope"] as? Dictionary<String,Any> {
            if let arrays = scope["1.0"] as? [Any] {
                for arr in arrays{
                    if let fArrayNumbers = arr as? [Double] {
                        myScopeData.append(fArrayNumbers)
                    }
                }
            }
        }
        return myScopeData
    }
    
}

extension GraphView: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        switch plot.identifier {
            
            case "multiBlue":
                return getDat()[1][pointIndex]
            case "multiOrange":
                return getDat()[2][pointIndex]
            
            default:
                return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return getDat()[0].count
    }
    
}

