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
    
    func checkIpPing() -> Bool {
        
        if (callService(urlString: Path.ip + Path.ping) == "pong") {
            return true
        }
        else {
            return false
        }
    }
    
    func isMatlabRuning() -> Bool {
        
        if (callService(urlString: Path.ip + Path.isMatlabRunning) == "true") {
            return true
        }
        else {
            return false
        }
    }
    
    func startMatlab() {
        _ = callService(urlString: Path.ip + Path.startMatlab)
    }
    
    func stopMatlab() {
        _ = callService(urlString: Path.ip + Path.stopMatlab)
    }
    
    func getModels() -> Array<String>{
        
        let string = callService(urlString: Path.ip + Path.getModels)
        let models = matches(for: "[a-zA-Z0-9_.-]*.mdl", in: string)
        
        return models
    }
    
    func openModel(_ modelName: String) {
        _ = callService(urlString: Path.ip + Path.openModel + modelName)
    }
    
    func closeModel(_ modelName: String) {
        _ = callService(urlString: Path.ip + Path.closeModel + modelName)
    }
    
    func getModelInfo(_ modelName: String) -> [String:Any] {
        let JSONString = callService(urlString: Path.ip + Path.getModelInfo + modelName)
        
        if let dictionary = convertJSONToDictionary(text: JSONString) {
            print(dictionary)
            return dictionary
        }
        else {
            return [:]
        }
    }
    
    func getTestJSON() -> [String:Any] {
        let JSONString = callService(urlString: Path.testJSON)
 
        if let dictionary = convertJSONToDictionary(text: JSONString) {
            return dictionary
        }
        else {
            return [:]
        }
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
