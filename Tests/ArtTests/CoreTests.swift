import Testing
@testable import Art

@Suite("Point2D")
struct Point2DTests {
    @Test("Initialization")
    func initialization() {
        let point = Point2D(x: 3.0, y: 4.0)
        #expect(point.x == 3.0)
        #expect(point.y == 4.0)
    }

    @Test("Zero point")
    func zeroPoint() {
        let zero = Point2D.zero
        #expect(zero.x == 0.0)
        #expect(zero.y == 0.0)
    }

    @Test("Euclidean distance")
    func euclideanDistance() {
        let p1 = Point2D(x: 0, y: 0)
        let p2 = Point2D(x: 3, y: 4)
        #expect(abs(p1.distance(to: p2) - 5.0) < 0.0001)
    }

    @Test("Manhattan distance")
    func manhattanDistance() {
        let p1 = Point2D(x: 0, y: 0)
        let p2 = Point2D(x: 3, y: 4)
        #expect(p1.manhattanDistance(to: p2) == 7.0)
    }

    @Test("Magnitude")
    func magnitude() {
        let point = Point2D(x: 3, y: 4)
        #expect(abs(point.magnitude - 5.0) < 0.0001)
    }

    @Test("Normalization")
    func normalization() {
        let point = Point2D(x: 3, y: 4)
        let normalized = point.normalized()
        #expect(abs(normalized.magnitude - 1.0) < 0.0001)
        #expect(abs(normalized.x - 0.6) < 0.0001)
        #expect(abs(normalized.y - 0.8) < 0.0001)
    }

    @Test("Normalization of zero point")
    func normalizationOfZeroPoint() {
        let zero = Point2D.zero
        let normalized = zero.normalized()
        #expect(normalized == Point2D.zero)
    }

    @Test("Linear interpolation")
    func linearInterpolation() {
        let p1 = Point2D(x: 0, y: 0)
        let p2 = Point2D(x: 10, y: 10)

        let midpoint = p1.lerp(to: p2, t: 0.5)
        #expect(midpoint.x == 5.0)
        #expect(midpoint.y == 5.0)

        let start = p1.lerp(to: p2, t: 0.0)
        #expect(start == p1)

        let end = p1.lerp(to: p2, t: 1.0)
        #expect(end == p2)
    }

    @Test("Addition")
    func addition() {
        let p1 = Point2D(x: 1, y: 2)
        let p2 = Point2D(x: 3, y: 4)
        let result = p1 + p2
        #expect(result.x == 4.0)
        #expect(result.y == 6.0)
    }

    @Test("Subtraction")
    func subtraction() {
        let p1 = Point2D(x: 5, y: 7)
        let p2 = Point2D(x: 2, y: 3)
        let result = p1 - p2
        #expect(result.x == 3.0)
        #expect(result.y == 4.0)
    }

    @Test("Scalar multiplication")
    func scalarMultiplication() {
        let point = Point2D(x: 2, y: 3)
        let scaled = point * 2.5
        #expect(scaled.x == 5.0)
        #expect(scaled.y == 7.5)

        let scaledReverse = 2.5 * point
        #expect(scaledReverse == scaled)
    }

    @Test("Division")
    func division() {
        let point = Point2D(x: 10, y: 20)
        let divided = point / 2.0
        #expect(divided.x == 5.0)
        #expect(divided.y == 10.0)
    }
}

@Suite("Point3D")
struct Point3DTests {
    @Test("Initialization")
    func initialization() {
        let point = Point3D(x: 1, y: 2, z: 3)
        #expect(point.x == 1.0)
        #expect(point.y == 2.0)
        #expect(point.z == 3.0)
    }

    @Test("Zero point")
    func zeroPoint() {
        let zero = Point3D.zero
        #expect(zero.x == 0.0)
        #expect(zero.y == 0.0)
        #expect(zero.z == 0.0)
    }

    @Test("Distance")
    func distance() {
        let p1 = Point3D(x: 0, y: 0, z: 0)
        let p2 = Point3D(x: 2, y: 3, z: 6)
        #expect(abs(p1.distance(to: p2) - 7.0) < 0.0001)
    }

    @Test("Manhattan distance")
    func manhattanDistance() {
        let p1 = Point3D(x: 0, y: 0, z: 0)
        let p2 = Point3D(x: 2, y: 3, z: 6)
        #expect(p1.manhattanDistance(to: p2) == 11.0)
    }

    @Test("Magnitude")
    func magnitude() {
        let point = Point3D(x: 2, y: 3, z: 6)
        #expect(abs(point.magnitude - 7.0) < 0.0001)
    }

    @Test("Normalization")
    func normalization() {
        let point = Point3D(x: 2, y: 3, z: 6)
        let normalized = point.normalized()
        #expect(abs(normalized.magnitude - 1.0) < 0.0001)
    }

    @Test("Dot product")
    func dotProduct() {
        let p1 = Point3D(x: 1, y: 2, z: 3)
        let p2 = Point3D(x: 4, y: 5, z: 6)
        #expect(p1.dot(p2) == 32.0)
    }

    @Test("Cross product")
    func crossProduct() {
        let p1 = Point3D(x: 1, y: 0, z: 0)
        let p2 = Point3D(x: 0, y: 1, z: 0)
        let cross = p1.cross(p2)
        #expect(cross.x == 0.0)
        #expect(cross.y == 0.0)
        #expect(cross.z == 1.0)
    }

    @Test("Operations")
    func operations() {
        let p1 = Point3D(x: 1, y: 2, z: 3)
        let p2 = Point3D(x: 4, y: 5, z: 6)

        let sum = p1 + p2
        #expect(sum.x == 5.0)
        #expect(sum.y == 7.0)
        #expect(sum.z == 9.0)

        let diff = p2 - p1
        #expect(diff.x == 3.0)
        #expect(diff.y == 3.0)
        #expect(diff.z == 3.0)
    }
}

@Suite("RandomSource")
struct RandomSourceTests {
    @Test("Deterministic output")
    func deterministicOutput() {
        var rng1 = RandomSource(seed: 12345)
        var rng2 = RandomSource(seed: 12345)

        for _ in 0..<100 {
            #expect(rng1.nextUInt64() == rng2.nextUInt64())
        }
    }

    @Test("Different seeds")
    func differentSeeds() {
        var rng1 = RandomSource(seed: 12345)
        var rng2 = RandomSource(seed: 54321)

        let value1 = rng1.nextUInt64()
        let value2 = rng2.nextUInt64()
        #expect(value1 != value2)
    }

    @Test("Double range")
    func doubleRange() {
        var rng = RandomSource(seed: 42)

        for _ in 0..<1000 {
            let value = rng.nextDouble()
            #expect(value >= 0.0)
            #expect(value < 1.0)
        }
    }

    @Test("Double in range")
    func doubleInRange() {
        var rng = RandomSource(seed: 42)
        let range = 10.0...20.0

        for _ in 0..<1000 {
            let value = rng.nextDouble(in: range)
            #expect(value >= 10.0)
            #expect(value <= 20.0)
        }
    }

    @Test("Int range")
    func intRange() {
        var rng = RandomSource(seed: 42)

        for _ in 0..<1000 {
            let value = rng.nextInt(upperBound: 10)
            #expect(value >= 0)
            #expect(value < 10)
        }
    }

    @Test("Int in range")
    func intInRange() {
        var rng = RandomSource(seed: 42)
        let range = 5...15

        for _ in 0..<1000 {
            let value = rng.nextInt(in: range)
            #expect(value >= 5)
            #expect(value <= 15)
        }
    }

    @Test("Bool probability")
    func boolProbability() {
        var rng = RandomSource(seed: 42)
        var trueCount = 0
        let iterations = 10000

        for _ in 0..<iterations {
            if rng.nextBool(probability: 0.3) {
                trueCount += 1
            }
        }

        let ratio = Double(trueCount) / Double(iterations)
        #expect(abs(ratio - 0.3) < 0.05)
    }

    @Test("Next element")
    func nextElement() {
        var rng = RandomSource(seed: 42)
        let array = [1, 2, 3, 4, 5]

        for _ in 0..<100 {
            let element = rng.nextElement(from: array)
            #expect(element != nil)
            #expect(array.contains(element!))
        }

        let emptyElement = rng.nextElement(from: [Int]())
        #expect(emptyElement == nil)
    }

    @Test("Shuffle")
    func shuffle() {
        var rng = RandomSource(seed: 42)
        var array = [1, 2, 3, 4, 5]
        let original = array

        rng.shuffle(&array)

        #expect(array.sorted() == original.sorted())
        #expect(array != original)
    }

    @Test("Shuffle deterministic")
    func shuffleDeterministic() {
        var rng1 = RandomSource(seed: 12345)
        var rng2 = RandomSource(seed: 12345)

        var array1 = [1, 2, 3, 4, 5]
        var array2 = [1, 2, 3, 4, 5]

        rng1.shuffle(&array1)
        rng2.shuffle(&array2)

        #expect(array1 == array2)
    }

    @Test("Next Point2D")
    func nextPoint2D() {
        var rng = RandomSource(seed: 42)
        let point = rng.nextPoint2D(xRange: 0...100, yRange: 0...100)

        #expect(point.x >= 0)
        #expect(point.x <= 100)
        #expect(point.y >= 0)
        #expect(point.y <= 100)
    }

    @Test("Next Point3D")
    func nextPoint3D() {
        var rng = RandomSource(seed: 42)
        let point = rng.nextPoint3D(xRange: 0...10, yRange: 0...10, zRange: 0...10)

        #expect(point.x >= 0)
        #expect(point.x <= 10)
        #expect(point.y >= 0)
        #expect(point.y <= 10)
        #expect(point.z >= 0)
        #expect(point.z <= 10)
    }

    @Test("Next angle")
    func nextAngle() {
        var rng = RandomSource(seed: 42)

        for _ in 0..<1000 {
            let angle = rng.nextAngle()
            #expect(angle >= 0)
            #expect(angle < 2 * .pi)
        }
    }
}

@Suite("RGBColor")
struct RGBColorTests {
    @Test("Initialization")
    func initialization() {
        let color = RGBColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 0.8)
        #expect(color.red == 0.5)
        #expect(color.green == 0.6)
        #expect(color.blue == 0.7)
        #expect(color.alpha == 0.8)
    }

    @Test("Clamping")
    func clamping() {
        let color = RGBColor(red: 1.5, green: -0.5, blue: 0.5)
        #expect(color.red == 1.0)
        #expect(color.green == 0.0)
        #expect(color.blue == 0.5)
    }

    @Test("Init 255")
    func init255() {
        let color = RGBColor(red255: 255, green255: 128, blue255: 64)
        #expect(abs(color.red - 1.0) < 0.01)
        #expect(abs(color.green - 128.0 / 255.0) < 0.01)
        #expect(abs(color.blue - 64.0 / 255.0) < 0.01)
    }

    @Test("Hex conversion")
    func hexConversion() {
        let color = RGBColor(hex: "#FF8040")
        #expect(color != nil)

        if let color = color {
            #expect(abs(color.red - 1.0) < 0.01)
            #expect(abs(color.green - 0.5019) < 0.01)
            #expect(abs(color.blue - 0.2509) < 0.01)
        }

        let withoutHash = RGBColor(hex: "FF8040")
        #expect(color == withoutHash)

        let invalid = RGBColor(hex: "GGGGGG")
        #expect(invalid == nil)
    }

    @Test("Hex string")
    func hexString() {
        let color = RGBColor(red: 1.0, green: 0.5, blue: 0.25)
        #expect(color.hexString == "#FF8040")
    }

    @Test("RGB to HSL")
    func rgbToHSL() {
        let red = RGBColor.red
        let hsl = red.toHSL()
        #expect(abs(hsl.hue - 0.0) < 0.1)
        #expect(abs(hsl.saturation - 1.0) < 0.1)
        #expect(abs(hsl.lightness - 0.5) < 0.1)
    }

    @Test("HSL to RGB")
    func hslToRGB() {
        let hsl = HSLColor(hue: 0, saturation: 1.0, lightness: 0.5)
        let rgb = hsl.toRGB()
        #expect(abs(rgb.red - 1.0) < 0.01)
        #expect(abs(rgb.green - 0.0) < 0.01)
        #expect(abs(rgb.blue - 0.0) < 0.01)
    }

    @Test("Color lerp")
    func colorLerp() {
        let black = RGBColor.black
        let white = RGBColor.white

        let gray = black.lerp(to: white, t: 0.5)
        #expect(gray.red == 0.5)
        #expect(gray.green == 0.5)
        #expect(gray.blue == 0.5)
    }

    @Test("Common colors")
    func commonColors() {
        #expect(RGBColor.black.red == 0.0)
        #expect(RGBColor.white.red == 1.0)
        #expect(RGBColor.red.red == 1.0)
        #expect(RGBColor.green.green == 1.0)
        #expect(RGBColor.blue.blue == 1.0)
    }
}

@Suite("ArtError")
struct ArtErrorTests {
    @Test("Error descriptions")
    func errorDescriptions() {
        let errors: [ArtError] = [
            .invalidInput("test"),
            .invalidRange("test"),
            .invalidColor("test"),
            .invalidConfiguration("test"),
            .computationFailed("test"),
            .notImplemented("test")
        ]

        for error in errors {
            #expect(!error.description.isEmpty)
            #expect(error.description.contains("test"))
        }
    }
}
