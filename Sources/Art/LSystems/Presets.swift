import Foundation

/// Preset L-systems for common fractals and patterns.
extension LSystem {
    /// Koch curve L-system.
    public static let kochCurve = LSystem(
        axiom: "F",
        rules: ["F": "F+F-F-F+F"],
        angle: .pi / 2.0
    )

    /// Sierpinski triangle L-system.
    public static let sierpinskiTriangle = LSystem(
        axiom: "F-G-G",
        rules: [
            "F": "F-G+F+G-F",
            "G": "GG"
        ],
        angle: 2.0 * .pi / 3.0
    )

    /// Sierpinski arrowhead L-system.
    public static let sierpinskiArrowhead = LSystem(
        axiom: "A",
        rules: [
            "A": "B-A-B",
            "B": "A+B+A"
        ],
        angle: .pi / 3.0
    )

    /// Dragon curve L-system.
    public static let dragonCurve = LSystem(
        axiom: "F",
        rules: [
            "F": "F+G",
            "G": "F-G"
        ],
        angle: .pi / 2.0
    )

    /// Fractal plant L-system.
    public static let fractalPlant = LSystem(
        axiom: "X",
        rules: [
            "X": "F+[[X]-X]-F[-FX]+X",
            "F": "FF"
        ],
        angle: .pi / 8.0
    )

    /// Barnsley fern L-system.
    public static let barnsleyFern = LSystem(
        axiom: "X",
        rules: [
            "X": "F+[[X]-X]-F[-FX]+X",
            "F": "FF"
        ],
        angle: 25.0 * .pi / 180.0
    )

    /// Hilbert curve L-system.
    public static let hilbertCurve = LSystem(
        axiom: "A",
        rules: [
            "A": "-BF+AFA+FB-",
            "B": "+AF-BFB-FA+"
        ],
        angle: .pi / 2.0
    )

    /// Peano curve L-system.
    public static let peanoCurve = LSystem(
        axiom: "F",
        rules: [
            "F": "F+F-F-F-F+F+F+F-F"
        ],
        angle: .pi / 2.0
    )

    /// Gosper curve (flowsnake) L-system.
    public static let gosperCurve = LSystem(
        axiom: "A",
        rules: [
            "A": "A-B--B+A++AA+B-",
            "B": "+A-BB--B-A++A+B"
        ],
        angle: .pi / 3.0
    )

    /// Quadratic Koch island L-system.
    public static let quadraticKochIsland = LSystem(
        axiom: "F+F+F+F",
        rules: [
            "F": "F+F-F-FF+F+F-F"
        ],
        angle: .pi / 2.0
    )

    /// Levy C curve L-system.
    public static let levyCurve = LSystem(
        axiom: "F",
        rules: [
            "F": "+F--F+"
        ],
        angle: .pi / 4.0
    )

    /// Crystal L-system.
    public static let crystal = LSystem(
        axiom: "F+F+F+F",
        rules: [
            "F": "FF+F++F+F"
        ],
        angle: .pi / 2.0
    )

    /// Binary tree L-system.
    public static let binaryTree = LSystem(
        axiom: "F",
        rules: [
            "F": "F[+F]F[-F]F"
        ],
        angle: .pi / 6.0
    )

    /// Pentaplexity L-system.
    public static let pentaplexity = LSystem(
        axiom: "F++F++F++F++F",
        rules: [
            "F": "F++F++F|F-F++F"
        ],
        angle: .pi / 5.0
    )

    /// Moore curve L-system.
    public static let mooreCurve = LSystem(
        axiom: "LFL+F+LFL",
        rules: [
            "L": "-RF+LFL+FR-",
            "R": "+LF-RFR-FL+"
        ],
        angle: .pi / 2.0
    )

    /// Hexagonal Gosper curve L-system.
    public static let hexagonalGosper = LSystem(
        axiom: "A",
        rules: [
            "A": "A+B++B-A--AA-B+",
            "B": "-A+BB++B+A--A-B"
        ],
        angle: .pi / 3.0
    )

    /// Creates a custom stochastic L-system that randomly chooses between rules.
    public static func stochastic(
        axiom: String,
        rules: [Character: [String]],
        angle: Double,
        seed: UInt64? = nil
    ) -> (lsystem: LSystem, generator: (Int) -> String) {
        var rng = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))

        let generator: (Int) -> String = { generations in
            var current = axiom

            for _ in 0..<generations {
                var result = ""
                for character in current {
                    if let options = rules[character], !options.isEmpty {
                        let index = rng.nextInt(upperBound: options.count)
                        result.append(options[index])
                    } else {
                        result.append(character)
                    }
                }
                current = result
            }

            return current
        }

        let simplifiedRules = rules.mapValues { $0.first ?? "" }
        let lsystem = LSystem(axiom: axiom, rules: simplifiedRules, angle: angle)

        return (lsystem, generator)
    }
}
