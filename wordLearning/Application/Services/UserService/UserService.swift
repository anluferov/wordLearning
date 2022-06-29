//
//  UserService.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import Foundation
import Combine

//TODO: Debug implementation of service. Need to rewrite updating in settings
class UserService: UserServiceProtocol {
    var currentToLearnLanguage: AnyPublisher<String, Never> { _currentToLearnLanguage.eraseToAnyPublisher() }
    private let _currentToLearnLanguage = CurrentValueSubject<String, Never>("en")
    
    var currentNativeLanguage: AnyPublisher<String, Never> { _currentNativeLanguage.eraseToAnyPublisher() }
    private let _currentNativeLanguage = CurrentValueSubject<String, Never>("rus")
    
    var currentTaskMode: AnyPublisher<WordCardTaskMode, Never> { _currentTaskMode.eraseToAnyPublisher() }
    private let _currentTaskMode = CurrentValueSubject<WordCardTaskMode, Never>(.rememberForgot)
}
