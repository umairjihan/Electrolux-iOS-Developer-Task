//
//  BaseNetworking.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation
import Alamofire
import Combine

// MARK: - Generic base networking class that will send request to the server and parse the response
class BaseNetworking {
    
    // MARK: Shared Instance
    public static let shared: BaseNetworking = BaseNetworking()
    
    
    ///To handle API calls and return the response
    func request<T: Codable>(_ t: T.Type,endPoint: API, completion: @escaping (_ result: T?, _ error: ErrorResponse?) -> Void)  {
        
        guard let url = buildRequestURL(endPoint: endPoint) else {
            completion(nil, ErrorResponse(message: "invalid_url"))
            return
        }
        
        AF.request(url, method: endPoint.method, parameters: endPoint.bodyParamaters, encoding: endPoint.bodyEncoding, headers: endPoint.headerParamaters )
            .validate().responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(_):
                    guard let responseObj = response.value else
                    {
                        completion(nil, ErrorResponse(message: "parsing_error"))
                        return
                    }
                    print(responseObj)
                    completion(responseObj, nil)
                    
                case .failure(_):
                    completion(nil, ErrorResponse(message: "server_error"))
                }
            }
        
    }
    
    
    /// in order to handle the get request with any query parameters
    private func buildRequestURL(endPoint: API) -> URL? {
        
        let queryDictionary = endPoint.queryParameters
        
        let env = AppEnvironment.current
        
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = env.baseURL
        components.path = endPoint.path
        
        components.queryItems = queryDictionary.map {
            URLQueryItem(name: $0, value: "\($1)")
        }
        
        return components.url
    }
    
}
