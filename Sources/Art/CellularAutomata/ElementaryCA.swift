import Foundation

/// Wolfram elementary cellular automaton (1D).
public struct ElementaryCA: Sendable {
    public let rule: Int
    public private(set) var state: [Bool]
    private let ruleLookup: [Int: Bool]

    /// Creates an elementary CA with the given rule number (0-255).
    public init(rule: Int, size: Int) {
        self.rule = rule.clamped(to: 0...255)
        self.state = Array(repeating: false, count: size)
        self.ruleLookup = Self.createRuleLookup(for: self.rule)
    }

    /// Creates an elementary CA with the given rule and initial state.
    public init(rule: Int, state: [Bool]) {
        self.rule = rule.clamped(to: 0...255)
        self.state = state
        self.ruleLookup = Self.createRuleLookup(for: self.rule)
    }

    /// Sets a cell to the given value.
    public mutating func setCell(at index: Int, value: Bool) {
        guard index >= 0 && index < state.count else { return }
        state[index] = value
    }

    /// Gets the value of a cell.
    public func getCell(at index: Int) -> Bool {
        guard index >= 0 && index < state.count else { return false }
        return state[index]
    }

    /// Advances the automaton by one generation.
    public mutating func step() {
        var newState = state

        for i in 0..<state.count {
            let left = i > 0 ? state[i - 1] : false
            let center = state[i]
            let right = i < state.count - 1 ? state[i + 1] : false

            let pattern = (left ? 4 : 0) + (center ? 2 : 0) + (right ? 1 : 0)
            newState[i] = ruleLookup[pattern] ?? false
        }

        state = newState
    }

    /// Advances the automaton by multiple generations.
    public mutating func step(count: Int) {
        for _ in 0..<count {
            step()
        }
    }

    /// Generates a history of states for the given number of generations.
    public func generateHistory(generations: Int) -> [[Bool]] {
        var history = [state]
        var current = self

        for _ in 0..<generations {
            current.step()
            history.append(current.state)
        }

        return history
    }

    /// Sets the initial state with a single cell in the center.
    public mutating func setSingleCenterCell() {
        state = Array(repeating: false, count: state.count)
        let center = state.count / 2
        state[center] = true
    }

    /// Randomizes the state.
    public mutating func randomize(probability: Double = 0.5, seed: UInt64? = nil) {
        var rng = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))

        for i in 0..<state.count {
            state[i] = rng.nextBool(probability: probability)
        }
    }

    /// Creates a lookup table for the given rule number.
    private static func createRuleLookup(for rule: Int) -> [Int: Bool] {
        var lookup: [Int: Bool] = [:]

        for pattern in 0...7 {
            let bit = (rule >> pattern) & 1
            lookup[pattern] = bit == 1
        }

        return lookup
    }
}

// MARK: - Interesting Rules

extension ElementaryCA {
    /// Well-known elementary CA rules.
    public enum WellKnownRule: Int, CaseIterable, Sendable {
        case rule30 = 30    // Chaotic, used in Mathematica's random number generator
        case rule54 = 54    // Sierpinski triangle
        case rule60 = 60    // Similar to Pascal's triangle
        case rule90 = 90    // Sierpinski triangle (XOR)
        case rule110 = 110  // Turing complete, complex behavior
        case rule124 = 124  // Growth pattern
        case rule150 = 150  // Checkerboard-like pattern
        case rule184 = 184  // Traffic flow model
        case rule250 = 250  // Symmetric pattern

        public var description: String {
            switch self {
            case .rule30: return "Rule 30 (Chaotic)"
            case .rule54: return "Rule 54 (Sierpinski)"
            case .rule60: return "Rule 60 (Pascal's Triangle)"
            case .rule90: return "Rule 90 (Sierpinski XOR)"
            case .rule110: return "Rule 110 (Turing Complete)"
            case .rule124: return "Rule 124 (Growth)"
            case .rule150: return "Rule 150 (Checkerboard)"
            case .rule184: return "Rule 184 (Traffic Flow)"
            case .rule250: return "Rule 250 (Symmetric)"
            }
        }
    }

    /// Creates an elementary CA with a well-known rule.
    public static func wellKnown(_ rule: WellKnownRule, size: Int) -> ElementaryCA {
        ElementaryCA(rule: rule.rawValue, size: size)
    }
}

// MARK: - Helpers

extension Int {
    fileprivate func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
