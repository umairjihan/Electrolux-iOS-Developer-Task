//
//  UIApplicationExtensions.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-05.
//

import Foundation
import SwiftUI

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
