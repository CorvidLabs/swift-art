import Testing
@testable import Art

@Suite("LSystem")
struct LSystemTests {
    @Test("Basic generation")
    func basicGeneration() {
        let lsystem = LSystem(
            axiom: "A",
            rules: ["A": "AB", "B": "A"],
            angle: 90
        )

        let gen0 = lsystem.iterate(generations: 0)
        #expect(gen0 == "A")

        let gen1 = lsystem.iterate(generations: 1)
        #expect(gen1 == "AB")

        let gen2 = lsystem.iterate(generations: 2)
        #expect(gen2 == "ABA")

        let gen3 = lsystem.iterate(generations: 3)
        #expect(gen3 == "ABAAB")
    }

    @Test("No rules")
    func noRules() {
        let lsystem = LSystem(axiom: "ABC", rules: [:])
        let result = lsystem.iterate(generations: 5)

        #expect(result == "ABC")
    }

    @Test("Single generation")
    func singleGeneration() {
        let lsystem = LSystem(
            axiom: "F",
            rules: ["F": "F+F-F-F+F"]
        )

        let result = lsystem.generate(from: "F")
        #expect(result == "F+F-F-F+F")
    }

    @Test("History")
    func history() {
        let lsystem = LSystem(
            axiom: "A",
            rules: ["A": "AB", "B": "A"]
        )

        let history = lsystem.iterateWithHistory(generations: 3)

        #expect(history.count == 4)
        #expect(history[0] == "A")
        #expect(history[1] == "AB")
        #expect(history[2] == "ABA")
        #expect(history[3] == "ABAAB")
    }

    @Test("Builder")
    func builder() {
        let lsystem = LSystem.builder()
            .axiom("F")
            .rule("F", produces: "F+F-F-F+F")
            .angle(90)
            .build()

        #expect(lsystem.axiom == "F")
        #expect(lsystem.rules["F"] == "F+F-F-F+F")
        #expect(lsystem.angle == 90)
    }

    @Test("Koch curve")
    func kochCurve() {
        let koch = LSystem(
            axiom: "F",
            rules: ["F": "F+F-F-F+F"],
            angle: 90
        )

        let gen1 = koch.iterate(generations: 1)
        #expect(gen1 == "F+F-F-F+F")
    }

    @Test("Algae")
    func algae() {
        let algae = LSystem(
            axiom: "A",
            rules: ["A": "AB", "B": "A"]
        )

        let lengths = (0...5).map { algae.iterate(generations: $0).count }

        #expect(lengths == [1, 2, 3, 5, 8, 13])
    }
}

@Suite("Turtle")
struct TurtleTests {
    @Test("Basic forward")
    func basicForward() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F")

        #expect(lines.count == 1)
        #expect(lines[0].start == Point2D.zero)
    }

    @Test("Turning")
    func turning() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F+F")

        #expect(lines.count == 2)
    }

    @Test("Stack operations")
    func stackOperations() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F[+F]F")

        #expect(lines.count > 0)
    }

    @Test("Forward without drawing")
    func forwardWithoutDrawing() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let withDraw = turtle.interpret("F")
        let withoutDraw = turtle.interpret("f")

        #expect(withDraw.count == 1)
        #expect(withoutDraw.count == 0)
    }

    @Test("Reverse direction")
    func reverseDirection() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F|F")

        #expect(lines.count == 2)
    }

    @Test("Bounding box")
    func boundingBox() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F+F+F+F")

        let bbox = turtle.boundingBox(for: lines)
        #expect(bbox != nil)

        if let bbox = bbox {
            #expect(bbox.min.x <= bbox.max.x)
            #expect(bbox.min.y <= bbox.max.y)
        }
    }

    @Test("Empty bounding box")
    func emptyBoundingBox() {
        let turtle = Turtle()
        let bbox = turtle.boundingBox(for: [])

        #expect(bbox == nil)
    }

    @Test("Normalize")
    func normalize() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let lines = turtle.interpret("F+F+F+F")

        let targetBounds = (
            min: Point2D(x: 0, y: 0),
            max: Point2D(x: 100, y: 100)
        )

        let normalized = turtle.normalize(lines: lines, to: targetBounds)

        #expect(normalized.count == lines.count)
    }

    @Test("Interpret with state")
    func interpretWithState() {
        let turtle = Turtle(stepLength: 10, angleIncrement: .pi / 2)
        let result = turtle.interpretWithState("F+F")

        #expect(result.lines.count == 2)
        #expect(result.finalState.angle != .pi / 2)
    }

    @Test("Line length")
    func lineLength() {
        let line = Turtle.Line(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 3, y: 4)
        )

        #expect(abs(line.length - 5.0) < 0.001)
    }

    @Test("Line midpoint")
    func lineMidpoint() {
        let line = Turtle.Line(
            start: Point2D(x: 0, y: 0),
            end: Point2D(x: 10, y: 10)
        )

        let midpoint = line.midpoint
        #expect(midpoint.x == 5.0)
        #expect(midpoint.y == 5.0)
    }
}

@Suite("LSystemPresets")
struct LSystemPresetsTests {
    @Test("Koch curve")
    func kochCurve() {
        let koch = LSystem.kochCurve
        #expect(!koch.axiom.isEmpty)
        #expect(!koch.rules.isEmpty)

        let result = koch.iterate(generations: 1)
        #expect(result == "F+F-F-F+F")
    }

    @Test("Sierpinski triangle")
    func sierpinskiTriangle() {
        let sierpinski = LSystem.sierpinskiTriangle
        let result = sierpinski.iterate(generations: 1)
        #expect(!result.isEmpty)
    }

    @Test("Dragon curve")
    func dragonCurve() {
        let dragon = LSystem.dragonCurve
        let gen2 = dragon.iterate(generations: 2)
        #expect(gen2.contains("+") || gen2.contains("-"))
    }

    @Test("Fractal plant")
    func fractalPlant() {
        let plant = LSystem.fractalPlant
        let result = plant.iterate(generations: 3)
        #expect(result.contains("["))
        #expect(result.contains("]"))
    }

    @Test("Hilbert curve")
    func hilbertCurve() {
        let hilbert = LSystem.hilbertCurve
        let result = hilbert.iterate(generations: 2)
        #expect(!result.isEmpty)
    }

    @Test("Binary tree")
    func binaryTree() {
        let tree = LSystem.binaryTree
        let result = tree.iterate(generations: 2)
        #expect(result.contains("["))
        #expect(result.contains("]"))
    }

    @Test("All presets generate")
    func allPresetsGenerate() {
        let turtle = Turtle(stepLength: 1, angleIncrement: .pi / 8)
        let presets = [
            LSystem.kochCurve,
            LSystem.sierpinskiTriangle,
            LSystem.dragonCurve,
            LSystem.fractalPlant,
            LSystem.hilbertCurve
        ]

        for lsystem in presets {
            let string = lsystem.iterate(generations: 2)
            #expect(!string.isEmpty)

            let lines = turtle.interpret(string)
            #expect(lines.count >= 0)
        }
    }

    @Test("Stochastic")
    func stochastic() {
        let (lsystem, generator) = LSystem.stochastic(
            axiom: "F",
            rules: ["F": ["F+F", "F-F", "FF"]],
            angle: .pi / 2,
            seed: 42
        )

        #expect(lsystem.axiom == "F")

        let result1 = generator(3)
        #expect(!result1.isEmpty)

        let (_, generator2) = LSystem.stochastic(
            axiom: "F",
            rules: ["F": ["F+F", "F-F", "FF"]],
            angle: .pi / 2,
            seed: 42
        )

        let result2 = generator2(3)
        #expect(result1 == result2)
    }
}
