//
//  Path.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 21/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import Foundation

struct Path {
// School server IP
// 147.175.105.164:8080
// simulink/getScopeData?modelName=
    
    static var changeIp = "192.168.0.103"
//    static var ip = "http://" + Path.changeIp + ":8080/matlabadapter/api/matlab/"
    
    static let ping = "ping"
    static let isMatlabRunning = "isMatlabRunning"
    
    static let startMatlab = "startMatlab"
    static let stopMatlab = "stopMatlab"
    
    static let startSimulation = "simulink/startSimulation?modelName="
    static let stopSimulation = "simulink/stopSimulation?modelName="
    
    static let getModels = "executeCommand?command=ls%20models"
   
    static let openModel = "simulink/openModel?modelName="
    static let closeModel = "simulink/closeModel?modelName="
//    static let getModelInfo = "simulink/getModelInfo?modelName="
//    static let isModelOpened = "simulink/isModelOpened?modelName="
    
    static let setParamValue = "simulink/setParamValue"
    static let getParamValue = "simulink/getParamValue"

    // TEST
    static var ip = "file:///Users/manusjak/Downloads/BakalarkaTEST/"
    static let isModelOpened = "isModelOpened"
    static let getModelInfo = "getModelInfo"
    static let testScopeData = "file:///Users/manusjak/Downloads/BakalarkaTEST/getScopeData.html"
}
