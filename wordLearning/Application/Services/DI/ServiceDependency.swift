//
//  ServiceDependency.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation

@propertyWrapper
struct ServiceDependency<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = ServiceContainer.resolve()
    }
}
