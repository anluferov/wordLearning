//
//  WordTaskViewModel.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/19/22.
//

import Foundation
import Combine

protocol WordTaskViewModel {
    // used to determine when current task is finished
    var isActiveTaskFinishedPublisher: AnyPublisher<Bool, Never> { get }
    
    // used to determine state of checing current word
    // - true: user remember, enter word correctly and other
    // - false: user forgot, enter word with mistake and other
    // - nil: user in process of checking word
    var isWordCheckSuccessedPublisher: AnyPublisher<Bool?, Never> { get }
    
    // call this method to start task flow
    func startTaskAction()
    
    // call this method to finish task flow
    func finishTaskAction()
}
