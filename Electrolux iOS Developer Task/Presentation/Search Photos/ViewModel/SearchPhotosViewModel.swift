//
//  SearchPhotosViewModel.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation
import Combine

protocol SearchPhotosViewModelInput: ObservableObject {
    var searchTag: String { set get }
    func didLoadNextPage()
    func shouldFetchNextPage(item : SearchPhotoItemViewModel) -> Bool
}

protocol SearchPhotosViewModelOutput: ObservableObject {
    var items :[SearchPhotoItemViewModel] { get }
}

class SearchPhotosViewModel: SearchPhotosViewModelOutput, SearchPhotosViewModelInput {
    
    @Published var items : [SearchPhotoItemViewModel] = []
    
    var page: Int
    
    @Published var searchTag: String = String()

    private var isLoading: Bool = false
    private var totalPages: Int = 0
    private let usecase: SearchPhotosUseCase!
    private var observers: [AnyCancellable] = []
    
    
    
    init(usecase: SearchPhotosUseCase){
        self.usecase = usecase
        self.page = usecase.page
        
        $searchTag
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    return nil
                }
                return string
            })
            .compactMap{ $0 } 
            .sink { (_) in
                //
            } receiveValue: { [weak self] (searchTag) in
                self?.didSearch(tag: searchTag.trim())
            }.store(in: &observers)
    }
    
    
    func didSearch(tag: String) {
        self.usecase.tag = tag
        self.isLoading = true
        self.usecase.start().sink ( receiveCompletion:{ [weak self] completion in
            switch completion {
            case .finished:
                print("Finished calling")
            case .failure(let error):
                print("Error calling \(error)")
            }
            self?.isLoading = false
        }, receiveValue: { [weak self] response in
            guard let `self` = self, let flickrPhotos = response as? FlickrPhotos else { return }
            let items = flickrPhotos.photos.photo.map { photo in
                return SearchPhotoItemViewModel(id: photo.id, farm: photo.farm, server: photo.server, secret: photo.secret)
            }
            self.items = items
            self.page = flickrPhotos.photos.page
            self.totalPages = flickrPhotos.photos.pages
        }).store(in: &observers)
    }
    
    func didLoadNextPage() {
        self.usecase.page = self.page + 1
        self.isLoading = true
        self.usecase.start().sink ( receiveCompletion:{ [weak self] completion in
            switch completion {
            case .finished:
                print("Finished calling")
            case .failure(let error):
                print("Error calling \(error)")
            }
            self?.isLoading = false
        }, receiveValue: { [weak self] response in
            guard let `self` = self, let flickrPhotos = response as? FlickrPhotos else { return }
            let items = flickrPhotos.photos.photo.map { photo in
                return SearchPhotoItemViewModel(id: photo.id, farm: photo.farm, server: photo.server, secret: photo.secret)
            }
            self.items.append(contentsOf: items)
            self.page = flickrPhotos.photos.page
            self.totalPages = flickrPhotos.photos.pages
        }).store(in: &observers)
    }
    
    func shouldFetchNextPage(item : SearchPhotoItemViewModel) -> Bool {
        return !isLoading && page < totalPages && item.id == self.items.last?.id
    }
}
