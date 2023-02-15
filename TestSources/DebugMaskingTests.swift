//
//  DebugMaskingTests.swift
//  
//
//  Created by Bas van Kuijck on 15/02/2023.
//

import Foundation
import XCTest
@testable import DebugMasking

class DebugMaskingTests: XCTestCase {
    func testSimpleDictionary() {
        let debugMasking = DebugMasking()
        
        let dictionary: [String: Any] = [
            "some": "simple",
            "integer": 123,
            "null": "null",
            "replaced": "hello",
            "dictionary": [
                "password": "abc123",
                "email": "bvkuijck@unlockagency.nl"
            ]
        ]
        
        let maskDictionary = debugMasking.mask(
            dictionary: dictionary,
            options: [
                "null": .ignore,
                "dictionary.password": .masked,
                "dictionary.email": .halfMasked,
                "replaced": .replaced("---")
            ]
        )
        
        XCTAssertEqual(maskDictionary["some"] as? String, "simple")
        XCTAssertEqual(maskDictionary["integer"] as? String, "123")
        XCTAssertEqual(maskDictionary["replaced"] as? String, "---")
        XCTAssertNil(maskDictionary["null"])
        XCTAssertEqual((maskDictionary["dictionary"] as? [String: String])?["email"], "bvku***@unlocka***.nl")
        XCTAssertEqual((maskDictionary["dictionary"] as? [String: String])?["password"], "***")
    }
    
    func testLong() {
        let debugMasking = DebugMasking()
        
        let dictionary: [String: Any] = [
            "foo": "Aliquam tincidunt quis mi in blandit. Sed augue eros, consectetur sed facilisis eget, ultricies in ex. Suspendisse sagittis, velit a rutrum rhoncus, nulla dui pulvinar lectus, nec placerat ipsum lorem nec enim. Fusce vel neque quis risus lobortis efficitur. Nullam tempus diam vel nunc lacinia, bibendum tincidunt turpis laoreet. Nunc accumsan, dolor ut mollis blandit, magna sem vulputate lectus, eget vulputate elit ligula eget lorem. Ut a urna vulputate, mattis sapien at, ultrices quam. Cras in arcu orci. Proin at sagittis ex. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed gravida quam ut metus aliquet, ut aliquet tellus tempor. Donec fermentum ante mattis odio interdum, venenatis lacinia risus suscipit. Vestibulum in pellentesque leo.Donec sit amet consectetur risus, a fringilla magna. Fusce ac tellus tristique erat placerat tempor a a urna. Ut diam sapien, feugiat ac efficitur ut, volutpat ac sapien. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Mauris vehicula fermentum ipsum, vel finibus dui pellentesque ac. In at turpis quis lacus commodo cursus. Pellentesque sed sagittis mauris, eu malesuada nibh. Pellentesque eu interdum justo. Proin finibus, ligula in ultrices gravida, quam nibh imperdiet justo, non interdum quam orci vitae nulla. Sed hendrerit venenatis aliquet. Ut pharetra vitae risus id dictum. Suspendisse id lectus quis ante scelerisque posuere. Nulla vitae enim diam. Nunc venenatis sed arcu quis tincidunt.",
            "entire": [
                "dictionary": [
                    "is": "masked"
                ]
            ]
        ]
        
        let maskDictionary = debugMasking.mask(
            dictionary: dictionary,
            options: [
                "foo": .shortened,
                "entire": .replaced("-redacted-")
            ]
        )
        
        XCTAssertEqual(maskDictionary["entire"] as? String, "-redacted-")
        XCTAssertEqual(maskDictionary["foo"] as? String, "Aliquam tincidunt quis mi in blandit. Sed augue eros, consectetur sed facilisis eget, ultricies in ex. Suspendisse sagittis, vel...")
    }
    
    func testArray() {
        let debugMasking = DebugMasking()
        
        let dictionary: [String: Any] = [
            "array": [
                [
                    "secret": "abc",
                    "foo": "bar"
                ],
                [
                    "secret": "def",
                    "foo": "bar"
                ],
                [
                    "secret": "ghi",
                    "foo": "bar"
                ]
            ]
        ]
        
        let maskDictionary = debugMasking.mask(
            dictionary: dictionary,
            options: [
                "array[].secret": .masked
            ]
        )
        
        for dic in (maskDictionary["array"] as? [[String: String]] ?? []) {
            XCTAssertEqual(dic["secret"], "***")
            XCTAssertEqual(dic["foo"], "bar")
        }
    }
    
    func testString() {
        let password = "abc123"
        
        let masking = DebugMasking(config: .init(maskString: "###"))
        XCTAssertEqual(masking.mask(password, type: .masked), "###")
    }
}
