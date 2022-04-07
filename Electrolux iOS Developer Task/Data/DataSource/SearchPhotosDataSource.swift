//
//  SearchPhotosDataSource.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation


protocol SearchPhotosDataSource {
 
    func searchPhotos( searchPhotosArgs: SearchPhotosArgs, completion: @escaping (_ result: FlickrPhotos?, _ error: ErrorResponse?) -> Void)
    
}
