//
//  PhotosGridView.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import SwiftUI
import Kingfisher

struct PhotosGridView <VM: SearchPhotoItemViewModelOutput> : View {
    
    @StateObject var viewModel: VM
    @State var image: UIImage? = nil
    @State var isImageDownloaded = false

    let didSelect: (UIImage) -> Void
    
//    @State var isSelected = false
    
    var body: some View {
        Button(action: {
            guard let image = self.image else { return }
            self.viewModel.isSelected = !self.viewModel.isSelected
            didSelect(image)
        }) {
            KFImage(viewModel.imageUrl)
                .resizable()
                .onSuccess({ imageResult in
                    self.isImageDownloaded = true
                    self.image = imageResult.image
                })
                .frame(height: (UIScreen.main.bounds.width - 80)/3, alignment: .center)
                .clipped()
                .overlay(ProgressView().isHidden(isImageDownloaded))
                .overlay(Color.blue.opacity(0.5).isHidden(!self.viewModel.isSelected))
        }
    }
    
}

//struct PhotosGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotosGridView()
//    }
//}

