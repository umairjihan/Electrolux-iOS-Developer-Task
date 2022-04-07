//
//  ViewExtension.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-05.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
