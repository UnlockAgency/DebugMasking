//
//  DebugMasking.swift
//
//  Created by Bas van Kuijck on 15/02/2023.
//  Copyright © 2023 Unlock Agency. All rights reserved.

import Foundation

public class DebugMasking {
    public let config: Config
    
    public init(config: Config = .init()) {
        self.config = config
    }
    
    public func mask(dictionary: [String: Any], options: [String: MaskOption]) -> [String: Any] {
        return mask(at: "", dictionary: dictionary, options: options)
    }
    
    private func mask(
        at path: String,
        dictionary: [String: Any],
        options: [String: MaskOption]
    ) -> [String: Any] {
        
        var logDictionary: [String: Any] = [:]
        for (key, value) in dictionary {
            let pathKey = "\(path)\(key)"
            let option = options[pathKey] ?? .default
            
            if let aDictionary = value as? [String: Any], case MaskOption.default = option {
                logDictionary[key] = mask(at: "\(pathKey).", dictionary: aDictionary, options: options)
                
            } else if let array = value as? [[String: Any]], case MaskOption.default = option {
                let arraySyntax = config.specifiyArrayKey ? "[]" : ""
                logDictionary[key] = array.map { mask(at: "\(pathKey)\(arraySyntax).", dictionary: $0, options: options) }
                
            } else if let string = mask(value, type: option) {
                logDictionary[key] = string
            }
        }
        return logDictionary
    }
    
    public func mask(_ value: Any?, type: MaskOption) -> Any? {
        guard let value else {
            return nil
        }
        switch type {
        case .halfMasked:
            let stringValue = "\(value)"
            
            // Email masking
            if stringValue.components(separatedBy: "@").count == 2, stringValue.contains(".") {
                let sep = stringValue.components(separatedBy: "@")
                let lastComp = "." + (stringValue.components(separatedBy: ".").last ?? "")
                let secondSep = sep[1].replacingOccurrences(of: ".\(lastComp)", with: "")
                return halfMasked(string: sep[0]) + "@" + halfMasked(string: secondSep) + lastComp
            }
            
            return halfMasked(string: stringValue)

        case .ignore:
            return nil

        case .replaced(let string):
            return string

        case .masked:
            return config.maskString

        case .shortened:
            let stringValue: String
            if let tmpValue = value as? String {
                stringValue = tmpValue
                
            } else {
                stringValue = String(describing: value)
            }
            if stringValue.count > config.shortenedDistance {
                let startIndex = stringValue.startIndex
                let endIndex = stringValue.index(startIndex, offsetBy: config.shortenedDistance)
                return String(describing: stringValue[startIndex..<endIndex]) + "..."
            } else {
                return stringValue
            }
        case .default:
            return value
        }
    }
    
    private func halfMasked(string: String) -> String {
        if string.isEmpty {
            return config.maskString
        }
        let length = Int(floor(Double(string.count) / 2.0))
        let startIndex = string.startIndex
        let midIndex = string.index(startIndex, offsetBy: length)
        return String(describing: string[startIndex..<midIndex]) + config.maskString
    }
}
