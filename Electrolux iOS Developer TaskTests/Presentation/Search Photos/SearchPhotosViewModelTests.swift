//
//  SearchPhotosViewModelTests.swift
//  Electrolux iOS Developer TaskTests
//
//  Created by Abu Umair Jihan on 2022-04-07.
//

import XCTest
import Combine
@testable import Electrolux_iOS_Developer_Task

class SearchPhotosViewModelTests: XCTestCase {

    
    private var observers: [AnyCancellable] = []
    
    let photos: [FlickrPhotos] = {
        let photo1 = [Photo(id: "id1", owner: "owner1", secret: "secret1", server: "server1", farm: 1, title: "title1", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id2", owner: "owner2", secret: "secret2", server: "server2", farm: 1, title: "title2", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id3", owner: "owner3", secret: "secret3", server: "server3", farm: 1, title: "title3", ispublic: 1, isfriend: 0, isfamily: 0)]
        let photos1 = Photos(page: 1, pages: 2, perpage: 3, total: 3, photo: photo1)
        
        let photo2 = [Photo(id: "id4", owner: "owner4", secret: "secret4", server: "serve4", farm: 1, title: "title4", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id5", owner: "owner5", secret: "secret5", server: "server5", farm: 1, title: "title5", ispublic: 1, isfriend: 0, isfamily: 0),
                     Photo(id: "id6", owner: "owner6", secret: "secret6", server: "server6", farm: 1, title: "title6", ispublic: 1, isfriend: 0, isfamily: 0)]
        let photos2 = Photos(page: 2, pages: 2, perpage: 3, total: 6, photo: photo2)
        
        return [FlickrPhotos(photos: photos1, stat: "ok"), FlickrPhotos(photos: photos2, stat: "ok")]
    }()
    
    class SearchPhotosRepositoryMock: SearchPhotosRepository {
        var response: (result: Response?, error: ErrorResponse?)
        
        init( response: (result: Response?, error: ErrorResponse?) ){
            self.response = response
        }
        
        func searchPhotos(tag: String, page: Int, completion: @escaping (_ result: Response?, _ error: ErrorResponse?) -> Void) {
            completion(response.result, response.error)
        }
    }
    
    func testSearchPhotosUseCase_RetrievesFirstPage(){
        
        let expectation = self.expectation(description: "Only first page")
        
        let searchPhotosRepository = SearchPhotosRepositoryMock(response: (result: self.photos.first, error: nil))
        let useCase = SearchPhotosUseCase(repository: searchPhotosRepository, page: 1)
        let viewModel = SearchPhotosViewModel(usecase: useCase)
        
        viewModel.didSearch(tag: "tag")
        viewModel.$items.sink { _ in
            expectation.fulfill()
        }.store(in: &observers)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertEqual(viewModel.items.map { $0.id }, self.photos.first?.photos.photo.map { $0.id })
        XCTAssertTrue(viewModel.shouldFetchNextPage(item: viewModel.items.last!))
    }
    
    func testSearchPhotosUseCase_RetrievesFirstAndSecondPage(){

        var expectation = self.expectation(description: "First page loaded")
        let searchPhotosRepository = SearchPhotosRepositoryMock(response: (result: self.photos.first, error: nil))
        let useCase = SearchPhotosUseCase(repository: searchPhotosRepository, page: 1)
        let viewModel = SearchPhotosViewModel(usecase: useCase)

        viewModel.didSearch(tag: "tag")
        viewModel.$items.sink { _ in
            expectation.fulfill()
        }.store(in: &observers)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertEqual(viewModel.items.map { $0.id }, self.photos.first?.photos.photo.map { $0.id })
        XCTAssertTrue(viewModel.shouldFetchNextPage(item: viewModel.items.last!))

        expectation = self.expectation(description: "Second page loaded")

        searchPhotosRepository.response = (result: self.photos.last, error: nil)

        viewModel.didLoadNextPage()

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(viewModel.page, 2)
        XCTAssertEqual(viewModel.items.map { $0.id }, self.photos.flatMap { $0.photos.photo }.map { $0.id } )
        XCTAssertFalse(viewModel.shouldFetchNextPage(item: viewModel.items.last!))

    }
    
    func testSearchPhotosUseCase_ReturnsError(){

        let expectation = self.expectation(description: "errors")

        let searchPhotosRepository = SearchPhotosRepositoryMock(response: (result: nil, error: ErrorResponse(message: "Server error")))
        let useCase = SearchPhotosUseCase(repository: searchPhotosRepository, page: 1)
        let viewModel = SearchPhotosViewModel(usecase: useCase)

        viewModel.didSearch(tag: "tag")
        viewModel.$items.sink { _ in
            expectation.fulfill()
        }.store(in: &observers)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(viewModel.items.isEmpty)

    }


}
