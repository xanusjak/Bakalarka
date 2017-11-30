//
//  MatlabService.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 04/10/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import Foundation

class MatlabService {
 
    static let sharedClient = MatlabService()
    
    func callService(urlString: String) -> String {
        
        let url = URL(string: urlString)!
        do {
            let content = try String(contentsOf: url)
            return content
        } catch {
            return ""
        }
    }
    
    // Check IP
    func checkIpPing() -> Bool {
        
        if (callService(urlString: Path.ip + Path.ping) == "pong") {
            print("checkIpPing: TRUE")
            return true
        }
        else {
            print("checkIpPing: FALSE")
            return false
        }
    }
    
    // Check is Matlab running
    func isMatlabRuning() -> Bool {
        
        if (callService(urlString: Path.ip + Path.isMatlabRunning) == "true") {
            print("isMatlabRuning: TRUE")
            return true
        }
        else {
            print("isMatlabRuning: FALSE")
            return false
        }
    }
    
    // Check is Model opened
    func isModelOpened(modelName: String) -> Bool {
        
        if (callService(urlString: Path.ip + Path.isModelOpened + modelName) == "true") {
            print("isModelOpened: TRUE")
            return true
        }
        else {
            print("isModelOpened: FALSE")
            return false
        }
    }
    
    // Start Matlab
    func startMatlab() {
        print("startMatlab")
        _ = callService(urlString: Path.ip + Path.startMatlab)
    }
    
    // Stop Matlab
    func stopMatlab() {
        print("stopMatlab")
        _ = callService(urlString: Path.ip + Path.stopMatlab)
    }
    
    // Get all models
    func getModels() -> Array<String>{
        
        let string = callService(urlString: Path.ip + Path.getModels)
        var models = matches(for: "[a-zA-Z0-9_.-]*.mdl\\s", in: string)
        
        
        for i in 0..<models.count {
            models[i] = (models[i] as NSString).trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ".mdl", with: "")
        }
        
        return models
    }
    
    // Open Model
    func openModel(_ modelName: String) {
        print("openModel: " + Path.ip + Path.openModel + modelName)
        _ = callService(urlString: Path.ip + Path.openModel + modelName)
    }
    
    // Close Model
    func closeModel(_ modelName: String) {
        print("closeModel: " + Path.ip + Path.openModel + modelName)
        _ = callService(urlString: Path.ip + Path.closeModel + modelName)
    }
    
    // Get Model information
    func getModelInfo(_ modelName: String) -> [String:Any] {
        let JSONString = callService(urlString: Path.ip + Path.getModelInfo + modelName)
        
        if let dictionary = convertJSONToDictionary(text: JSONString) {
            print("getModelInfo: TRUE")
            return dictionary
        }
        else {
            print("getModelInfo: FALSE")
            return [:]
        }
    }
    
    // Start Simulation
    func startSimulation(_ modelName: String) {
        print("startSimulation")
        _ = callService(urlString: Path.ip + Path.startSimulation + modelName)
    }
    
    // Stop Simulation
    func stopSimulation(_ modelName: String) {
        print("stopSimulation")
        _ = callService(urlString: Path.ip + Path.stopSimulation + modelName)
    }
    
    func getScopeData(_ modelName: String) -> [String:Any] {
        print("getScopeData: ")
        let JSONString = callService(urlString: Path.ip + Path.getScopeData + modelName)
 
        if let dictionary = convertJSONToDictionary(text: JSONString) {
            print(dictionary)
            return dictionary
        }
        else {
            return [:]
        }
    }
    
    func getGraphData(_ modelName: String) -> [[Double]]{
        let data = getScopeData(modelName)
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

extension MatlabService {
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
