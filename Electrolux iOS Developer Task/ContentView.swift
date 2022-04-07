//
//  ContentView.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import SwiftUI

struct ContentView<VM: SearchPhotosViewModelInput & SearchPhotosViewModelOutput>: View {
    @State private var searchText = ""
    
    @StateObject var viewModel: VM
    
    var body: some View {
        Text("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = SearchPhotosRepositoryIMPL(remote: SearchPhotosRemoteService())
        let useCase = SearchPhotosUseCase(repository: repository)
        let viewModel = SearchPhotosViewModel(usecase: useCase)
        
        ContentView(viewModel: viewModel)
    }
}
