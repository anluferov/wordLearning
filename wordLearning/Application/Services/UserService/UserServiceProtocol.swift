//
//  UserServiceProtocol.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    var currentNativeLanguage: AnyPublisher<String, Never> { get }
    var currentToLearnLanguage: AnyPublisher<String, Never> { get }
    var currentTaskMode: AnyPublisher<WordCardTaskMode, Never> { get }
}
