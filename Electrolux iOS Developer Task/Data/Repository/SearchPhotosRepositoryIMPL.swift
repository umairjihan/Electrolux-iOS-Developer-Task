//
//  SearchPhotosRepositoryIMPL.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

final class SearchPhotosRepositoryIMPL {

    private let remoteDateSource: SearchPhotosDataSource
    
    init(remote: SearchPhotosDataSource) {
        self.remoteDateSource = remote
    }
}

extension SearchPhotosRepositoryIMPL: SearchPhotosRepository{
    
    func searchPhotos(tag: String, page: Int, completion: @escaping (_ result: Response?, _ error: ErrorResponse?) -> Void) {
        let args = SearchPhotosArgs(api_key: Constants.apiKey, method: "flickr.photos.search", tags: tag, page: page, format: Constants.format, nojsoncallback: 1)
        self.remoteDateSource.searchPhotos(searchPhotosArgs: args, completion: completion)
    }
    
}
