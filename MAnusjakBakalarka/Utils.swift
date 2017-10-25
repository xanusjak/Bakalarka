//
//  Utils.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 21/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import Foundation

//JSON String to Dictionary
func convertJSONToDictionary(text: String) -> [String:Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

//Dictionary to JSON string
func convertDictionaryToJSON(dictionary: [String:Any]) -> String? {
    if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []){
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    }
    
    return nil
}

//Save to UserDefaults
func saveDictionary(dict: [String:Any],forKey key: String) {
    let data = NSKeyedArchiver.archivedData(withRootObject: dict)
    UserDefaults.standard.set(data, forKey: key)
}

//Get from UserDefaults
func getDictionary(forKey key: String) -> [String:Any]? {
    
    if let data = UserDefaults.standard.object(forKey: key) as? NSData {
        if let dict = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String:Any]
        {
            return dict;
        }
    }
    return nil
}
