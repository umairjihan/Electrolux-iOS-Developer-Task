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
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        
        self.delegate?.saveCompleted()
    }
}


