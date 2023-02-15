//
//  File.swift
//  
//
//  Created by Bas van Kuijck on 15/02/2023.
//

import Foundation

extension DebugMasking {
    public enum MaskOption {
        case masked
        case halfMasked
        case ignore
        case replaced(String)
        case shortened
        case `default`
    }
}
