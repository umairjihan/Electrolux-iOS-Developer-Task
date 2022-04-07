//
//  SearchPhotosRepository.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

protocol SearchPhotosRepository {
    
    func searchPhotos(tag: String, page: Int, completion: @escaping (_ result: Response?, _ error: ErrorResponse?) -> Void)
    
}
