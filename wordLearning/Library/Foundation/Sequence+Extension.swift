//
//  Sequence+Extension.swift
//  wordLearning
//
//  Created by Andrey Luferau on 5/9/22.
//

import Foundation

extension Sequence where Element: Equatable {
    func duplicateRemoved() -> [Element] {
        reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
    }
}
