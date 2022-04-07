//
//  ErrorResponse.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

struct ErrorResponse: Encodable, Error {

    let message: String
    
    init(message: String) {
        self.message = message
    }
    
}
