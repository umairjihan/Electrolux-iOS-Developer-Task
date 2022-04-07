//
//  SearchPhotosView.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import SwiftUI

struct SearchPhotosView<VM: SearchPhotosViewModelInput & SearchPhotosViewModelOutput>: View {
    
    @StateObject var viewModel: VM
    
    @State private var selectedImage: UIImage?
    
    @State private var selectedItemIndex: Int? = nil
    
    @State private var showingAlert = false
    
    private var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: 3)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(viewModel.items.indices, id: \.self) { index in
                        if viewModel.shouldFetchNextPage(item: viewModel.items[index]) {
                            PhotosGridView(viewModel: viewModel.items[index], didSelect : {  image in
                                self.didSelectImage(index: index, image: image)
                            })
                            .task {
                                self.viewModel.didLoadNextPage()
                            }
                        }else{
                            PhotosGridView(viewModel: viewModel.items[index], didSelect : {  image in
                                self.didSelectImage(index: index, image: image)
                            })
                        }
                    }
                }
                .searchable(text: $viewModel.searchTag,  placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle("Flickr Phoos", displayMode: .inline)
                .toolbar {
                    Button("Save") {
                        self.saveImageToGallery()
                    }
                }
                .alert("Image is saved to gallery", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                }
                .padding(.horizontal)
            }
            .simultaneousGesture(
                DragGesture().onChanged({_ in
                       UIApplication.shared.dismissKeyboard()
                   }))
        }
        .navigationViewStyle(.stack)
    }
    
    
    private func didSelectImage(index: Int, image : UIImage){
        if let selectedItemIndex = self.selectedItemIndex {
            self.viewModel.items[selectedItemIndex].isSelected = false
        }
        if let selectedImage = self.selectedImage, selectedImage.isEqual(image) {
            self.selectedImage = nil
            self.selectedItemIndex = nil
        }else {
            self.selectedImage = image
            self.selectedItemIndex = index
        }
    }
    
    private func saveImageToGallery(){
        if let selectedImage = self.selectedImage {
            let imageSaver = ImageSaver()
            imageSaver.delegate = self
            imageSaver.writeToPhotoAlbum(image: selectedImage)
        }
    }
}


extension SearchPhotosView: ImageSaverDelegate {
    
    func saveCompleted() {
        selectedImage = nil
        if let selectedItemIndex = self.selectedItemIndex {
            self.viewModel.items[selectedItemIndex].isSelected = false
        }
        self.showingAlert = true
    }
}


 
