//
//  SearchPhotosView.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import SwiftUI

struct SearchPhotosView<VM: SearchPhotosViewModelInput & SearchPhotosViewModelOutput>: View {
    
    @StateObject var viewModel: VM
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var showingAlert = false
    
    private var columns: [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: 3)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    ForEach(viewModel.items, id: \.uniqueID) { item in
                        if viewModel.shouldFetchNextPage(item: item) {
                            PhotosGridView(viewModel: item, didSelect : {  image in
                                self.didSelectImage(image: image)
                            })
                            .task {
                                self.viewModel.didLoadNextPage()
                            }
                        }else{
                            PhotosGridView(viewModel: item, didSelect : {  image in
                                self.didSelectImage(image: image)
                            })
                        }
                    }
                }
                .searchable(text: $viewModel.searchTag,  placement: .navigationBarDrawer(displayMode: .always))
                .navigationBarTitle("Flickr Phoos", displayMode: .inline)
                .toolbar {
                    Button("Save") {
                        self.saveCompleted()
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
    
    
    private func didSelectImage( image : UIImage){
        if let  containIndex = selectedImages.firstIndex(of: image) {
            self.selectedImages.remove(at: containIndex)
        }else {
            self.selectedImages.append(image)
        }
    }
    
    private func saveImageToGallery(){
        if !self.selectedImages.isEmpty {
            let imageSaver = ImageSaver()
            imageSaver.delegate = self
            imageSaver.writeToPhotoAlbum(images: self.selectedImages)
        }
    }
}


extension SearchPhotosView: ImageSaverDelegate {
    
    func saveCompleted() {
        self.viewModel.items.forEach { item in
            item.isSelected = false
        }
        self.showingAlert = true
    }
}


 
