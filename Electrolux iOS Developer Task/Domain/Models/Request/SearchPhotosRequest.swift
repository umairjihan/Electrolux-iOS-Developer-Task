//
//  SearchPhotosRequest.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

struct SearchPhotosArgs: Codable {
    var api_key: String
    var method: String
    var tags: String
    var page: Int
    var format: String
    var nojsoncallback: Int
}
