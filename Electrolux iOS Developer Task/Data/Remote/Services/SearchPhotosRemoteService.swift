//
//  SearchPhotosRemoteService.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

struct SearchPhotosRemoteService: SearchPhotosDataSource {
    
    
    func searchPhotos(searchPhotosArgs: SearchPhotosArgs, completion: @escaping (FlickrPhotos?, ErrorResponse?) -> Void) {
        ///check the args if it's valid
        guard let params = searchPhotosArgs.asDictionary() else { completion(nil, ErrorResponse(message: "args_error"))
            return
        }
       
        /// here we create the event that represent the endpoint
        let event =  API(path: EndPoints.Search.photos ,
                         method: .get,
                         queryParameters: params
       )
       
       ///here we call the request with our type and completion handler
       BaseNetworking.shared.request(FlickrPhotos.self,
                                             endPoint:event,completion: completion);

    }
    
}
