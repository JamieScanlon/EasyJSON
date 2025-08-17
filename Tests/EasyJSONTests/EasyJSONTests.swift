import Testing
import Foundation
@testable import EasyJSON

enum EasyJSONTestsError: Error {
    case missingValue
}

@Suite("EasyJSONTests")
struct EasyJSONTests {
    
    @Test("Test encoding")
    func dictInterop() throws {
        
        let encoder = JSONEncoder()
        
        let json = JSON.object([
            "a": .string("Hello WOrld"),
            "b": .double(123.456),
            "c": .integer(7),
            "d": .boolean(true),
            "e": .array([
                .integer(1),
                .integer(2),
                .integer(3),
                ]),
            "f": .object([
                "x": .integer(1),
                "y": .string("2"),
                ])
        ])
        
        // When
        
        let data = try encoder.encode(json)
        let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        // Then
        try #require(jsonDict != nil)
        #expect(jsonDict?["a"] as? String == "Hello WOrld")
        #expect(jsonDict?["b"] as? Double == 123.456)
        #expect(jsonDict?["c"] as? Int == 7)
        #expect(jsonDict?["d"] as? Bool == true)
        #expect((jsonDict?["e"] as? Array)?[0] == 1)
        #expect((jsonDict?["e"] as? Array)?[1] == 2)
        #expect((jsonDict?["e"] as? Array)?[2] == 3)
        #expect((jsonDict?["f"] as? [String: Any])?["x"] as? Int == 1)
        #expect((jsonDict?["f"] as? [String: Any])?["y"] as? String == "2")
    }
    
    @Test("Test decoding")
    func decoding() throws {
        
        let jsonDictionary: [String: Any] = [
            "string": "This is a string",
            "double": 123.456,
            "integer": 4,
            "boolean": true,
            "array": [
                1,
                2.3,
                true,
                "four",
                [1, 2, 3],
                ["a": 1],
                ["b": 2, "c": "three"],
                ["d": false],
                ["e": 4.5678],
                ["f": [1, 2, 3]],
                ["g": ["h": "i"]],
            ],
            "object": [
                "a": 1,
                "b": 2.3,
                "c": true,
                "d": [1, 2, 3],
                "e": ["f": "g"],
                "h": "i",
            ]
                
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary , options: [])
        
        let decoder = JSONDecoder()
        
        let easyJson: JSON = try decoder.decode(JSON.self, from: jsonData)
        
        let isObject: Bool = {
            if case .object(_) = easyJson {
                return true
            } else {
                return false
            }
        }()
        
        #expect(isObject)
        
        if case .object( let a ) = easyJson {
            let string = a["string"]
            let double = a["double"]
            let integer = a["integer"]
            let boolean = a["boolean"]
            let array = a["array"]
            let object = a["object"]
            
            try #require(string != nil)
            try #require(double != nil)
            try #require(integer != nil)
            try #require(boolean != nil)
            try #require(array != nil)
            try #require(object != nil)
            
            if case .string(let value) = string! {
                #expect(value == "This is a string")
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .double(let value) = double! {
                #expect(value == 123.456)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .integer(let value) = integer! {
                #expect(value == 4)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .boolean(let value) = boolean! {
                #expect(value)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .array(let value) = array! {
                #expect(value.count == 11)
                if case .integer(let firstValue) = value[0] {
                    #expect(firstValue == 1)
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .double(let secondValue) = value[1] {
                    #expect(secondValue == 2.3)
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .boolean(let thirdValue) = value[2] {
                    #expect(thirdValue)
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .string(let fourthValue) = value[3] {
                    #expect(fourthValue == "four")
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .array(let fifthValue) = value[4] {
                    try #require(fifthValue.count == 3)
                    if case .integer(let x) = fifthValue[1] {
                        #expect(x == 2)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let sixthValue) = value[5] {
                    try #require(sixthValue["a"] != nil)
                    if case .integer(let x) = sixthValue["a"]! {
                        #expect(x == 1)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let seventhValue) = value[6] {
                    try #require(seventhValue["b"] != nil)
                    try #require(seventhValue["c"] != nil)
                    if case .integer(let x) = seventhValue["b"]! {
                        #expect(x == 2)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .string(let x) = seventhValue["c"]! {
                        #expect(x == "three")
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let eighthValue) = value[7] {
                    try #require(eighthValue["d"] != nil)
                    if case .boolean(let x) = eighthValue["d"]! {
                        #expect(!x)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let ninthValue) = value[8] {
                    try #require(ninthValue["e"] != nil)
                    if case .double(let x) = ninthValue["e"]! {
                        #expect(x == 4.5678)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let tenthValue) = value[9] {
                    try #require(tenthValue["f"] != nil)
                    if case .array(let x) = tenthValue["f"]! {
                        if case .integer(let y1) = x[0] {
                            #expect(y1 == 1)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                        if case .integer(let y2) = x[1] {
                            #expect(y2 == 2)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                        if case .integer(let y3) = x[2] {
                            #expect(y3 == 3)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let eleventhValue) = value[10] {
                    try #require(eleventhValue["g"] != nil)
                    if case .object(let x) = eleventhValue["g"]! {
                        try #require(x["h"] != nil)
                        if case .string(let y) = x["h"] {
                            #expect(y == "i")
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
                if case .object(let value) = object {
                    #expect(value.count == 6)
                    try #require(value["a"] != nil)
                    try #require(value["b"] != nil)
                    try #require(value["c"] != nil)
                    try #require(value["d"] != nil)
                    try #require(value["e"] != nil)
                    try #require(value["h"] != nil)
                    if case .integer(let x) = value["a"]! {
                        #expect(x == 1)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .double(let x) = value["b"]! {
                        #expect(x == 2.3)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .boolean(let x) = value["c"]! {
                        #expect(x)
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .array(let x) = value["d"]! {
                        if case .integer(let y1) = x[0] {
                            #expect(y1 == 1)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                        if case .integer(let y2) = x[1] {
                            #expect(y2 == 2)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                        if case .integer(let y3) = x[2] {
                            #expect(y3 == 3)
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .object(let x) = value["e"]! {
                        if case .string(let y) = x["f"] {
                            #expect(y == "g")
                        } else {
                            throw EasyJSONTestsError.missingValue
                        }
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                    if case .string(let x) = value["h"]! {
                        #expect(x == "i")
                    } else {
                        throw EasyJSONTestsError.missingValue
                    }
                } else {
                    throw EasyJSONTestsError.missingValue
                }
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .object(let value) = object! {
                #expect(value.count == 6)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            
        }
        
    }
    
    @Test("Test init with Any")
    func testInitWithAny() throws {
        // Test string
        let stringJSON = try JSON("Hello World")
        if case .string(let value) = stringJSON {
            #expect(value == "Hello World")
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test integer
        let intJSON = try JSON(42)
        if case .integer(let value) = intJSON {
            #expect(value == 42)
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test double
        let doubleJSON = try JSON(3.14)
        if case .double(let value) = doubleJSON {
            #expect(value == 3.14)
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test boolean
        let boolJSON = try JSON(true)
        if case .boolean(let value) = boolJSON {
            #expect(value == true)
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test array
        let arrayJSON = try JSON([1, "two", 3.0, true])
        if case .array(let value) = arrayJSON {
            #expect(value.count == 4)
            if case .integer(let first) = value[0] {
                #expect(first == 1)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .string(let second) = value[1] {
                #expect(second == "two")
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .double(let third) = value[2] {
                #expect(third == 3.0)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .boolean(let fourth) = value[3] {
                #expect(fourth == true)
            } else {
                throw EasyJSONTestsError.missingValue
            }
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test dictionary
        let dictJSON = try JSON([
            "string": "value",
            "number": 42,
            "bool": true,
            "array": [1, 2, 3],
            "nested": ["key": "value"]
        ])
        if case .object(let value) = dictJSON {
            #expect(value.count == 5)
            if case .string(let strValue) = value["string"]! {
                #expect(strValue == "value")
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .integer(let numValue) = value["number"]! {
                #expect(numValue == 42)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .boolean(let boolValue) = value["bool"]! {
                #expect(boolValue == true)
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .array(let arrValue) = value["array"]! {
                #expect(arrValue.count == 3)
                if case .integer(let first) = arrValue[0] {
                    #expect(first == 1)
                } else {
                    throw EasyJSONTestsError.missingValue
                }
            } else {
                throw EasyJSONTestsError.missingValue
            }
            if case .object(let nestedValue) = value["nested"]! {
                if case .string(let nestedStr) = nestedValue["key"]! {
                    #expect(nestedStr == "value")
                } else {
                    throw EasyJSONTestsError.missingValue
                }
            } else {
                throw EasyJSONTestsError.missingValue
            }
        } else {
            throw EasyJSONTestsError.missingValue
        }
        
        // Test invalid value
        struct InvalidType {}
        do {
            _ = try JSON(InvalidType())
            throw EasyJSONTestsError.missingValue // Should not reach here
        } catch JSON.JSONDecodingError.invalid {
            // Expected error
        } catch {
            throw error
        }
    }
    
    @Test("Test literalValue")
    func testLiteralValue() throws {
        // Test string
        let stringJSON = JSON.string("Hello World")
        let stringValue = stringJSON.literalValue as? String
        try #require(stringValue != nil)
        #expect(stringValue == "Hello World")
        
        // Test integer
        let intJSON = JSON.integer(42)
        let intValue = intJSON.literalValue as? Int
        try #require(intValue != nil)
        #expect(intValue == 42)
        
        // Test double
        let doubleJSON = JSON.double(3.14)
        let doubleValue = doubleJSON.literalValue as? Double
        try #require(doubleValue != nil)
        #expect(doubleValue == 3.14)
        
        // Test boolean
        let boolJSON = JSON.boolean(true)
        let boolValue = boolJSON.literalValue as? Bool
        try #require(boolValue != nil)
        #expect(boolValue == true)
        
        // Test array
        let arrayJSON = JSON.array([
            .integer(1),
            .string("two"),
            .double(3.0),
            .boolean(true)
        ])
        var arrayValue = arrayJSON.literalValue as? [Any]
        try #require(arrayValue != nil)
        #expect(arrayValue?.count == 4)
        #expect(arrayValue?[0] as? Int == 1)
        #expect(arrayValue?[1] as? String == "two")
        #expect(arrayValue?[2] as? Double == 3.0)
        #expect(arrayValue?[3] as? Bool == true)
        
        // Test nested array
        let nestedArrayJSON = JSON.array([
            .array([.integer(1), .integer(2)]),
            .array([.string("a"), .string("b")])
        ])
        let nestedArrayValue = nestedArrayJSON.literalValue as? [Any]
        try #require(nestedArrayValue != nil)
        #expect(nestedArrayValue?.count == 2)
        let firstNested = nestedArrayValue?[0] as? [Any]
        let secondNested = nestedArrayValue?[1] as? [Any]
        try #require(firstNested != nil)
        try #require(secondNested != nil)
        #expect(firstNested?[0] as? Int == 1)
        #expect(firstNested?[1] as? Int == 2)
        #expect(secondNested?[0] as? String == "a")
        #expect(secondNested?[1] as? String == "b")
        
        // Test dictionary
        let dictJSON = JSON.object([
            "string": .string("value"),
            "number": .integer(42),
            "bool": .boolean(true),
            "array": .array([.integer(1), .integer(2), .integer(3)]),
            "nested": .object(["key": .string("value")])
        ])
        let dictValue = dictJSON.literalValue as? [String: Any]
        try #require(dictValue != nil)
        #expect(dictValue?.count == 5)
        #expect(dictValue?["string"] as? String == "value")
        #expect(dictValue?["number"] as? Int == 42)
        #expect(dictValue?["bool"] as? Bool == true)
        
        arrayValue = dictValue?["array"] as? [Any]
        try #require(arrayValue != nil)
        #expect(arrayValue?.count == 3)
        #expect(arrayValue?[0] as? Int == 1)
        #expect(arrayValue?[1] as? Int == 2)
        #expect(arrayValue?[2] as? Int == 3)
        
        let nestedDict = dictValue?["nested"] as? [String: Any]
        try #require(nestedDict != nil)
        #expect(nestedDict?["key"] as? String == "value")
        
        // Test complex nested structure
        let complexJSON = JSON.object([
            "array": .array([
                .object([
                    "name": .string("item1"),
                    "values": .array([.integer(1), .integer(2)])
                ]),
                .object([
                    "name": .string("item2"),
                    "values": .array([.integer(3), .integer(4)])
                ])
            ])
        ])
        let complexValue = complexJSON.literalValue as? [String: Any]
        try #require(complexValue != nil)
        
        let complexArray = complexValue?["array"] as? [Any]
        try #require(complexArray != nil)
        #expect(complexArray?.count == 2)
        
        let firstItem = complexArray?[0] as? [String: Any]
        let secondItem = complexArray?[1] as? [String: Any]
        try #require(firstItem != nil)
        try #require(secondItem != nil)
        
        #expect(firstItem?["name"] as? String == "item1")
        #expect(secondItem?["name"] as? String == "item2")
        
        let firstValues = firstItem?["values"] as? [Any]
        let secondValues = secondItem?["values"] as? [Any]
        try #require(firstValues != nil)
        try #require(secondValues != nil)
        
        #expect(firstValues?[0] as? Int == 1)
        #expect(firstValues?[1] as? Int == 2)
        #expect(secondValues?[0] as? Int == 3)
        #expect(secondValues?[1] as? Int == 4)
    }

    @Test("literalValue preserves numeric types")
    func testLiteralValuePreservesNumericTypes() throws {
        let json = JSON.object([
            "i": .integer(1),
            "d": .double(1.0),
            "mix": .array([.integer(2), .double(2.5), .integer(3)])
        ])

        let dict = json.literalValue as? [String: Any]
        try #require(dict != nil)

        #expect((dict?["i"]) is Int)
        #expect((dict?["d"]) is Double)
        #expect(dict?["i"] as? Int == 1)
        #expect(dict?["d"] as? Double == 1.0)

        let mix = dict?["mix"] as? [Any]
        try #require(mix != nil)
        #expect((mix?[0]) is Int)
        #expect((mix?[1]) is Double)
        #expect((mix?[2]) is Int)
        #expect(mix?[0] as? Int == 2)
        #expect(mix?[1] as? Double == 2.5)
        #expect(mix?[2] as? Int == 3)
    }

    @Test("literalValue round-trips from Any")
    func testLiteralValueRoundTripFromAny() throws {
        let original: [String: Any] = [
            "string": "hello",
            "int": 7,
            "double": 7.5,
            "bool": false,
            "array": [1, 2.0, true, "x"] as [Any],
            "object": [
                "a": 1,
                "b": 2.0,
                "c": ["nested": "y"]
            ] as [String: Any]
        ]

        let json = try JSON(original)
        let roundTripped = json.literalValue as? [String: Any]
        try #require(roundTripped != nil)

        #expect(roundTripped?["string"] as? String == "hello")
        #expect(roundTripped?["int"] as? Int == 7)
        #expect(roundTripped?["double"] as? Double == 7.5)
        #expect(roundTripped?["bool"] as? Bool == false)

        let array = roundTripped?["array"] as? [Any]
        try #require(array != nil)
        #expect(array?.count == 4)
        #expect(array?[0] as? Int == 1)
        #expect(array?[1] as? Double == 2.0)
        #expect(array?[2] as? Bool == true)
        #expect(array?[3] as? String == "x")

        let object = roundTripped?["object"] as? [String: Any]
        try #require(object != nil)
        #expect(object?["a"] as? Int == 1)
        #expect(object?["b"] as? Double == 2.0)

        let nested = object?["c"] as? [String: Any]
        try #require(nested != nil)
        #expect(nested?["nested"] as? String == "y")
    }

    @Test("literalValue handles empty structures")
    func testLiteralValueEmptyStructures() throws {
        let emptyArrayJSON = JSON.array([])
        let emptyObjectJSON = JSON.object([:])

        let arr = emptyArrayJSON.literalValue as? [Any]
        let obj = emptyObjectJSON.literalValue as? [String: Any]

        try #require(arr != nil)
        try #require(obj != nil)
        #expect(arr?.isEmpty == true)
        #expect(obj?.isEmpty == true)
    }
}
