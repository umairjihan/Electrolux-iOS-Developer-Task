//
//  ImageSaver.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-05.
//

import Foundation
import SwiftUI

protocol ImageSaverDelegate {
    func saveCompleted()
}

class ImageSaver: NSObject {
    
    var delegate: ImageSaverDelegate? = nil
    
    private var images: [UIImage] = []
    
    func writeToPhotoAlbum(images: [UIImage]) {
        self.images = images
        if let image = self.images.first {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        }
        self.images.removeFirst()
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if self.images.isEmpty {
            self.delegate?.saveCompleted()
        }
        
        if let imagee = self.images.first {
            UIImageWriteToSavedPhotosAlbum(imagee, self, #selector(saveCompleted), nil)
            self.images.removeFirst()
        }
        
    }
}


