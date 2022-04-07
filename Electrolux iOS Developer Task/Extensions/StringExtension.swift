//
//  StringExtension.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-05.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
