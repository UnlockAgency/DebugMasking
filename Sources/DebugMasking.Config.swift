//
//  File.swift
//  
//
//  Created by Bas van Kuijck on 15/02/2023.
//

import Foundation

extension DebugMasking {
    public struct Config {
        public let shortenedDistance: Int
        public let maskString: String
        public let specifiyArrayKey: Bool
        
        public init(shortenedDistance: Int = 128, maskString: String = "***", specifiyArrayKey: Bool = true) {
            self.shortenedDistance = shortenedDistance
            self.maskString = maskString
            self.specifiyArrayKey = specifiyArrayKey
        }
    }
}
