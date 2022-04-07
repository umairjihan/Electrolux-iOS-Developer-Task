//
//  Electrolux_iOS_Developer_TaskApp.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import SwiftUI

@main
struct Electrolux_iOS_Developer_TaskApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = SearchPhotosRepositoryIMPL(remote: SearchPhotosRemoteService())
            let useCase = SearchPhotosUseCase(repository: repository)
            let viewModel = SearchPhotosViewModel(usecase: useCase)
            SearchPhotosView(viewModel: viewModel)
        }
    }
}
