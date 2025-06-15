// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum JSON: Codable, Sendable {
    case string(String)
    case double(Double)
    case integer(Int)
    case boolean(Bool)
    case array([JSON])
    case object([String: JSON])
    
    public enum JSONDecodingError: Error {
        case invalid
    }
    
    // MARK: Utility
    
    public init (_ object: Any) throws {
        
        func parse(_ object: Any) throws -> JSON {
            
            // NOTE: The check for integer MUST come before the check for double
            // Otherwise Ints may get evaluated as Doubles
            
            if let value = object as? String {
                return .string(value)
            } else if let value = object as? Int {
                return .integer(value)
            } else if let value = object as? Double {
                return .double(value)
            } else if let value = object as? Bool {
                return .boolean(value)
            } else if let value = object as? Array<Any> {
                return .array(try value.map({ try parse($0) }))
            } else if let value = object as? Dictionary<String, Any> {
                var temp: [String: JSON] = [:]
                for (key, x) in value {
                    temp[key] = try parse(x)
                }
                return .object(temp)
            } else {
                throw JSONDecodingError.invalid
            }
        }
        self = try parse(object)
    }
    
    var literalValue: Any {
        
        func parse(_ value: JSON) -> Any {
            switch value {
            case .string(let x): return x
            case .double(let x): return x
            case .integer(let x): return x
            case .boolean(let x): return x
            case .array(let x): return x.map(parse)
            case .object(let x): return x.mapValues(parse)
            }
        }
        return parse(self)
    }
    
    // MARK: Codable
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        // NOTE: The check for integer MUST come before the check for double
        // Otherwise Ints may get evaluated as Doubles
        
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .integer(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode([JSON].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: JSON].self) {
            self = .object(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .string(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .integer(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        }
    }
}
