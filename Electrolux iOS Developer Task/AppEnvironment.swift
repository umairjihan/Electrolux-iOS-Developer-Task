//
//  AppEnvironment.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

public class AppEnvironment {
    
    public static var current: Environment {
  
        let appSchema = Bundle.main.infoDictionary?["App Environment"] as? String
        switch appSchema {
        case ".dev":
            return .dev
        default:// Release
            return .prod
        }
    }
        
    public static var isLive: Bool {
        
        AppEnvironment.current == Environment.prod
    }
    
    public static var isTest: Bool {
        
        AppEnvironment.current == Environment.dev
    }
    
}
