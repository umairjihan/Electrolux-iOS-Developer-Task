//
//  SearchPhotosUseCaseTests.swift
//  Electrolux iOS Developer TaskTests
//
//  Created by Abu Umair Jihan on 2022-04-05.
//

import XCTest
import Combine
@testable import Electrolux_iOS_Developer_Task

class SearchPhotosUseCaseTests: XCTestCase {

    private var observers: [AnyCancellable] = []
    
    let photos: FlickrPhotos = {
        let photo = [Photo(id: "id1", owner: "owner1", secret: "secret1", server: "server1", farm: 1, title: "title1", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id2", owner: "owner2", secret: "secret2", server: "server2", farm: 1, title: "title2", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id3", owner: "owner3", secret: "secret3", server: "server3", farm: 1, title: "title3", ispublic: 1, isfriend: 0, isfamily: 0)]
        let photos = Photos(page: 1, pages: 1, perpage: 3, total: 3, photo: photo)
        return FlickrPhotos(photos: photos, stat: "ok")
    }()
    
    struct SearchPhotosRepositoryMock: SearchPhotosRepository {
        var response: (result: Response?, error: ErrorResponse?)
        func searchPhotos(tag: String, page: Int, completion: @escaping (_ result: Response?, _ error: ErrorResponse?) -> Void) {
            completion(response.result, response.error)
        }
    }
    
    func testSearchPhotosUseCase_RetrievePhotos(){
        
        let expectation = self.expectation(description: "Fetch photos")
        expectation.expectedFulfillmentCount = 2
        let searchPhotosRepository = SearchPhotosRepositoryMock(response: (result: self.photos, error: nil))
        let useCase = SearchPhotosUseCase(repository: searchPhotosRepository, page: 1)
        var photoList: FlickrPhotos? = nil
        var errorResponse: ErrorResponse? = nil
        
        useCase.start().sink ( receiveCompletion:{  completion in
            switch completion {
            case .finished:
                print("Finished calling")
            case .failure(let error):
                print("Error calling \(error)")
                errorResponse = error
            }
            expectation.fulfill()
        }, receiveValue: { response in
            photoList = response as? FlickrPhotos
            expectation.fulfill()
        }).store(in: &observers)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(photoList != nil)
        XCTAssertTrue(photoList?.photos.page == self.photos.photos.page)
        XCTAssertEqual(photoList?.photos.photo.map { $0.id }, self.photos.photos.photo.map { $0.id })
        XCTAssertTrue(errorResponse == nil)
        
    }
    
    func testSearchPhotosUseCase_ReturnsError(){
        
        let expectation = self.expectation(description: "Fetch photos")
        
        let searchPhotosRepository = SearchPhotosRepositoryMock(response: (result: nil, error: ErrorResponse(message: "Server error")))
        let useCase = SearchPhotosUseCase(repository: searchPhotosRepository, page: 1)
        var photoList: FlickrPhotos? = nil
        var errorResponse: ErrorResponse? = nil
        
        useCase.start().sink ( receiveCompletion:{  completion in
            switch completion {
            case .finished:
                print("Finished calling")
            case .failure(let error):
                print("Error calling \(error)")
                errorResponse = error
            }
            expectation.fulfill()
        }, receiveValue: { response in
            photoList = response as? FlickrPhotos
            expectation.fulfill()
        }).store(in: &observers)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        
        XCTAssertTrue(photoList == nil)
        XCTAssertTrue(errorResponse != nil)
        
        
    }
    

}
