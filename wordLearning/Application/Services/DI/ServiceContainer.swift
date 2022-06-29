//
//  ServiceContainer.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation

final class ServiceContainer {
    private var serviceDependencies = [String: AnyObject]()
    private static var shared = ServiceContainer()

    static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }

    static func resolve<T>() -> T {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let serviceKey = String(describing: T.self)
        serviceDependencies[serviceKey] = dependency as AnyObject
    }

    private func resolve<T>() -> T {
        let serviceKey = String(describing: T.self)
        guard let dependency = serviceDependencies[serviceKey] as? T else {
            fatalError("No dependency found for \(serviceKey)! must register a dependency before resolve.")
        }

        return dependency
    }
}
