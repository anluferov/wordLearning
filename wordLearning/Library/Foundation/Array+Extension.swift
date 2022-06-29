//
//  Array+Extension.swift
//  wordLearning
//
//  Created by Andrey Luferau on 6/12/22.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
    
    func inBounds(index: Int) -> Bool {
        return index >= 0 && index < count
    }
}
