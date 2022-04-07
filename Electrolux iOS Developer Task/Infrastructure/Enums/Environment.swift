//
//  Environment.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

public enum Environment {
    case dev
    case prod
    
    var baseURL: String {
        switch self {
        case .dev:
            return "www.flickr.com"
        case .prod:
            return "www.flickr.com"
       
        }
    }
    
}
