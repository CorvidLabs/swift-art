import Foundation

/// A turtle graphics interpreter for L-systems.
public struct Turtle: Sendable {
    public struct State: Sendable {
        public var position: Point2D
        public var angle: Double

        public init(position: Point2D = .zero, angle: Double = 0) {
            self.position = position
            self.angle = angle
        }
    }

    public struct Line: Sendable {
        public let start: Point2D
        public let end: Point2D

        public init(start: Point2D, end: Point2D) {
            self.start = start
            self.end = end
        }

        public var length: Double {
            start.distance(to: end)
        }

        public var midpoint: Point2D {
            Point2D(
                x: (start.x + end.x) / 2.0,
                y: (start.y + end.y) / 2.0
            )
        }
    }

    private let stepLength: Double
    private let angleIncrement: Double

    /// Creates a turtle graphics interpreter.
    /// - Parameters:
    ///   - stepLength: Length of each forward step.
    ///   - angleIncrement: Angle to turn for + and - commands (in radians).
    public init(stepLength: Double = 1.0, angleIncrement: Double = .pi / 2.0) {
        self.stepLength = stepLength
        self.angleIncrement = angleIncrement
    }

    /// Interprets an L-system string and generates lines.
    /// - Parameters:
    ///   - instructions: The L-system string to interpret.
    ///   - startPosition: Starting position of the turtle.
    ///   - startAngle: Starting angle of the turtle (in radians).
    /// - Returns: Array of lines representing the turtle's path.
    public func interpret(
        _ instructions: String,
        startPosition: Point2D = .zero,
        startAngle: Double = .pi / 2.0
    ) -> [Line] {
        var lines: [Line] = []
        var state = State(position: startPosition, angle: startAngle)
        var stack: [State] = []

        for character in instructions {
            switch character {
            case "F", "G": // Forward with drawing
                let newPosition = Point2D(
                    x: state.position.x + stepLength * cos(state.angle),
                    y: state.position.y + stepLength * sin(state.angle)
                )
                lines.append(Line(start: state.position, end: newPosition))
                state.position = newPosition

            case "f", "g": // Forward without drawing
                state.position = Point2D(
                    x: state.position.x + stepLength * cos(state.angle),
                    y: state.position.y + stepLength * sin(state.angle)
                )

            case "+": // Turn right
                state.angle -= angleIncrement

            case "-": // Turn left
                state.angle += angleIncrement

            case "[": // Push state
                stack.append(state)

            case "]": // Pop state
                if let previousState = stack.popLast() {
                    state = previousState
                }

            case "|": // Reverse direction
                state.angle += .pi

            default:
                break
            }
        }

        return lines
    }

    /// Interprets and returns both lines and final state.
    public func interpretWithState(
        _ instructions: String,
        startPosition: Point2D = .zero,
        startAngle: Double = .pi / 2.0
    ) -> (lines: [Line], finalState: State) {
        let lines = interpret(instructions, startPosition: startPosition, startAngle: startAngle)

        var state = State(position: startPosition, angle: startAngle)
        var stack: [State] = []

        for character in instructions {
            switch character {
            case "F", "G", "f", "g":
                state.position = Point2D(
                    x: state.position.x + stepLength * cos(state.angle),
                    y: state.position.y + stepLength * sin(state.angle)
                )
            case "+":
                state.angle -= angleIncrement
            case "-":
                state.angle += angleIncrement
            case "[":
                stack.append(state)
            case "]":
                if let previousState = stack.popLast() {
                    state = previousState
                }
            case "|":
                state.angle += .pi
            default:
                break
            }
        }

        return (lines, state)
    }

    /// Calculates the bounding box of the generated lines.
    public func boundingBox(for lines: [Line]) -> (min: Point2D, max: Point2D)? {
        guard !lines.isEmpty else { return nil }

        var minX = Double.infinity
        var minY = Double.infinity
        var maxX = -Double.infinity
        var maxY = -Double.infinity

        for line in lines {
            minX = min(minX, line.start.x, line.end.x)
            minY = min(minY, line.start.y, line.end.y)
            maxX = max(maxX, line.start.x, line.end.x)
            maxY = max(maxY, line.start.y, line.end.y)
        }

        return (Point2D(x: minX, y: minY), Point2D(x: maxX, y: maxY))
    }

    /// Normalizes lines to fit within the given bounds.
    public func normalize(lines: [Line], to bounds: (min: Point2D, max: Point2D)) -> [Line] {
        guard let bbox = boundingBox(for: lines) else { return lines }

        let width = bbox.max.x - bbox.min.x
        let height = bbox.max.y - bbox.min.y
        let targetWidth = bounds.max.x - bounds.min.x
        let targetHeight = bounds.max.y - bounds.min.y

        guard width > 0 && height > 0 else { return lines }

        let scale = min(targetWidth / width, targetHeight / height)

        return lines.map { line in
            let normalizedStart = Point2D(
                x: bounds.min.x + (line.start.x - bbox.min.x) * scale,
                y: bounds.min.y + (line.start.y - bbox.min.y) * scale
            )
            let normalizedEnd = Point2D(
                x: bounds.min.x + (line.end.x - bbox.min.x) * scale,
                y: bounds.min.y + (line.end.y - bbox.min.y) * scale
            )
            return Line(start: normalizedStart, end: normalizedEnd)
        }
    }
}
