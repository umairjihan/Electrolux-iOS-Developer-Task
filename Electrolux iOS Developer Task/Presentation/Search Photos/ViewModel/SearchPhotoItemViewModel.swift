//
//  SearchPhotoItemViewModel.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

protocol SearchPhotoItemViewModelOutput : ObservableObject {
    
    var id: String { get }
    var farm: Int { get }
    var server: String { get }
    var secret: String { get }
    var imageUrl: URL { get }
    var isSelected : Bool {get set}
}

class SearchPhotoItemViewModel: SearchPhotoItemViewModelOutput {
    
    let uniqueID = UUID()
    let id: String
    let farm: Int
    let server: String
    let secret: String
    let imageUrl: URL
    @Published var isSelected: Bool = false
    
    init( id: String, farm: Int, server: String, secret: String){
        self.id = id
        self.farm = farm
        self.server = server
        self.secret = secret
        
        self.imageUrl = URL(string: "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg")!
    }
}
