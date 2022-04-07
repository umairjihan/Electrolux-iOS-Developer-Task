//
//  API.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation
import Alamofire


// MARK: - API class will help to define the APIs in the remote networking when calling from the server
public class API{
    
    public let path: String
    public let method: HTTPMethod
    public let headerParamaters: HTTPHeaders
    public let queryParameters: [String: Any]
    public let bodyParamaters: [String: Any]
    public let bodyEncoding: ParameterEncoding
   
    init(path: String,
         method: HTTPMethod,
         headerParamaters: [String: String] = [:],
         queryParameters: [String: Any] = [:],
         bodyParamatersEncodable: Encodable? = nil,
         bodyParamaters: [String: Any] = [:],
         bodyEncoding: ParameterEncoding = URLEncoding.default) {
        self.path = path
        self.method = method
        let headers = headerParamaters.map({ header in
            HTTPHeader(name: header.key, value: header.value)
        })
        self.headerParamaters = HTTPHeaders(headers)
        self.queryParameters = queryParameters
        self.bodyParamaters = bodyParamaters
        self.bodyEncoding = bodyEncoding
   
    }
}
