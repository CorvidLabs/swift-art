import Foundation

/// Classic Perlin noise implementation.
public struct PerlinNoise: NoiseGenerator, Sendable {
    private let permutation: [Int]

    /// Creates a Perlin noise generator with an optional seed.
    public init(seed: UInt64? = nil) {
        if let seed = seed {
            var rng = RandomSource(seed: seed)
            var p = Array(0..<256)
            rng.shuffle(&p)
            self.permutation = p + p
        } else {
            self.permutation = Self.defaultPermutation + Self.defaultPermutation
        }
    }

    public func sample(x: Double, y: Double) -> Double {
        let xi = Int(floor(x)) & 255
        let yi = Int(floor(y)) & 255

        let xf = x - floor(x)
        let yf = y - floor(y)

        let u = fade(xf)
        let v = fade(yf)

        let a = permutation[xi] + yi
        let b = permutation[xi + 1] + yi

        let aa = permutation[a]
        let ab = permutation[a + 1]
        let ba = permutation[b]
        let bb = permutation[b + 1]

        let x1 = lerp(
            grad2(permutation[aa], xf, yf),
            grad2(permutation[ba], xf - 1, yf),
            u
        )
        let x2 = lerp(
            grad2(permutation[ab], xf, yf - 1),
            grad2(permutation[bb], xf - 1, yf - 1),
            u
        )

        return lerp(x1, x2, v)
    }

    public func sample(x: Double, y: Double, z: Double) -> Double {
        let xi = Int(floor(x)) & 255
        let yi = Int(floor(y)) & 255
        let zi = Int(floor(z)) & 255

        let xf = x - floor(x)
        let yf = y - floor(y)
        let zf = z - floor(z)

        let u = fade(xf)
        let v = fade(yf)
        let w = fade(zf)

        let a = permutation[xi] + yi
        let aa = permutation[a] + zi
        let ab = permutation[a + 1] + zi
        let b = permutation[xi + 1] + yi
        let ba = permutation[b] + zi
        let bb = permutation[b + 1] + zi

        let x1 = lerp(
            grad3(permutation[aa], xf, yf, zf),
            grad3(permutation[ba], xf - 1, yf, zf),
            u
        )
        let x2 = lerp(
            grad3(permutation[ab], xf, yf - 1, zf),
            grad3(permutation[bb], xf - 1, yf - 1, zf),
            u
        )
        let y1 = lerp(x1, x2, v)

        let x3 = lerp(
            grad3(permutation[aa + 1], xf, yf, zf - 1),
            grad3(permutation[ba + 1], xf - 1, yf, zf - 1),
            u
        )
        let x4 = lerp(
            grad3(permutation[ab + 1], xf, yf - 1, zf - 1),
            grad3(permutation[bb + 1], xf - 1, yf - 1, zf - 1),
            u
        )
        let y2 = lerp(x3, x4, v)

        return lerp(y1, y2, w)
    }

    private func fade(_ t: Double) -> Double {
        t * t * t * (t * (t * 6 - 15) + 10)
    }

    private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + t * (b - a)
    }

    private func grad2(_ hash: Int, _ x: Double, _ y: Double) -> Double {
        let h = hash & 3
        let u = h < 2 ? x : y
        let v = h < 2 ? y : x
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }

    private func grad3(_ hash: Int, _ x: Double, _ y: Double, _ z: Double) -> Double {
        let h = hash & 15
        let u = h < 8 ? x : y
        let v = h < 4 ? y : (h == 12 || h == 14 ? x : z)
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }

    private static let defaultPermutation: [Int] = [
        151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
        140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
        247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
        57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
        74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
        60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
        65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
        200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
        52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
        207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
        119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
        129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
        218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
        81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
        184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
        222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
    ]
}
