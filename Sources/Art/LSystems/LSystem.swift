import Foundation

/// A Lindenmayer system (L-system) for generating fractal patterns.
public struct LSystem: Sendable {
    public let axiom: String
    public let rules: [Character: String]
    public let angle: Double

    /// Creates an L-system with the given axiom, production rules, and angle.
    public init(axiom: String, rules: [Character: String], angle: Double = 0) {
        self.axiom = axiom
        self.rules = rules
        self.angle = angle
    }

    /// Iterates the L-system for the specified number of generations.
    public func iterate(generations: Int) -> String {
        var current = axiom

        for _ in 0..<generations {
            current = generate(from: current)
        }

        return current
    }

    /// Generates the next generation from the current string.
    public func generate(from current: String) -> String {
        var result = ""

        for character in current {
            if let replacement = rules[character] {
                result.append(replacement)
            } else {
                result.append(character)
            }
        }

        return result
    }

    /// Generates multiple generations and returns all intermediate results.
    public func iterateWithHistory(generations: Int) -> [String] {
        var history = [axiom]
        var current = axiom

        for _ in 0..<generations {
            current = generate(from: current)
            history.append(current)
        }

        return history
    }
}

// MARK: - Builder

extension LSystem {
    /// A builder for creating L-systems with a fluent interface.
    public struct Builder {
        private var axiom: String = ""
        private var rules: [Character: String] = [:]
        private var angle: Double = 0

        public init() {}

        public func axiom(_ value: String) -> Builder {
            var builder = self
            builder.axiom = value
            return builder
        }

        public func rule(_ symbol: Character, produces: String) -> Builder {
            var builder = self
            builder.rules[symbol] = produces
            return builder
        }

        public func angle(_ value: Double) -> Builder {
            var builder = self
            builder.angle = value
            return builder
        }

        public func build() -> LSystem {
            LSystem(axiom: axiom, rules: rules, angle: angle)
        }
    }

    public static func builder() -> Builder {
        Builder()
    }
}
