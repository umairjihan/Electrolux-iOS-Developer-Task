//
//  SearchPhotosUseCase.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation
import Combine

class SearchPhotosUseCase: UseCase {
    
    private let repository: SearchPhotosRepository
    var page: Int
    var tag: String = ""
    
    init(repository: SearchPhotosRepository, page: Int = 1) {
        self.repository = repository
        self.page = page
    }
    
    
    func start() -> Future<Response?,ErrorResponse> {
        Future { [weak self] promise in
            self?.repository.searchPhotos(tag: self?.tag ?? "", page: self?.page ?? 0, completion: { result, error in
                if result != nil {
                    if let data = result as? FlickrPhotos {
                        promise(Result.success(data))
                    }
                }else {
                    promise(Result.failure(error!))
                }
            })
        }
    }
    
}
