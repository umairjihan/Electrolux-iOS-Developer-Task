//
//  UseCase.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation
import Combine

protocol UseCase{
    func start() -> Future<Response?,ErrorResponse>
}
