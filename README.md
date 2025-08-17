# EasyJSON

A Swift library that makes working with JSON easier by providing type-safe JSON handling with Codable and Sendable conformance, and seamless interoperability with `[String: Any]` dictionaries.

## Features

- Type-safe JSON handling with enum-based representation
- Full `Codable` conformance for easy encoding/decoding
- `Sendable` conformance for safe concurrent usage
- Easy conversion between JSON and `[String: Any]` dictionaries
- Support for all JSON types: strings, numbers, booleans, arrays, and objects
- Simple and intuitive API
- Cross-platform support (iOS, macOS, tvOS, watchOS, visionOS, Linux, Windows)

## Requirements

- Swift 6.0+ (required for visionOS support and latest Swift features)
- Xcode 15.0+
- Platform minimum versions:
  - iOS 13.0+
  - macOS 10.15+
  - tvOS 13.0+
  - watchOS 6.0+
  - visionOS 1.0+

## Installation

### Swift Package Manager

Add EasyJSON to your project using Swift Package Manager:

1. In Xcode, select File > Add Packages...
2. Enter the repository URL: `https://github.com/jamiescanlon/EasyJSON.git`
3. Select the version you want to use
4. Click Add Package

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/jamiescanlon/EasyJSON.git", from: "1.0.0")
]
```

## Motivation

If you've ever tried to work with arbitrary `[String: Any]` objects where you don't always know the precise schema you will often run into problems. 
For example let's say you are recieving JSON from a web service that looks like:
``` javascript
{
    "name": "Some Name",
    "id": 1,
    metadata: {
        // ... an object with arbitrary keys/values
    }
}
```

In swift you would normally try to leverage a `Codable` type to parse the object:
``` swift
struct MyObject: Codable {
    var name: String
    var id: Int
    var metadata: [String: Any]
}
```

This will give you errors because `[String: Any]` does not conform to `Codable`. It's equally painful if you also want `MyObject` to conform to `Sendable` because `[String: Any]` cannot conform to `Sendable`

**EasyJson** is intended to fix this issue by providing an object that is both `Codable` and `Sendable` 
In order for it to be more ergonomic it provides easy ways to convert to and from `[String: Any]`. Although you can create and manipulate the type directly, it is mostly intended to intermediate type.

## Usage

### Basic Usage

```swift
import EasyJSON

// Convert to [String: Any]
let dictionary = json.literalValue as? [String: Any]

// Create from [String: Any]
let jsonFromDict = try JSON([
    "name": "John Doe",
    "age": 30,
    "isActive": true,
    "scores": [85, 92, 88],
    "address": [
        "street": "123 Main St",
        "city": "New York"
    ]
])

// Create a JSON object from scratch
let json = JSON.object([
    "name": .string("John Doe"),
    "age": .integer(30),
    "isActive": .boolean(true),
    "scores": .array([.integer(85), .integer(92), .integer(88)]),
    "address": .object([
        "street": .string("123 Main St"),
        "city": .string("New York")
    ])
])
```

### Using `literalValue`

`literalValue` returns the native Swift representation of a `JSON` value, recursively converting nested arrays and objects so you can interoperate with existing APIs that expect `[String: Any]` or `[Any]`.

- Mapping:
  - `JSON.string` → `String`
  - `JSON.integer` → `Int`
  - `JSON.double` → `Double`
  - `JSON.boolean` → `Bool`
  - `JSON.array` → `[Any]` (elements converted recursively)
  - `JSON.object` → `[String: Any]` (values converted recursively)

Notes:
- **Numeric types are preserved**: `Int` remains `Int`, and `Double` remains `Double` (no implicit coercion).
- Empty arrays/objects become empty `[Any]`/`[String: Any]`.

Examples:

```swift
// Convert a JSON object to [String: Any]
let dict = json.literalValue as? [String: Any]

// Round-trip from [String: Any]
let original: [String: Any] = [
    "name": "Jane",
    "age": 30,          // Int
    "score": 99.5,      // Double
    "flags": [true, 1, 2.0, "x"] as [Any],
    "meta": ["k": "v"]
]
let easy = try JSON(original)
let back = easy.literalValue as? [String: Any]

// Mixed arrays preserve element types
if let flags = back?["flags"] as? [Any] {
    // flags[0] is Bool, flags[1] is Int, flags[2] is Double, flags[3] is String
}
```

### Encoding and Decoding

```swift
// Encode to Data
let encoder = JSONEncoder()
let data = try encoder.encode(json)

// Decode from Data
let decoder = JSONDecoder()
let decodedJSON = try decoder.decode(JSON.self, from: data)
```

### Working with JSON Values

```swift
// Access values
if case .object(let dict) = json {
    if case .string(let name) = dict["name"] {
        print(name) // "John Doe"
    }
    
    if case .array(let scores) = dict["scores"] {
        for score in scores {
            if case .integer(let value) = score {
                print(value)
            }
        }
    }
}
```

## Platform Support

EasyJSON is designed to work across all major Swift platforms:

- **Apple Platforms**
  - iOS 13.0+
  - macOS 10.15+
  - tvOS 13.0+
  - watchOS 6.0+
  - visionOS 1.0+

- **Other Platforms**
  - Linux (with Swift Foundation)
  - Windows (with Swift Foundation)

## Why Swift 6.0?

EasyJSON requires Swift 6.0 or later for several reasons:
1. Full visionOS support
2. Latest Swift features and improvements
3. Better type safety and concurrency support
4. Future compatibility
5. Modern Swift best practices

## License

EasyJSON is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
