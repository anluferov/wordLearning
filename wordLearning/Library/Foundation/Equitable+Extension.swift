//
//  Equitable+Extension.swift
//  wordLearning
//
//  Created by Andrey Luferau on 7/2/22.
//

import Foundation

extension Equatable {
  /// makes use of enumCase1.isAny(of: .enumCase1, .enumCase2) available
  func isAny(of candidates: Self...) -> Bool {
    return candidates.contains(self)
  }
}

extension Optional where Wrapped: Equatable {
  /// makes use of optionalEnumCase1.isAny(of: .enumCase1, .enumCase2) available
  func isAny(of candidates: Wrapped...) -> Bool {
    return map { candidates.contains($0) } ?? false
  }
}
