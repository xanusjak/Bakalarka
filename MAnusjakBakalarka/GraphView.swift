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
    
    fileprivate var modelName: String!
    fileprivate var graphData = [[Double]]()
    fileprivate var animation: Bool!
    fileprivate var pointsNumber: Int = 0
    
    fileprivate var graph: ScrollableGraphView!
    
    init(modelName: String, withAnimation: Bool) {
        super.init(frame: .zero)
        self.modelName = modelName
        self.animation = withAnimation
        
        self.graphData = getGraphData()
        
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

        if graphData.count > 0 {
            pointsNumber = graphData[0].count
            
            // Setup the reference lines.
            let referenceLines = ReferenceLines()

            referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
            referenceLines.referenceLineColor = UIColor.black.withAlphaComponent(0.2)
            referenceLines.referenceLineLabelColor = UIColor.black
            referenceLines.referenceLineNumberOfDecimalPlaces = 1
            referenceLines.referenceLineNumberStyle = .decimal
//            referenceLines.relativePositions = [0.2, 0.4, 0.6, 0.8, 1]

            referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1)
            
            //Add to the graph.
            graphView.addReferenceLines(referenceLines: referenceLines)

            // Setup the graph
            graphView.backgroundFillColor = UIColor.white

            graphView.dataPointSpacing = 3
            graphView.rangeMax = (graphData[1].max()?.rounded())!

//            graphView.shouldAnimateOnStartup = true
//            graphView.shouldAdaptRange = true
            graphView.shouldRangeAlwaysStartAtZero = true

            //Add plots
            for index in 1..<graphData.count {
                
                let plot = LinePlot(identifier: "plot\(index)")
                plot.lineColor = UIColor.getRandomColor(index: index)
//                plot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//                plot.animationDuration = 1
                
                graphView.addPlot(plot: plot)
            }
        }
       
        return graphView
    }
    
    func setupConstraints() {
        graph.autoPinEdgesToSuperviewEdges()
    }
    
    func getGraphData() -> [[Double]]{
        let data = MatlabService.sharedClient.getScopeData(modelName)
        var graphData = [[Double]]()
        if let scope = data[modelName + "/Scope"] as? Dictionary<String,Any> {
            if let arrays = scope["1.0"] as? [[Any]] {
                for arr in arrays {
                    let doubleValues = arr as! [Double]
                    print("\n\nDOUBLE: \(doubleValues)")
                    graphData.append(doubleValues)
                }
            }
        }
        return graphData
    }
}

extension GraphView: ScrollableGraphViewDataSource {
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        switch plot.identifier {
            case "plot1":
                return graphData[1][pointIndex]
            case "plot2":
                return graphData[2][pointIndex]
            case "plot3":
                return graphData[3][pointIndex]
            case "plot4":
                return graphData[4][pointIndex]
            case "plot5":
                return graphData[5][pointIndex]
            case "plot6":
                return graphData[6][pointIndex]
            case "plot7":
                return graphData[7][pointIndex]
            
            default:
                return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        if (pointIndex%25 == 0) {
            return String(graphData[0][pointIndex])
        }
        return ""
    }
    
    func numberOfPoints() -> Int {
        return pointsNumber
    }
}
