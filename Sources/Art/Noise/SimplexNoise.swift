import Foundation

/// Simplex noise implementation - faster than Perlin noise.
public struct SimplexNoise: NoiseGenerator, Sendable {
    private let permutation: [Int]
    private let gradients3D: [Point3D]

    private static let f2 = 0.5 * (sqrt(3.0) - 1.0)
    private static let g2 = (3.0 - sqrt(3.0)) / 6.0

    public init(seed: UInt64? = nil) {
        if let seed = seed {
            var rng = RandomSource(seed: seed)
            var p = Array(0..<256)
            rng.shuffle(&p)
            self.permutation = p + p
        } else {
            self.permutation = PerlinNoise.defaultPermutation + PerlinNoise.defaultPermutation
        }

        self.gradients3D = [
            Point3D(x: 1, y: 1, z: 0), Point3D(x: -1, y: 1, z: 0), Point3D(x: 1, y: -1, z: 0), Point3D(x: -1, y: -1, z: 0),
            Point3D(x: 1, y: 0, z: 1), Point3D(x: -1, y: 0, z: 1), Point3D(x: 1, y: 0, z: -1), Point3D(x: -1, y: 0, z: -1),
            Point3D(x: 0, y: 1, z: 1), Point3D(x: 0, y: -1, z: 1), Point3D(x: 0, y: 1, z: -1), Point3D(x: 0, y: -1, z: -1)
        ]
    }

    public func sample(x: Double, y: Double) -> Double {
        let s = (x + y) * Self.f2
        let i = floor(x + s)
        let j = floor(y + s)

        let t = (i + j) * Self.g2
        let x0 = x - (i - t)
        let y0 = y - (j - t)

        let i1: Double
        let j1: Double
        if x0 > y0 {
            i1 = 1.0
            j1 = 0.0
        } else {
            i1 = 0.0
            j1 = 1.0
        }

        let x1 = x0 - i1 + Self.g2
        let y1 = y0 - j1 + Self.g2
        let x2 = x0 - 1.0 + 2.0 * Self.g2
        let y2 = y0 - 1.0 + 2.0 * Self.g2

        let ii = Int(i) & 255
        let jj = Int(j) & 255

        let gi0 = permutation[ii + permutation[jj]] % 12
        let gi1 = permutation[ii + Int(i1) + permutation[jj + Int(j1)]] % 12
        let gi2 = permutation[ii + 1 + permutation[jj + 1]] % 12

        let n0 = contribution(x: x0, y: y0, gradIndex: gi0)
        let n1 = contribution(x: x1, y: y1, gradIndex: gi1)
        let n2 = contribution(x: x2, y: y2, gradIndex: gi2)

        return 70.0 * (n0 + n1 + n2)
    }

    public func sample(x: Double, y: Double, z: Double) -> Double {
        let f3 = 1.0 / 3.0
        let g3 = 1.0 / 6.0

        let s = (x + y + z) * f3
        let i = floor(x + s)
        let j = floor(y + s)
        let k = floor(z + s)

        let t = (i + j + k) * g3
        let x0 = x - (i - t)
        let y0 = y - (j - t)
        let z0 = z - (k - t)

        let (i1, j1, k1, i2, j2, k2): (Int, Int, Int, Int, Int, Int)
        if x0 >= y0 {
            if y0 >= z0 {
                (i1, j1, k1, i2, j2, k2) = (1, 0, 0, 1, 1, 0)
            } else if x0 >= z0 {
                (i1, j1, k1, i2, j2, k2) = (1, 0, 0, 1, 0, 1)
            } else {
                (i1, j1, k1, i2, j2, k2) = (0, 0, 1, 1, 0, 1)
            }
        } else {
            if y0 < z0 {
                (i1, j1, k1, i2, j2, k2) = (0, 0, 1, 0, 1, 1)
            } else if x0 < z0 {
                (i1, j1, k1, i2, j2, k2) = (0, 1, 0, 0, 1, 1)
            } else {
                (i1, j1, k1, i2, j2, k2) = (0, 1, 0, 1, 1, 0)
            }
        }

        let x1 = x0 - Double(i1) + g3
        let y1 = y0 - Double(j1) + g3
        let z1 = z0 - Double(k1) + g3
        let x2 = x0 - Double(i2) + 2.0 * g3
        let y2 = y0 - Double(j2) + 2.0 * g3
        let z2 = z0 - Double(k2) + 2.0 * g3
        let x3 = x0 - 1.0 + 3.0 * g3
        let y3 = y0 - 1.0 + 3.0 * g3
        let z3 = z0 - 1.0 + 3.0 * g3

        let ii = Int(i) & 255
        let jj = Int(j) & 255
        let kk = Int(k) & 255

        let gi0 = permutation[ii + permutation[jj + permutation[kk]]] % 12
        let gi1 = permutation[ii + i1 + permutation[jj + j1 + permutation[kk + k1]]] % 12
        let gi2 = permutation[ii + i2 + permutation[jj + j2 + permutation[kk + k2]]] % 12
        let gi3 = permutation[ii + 1 + permutation[jj + 1 + permutation[kk + 1]]] % 12

        let n0 = contribution3D(x: x0, y: y0, z: z0, gradIndex: gi0)
        let n1 = contribution3D(x: x1, y: y1, z: z1, gradIndex: gi1)
        let n2 = contribution3D(x: x2, y: y2, z: z2, gradIndex: gi2)
        let n3 = contribution3D(x: x3, y: y3, z: z3, gradIndex: gi3)

        return 32.0 * (n0 + n1 + n2 + n3)
    }

    private func contribution(x: Double, y: Double, gradIndex: Int) -> Double {
        var t = 0.5 - x * x - y * y
        if t < 0 {
            return 0.0
        }
        t *= t
        let grad = gradients3D[gradIndex]
        return t * t * (grad.x * x + grad.y * y)
    }

    private func contribution3D(x: Double, y: Double, z: Double, gradIndex: Int) -> Double {
        var t = 0.6 - x * x - y * y - z * z
        if t < 0 {
            return 0.0
        }
        t *= t
        let grad = gradients3D[gradIndex]
        return t * t * (grad.x * x + grad.y * y + grad.z * z)
    }
}

// Make default permutation accessible
extension PerlinNoise {
    fileprivate static let defaultPermutation: [Int] = [
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
