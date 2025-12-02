import Testing
@testable import Art

@Suite("GameOfLife")
struct GameOfLifeTests {
    @Test("Initialization")
    func initialization() {
        let game = GameOfLife(width: 10, height: 10)
        #expect(game.width == 10)
        #expect(game.height == 10)
    }

    @Test("Set and get cell")
    func setAndGetCell() {
        var game = GameOfLife(width: 10, height: 10)
        game.setCell(x: 5, y: 5, alive: true)

        #expect(game.isAlive(x: 5, y: 5))
        #expect(!game.isAlive(x: 0, y: 0))
    }

    @Test("Out of bounds cell")
    func outOfBoundsCell() {
        var game = GameOfLife(width: 10, height: 10)
        game.setCell(x: 100, y: 100, alive: true)

        #expect(!game.isAlive(x: 100, y: 100))
        #expect(!game.isAlive(x: -1, y: -1))
    }

    @Test("Population count")
    func populationCount() {
        var game = GameOfLife(width: 10, height: 10)
        #expect(game.populationCount == 0)

        game.setCell(x: 0, y: 0, alive: true)
        game.setCell(x: 1, y: 1, alive: true)
        game.setCell(x: 2, y: 2, alive: true)

        #expect(game.populationCount == 3)
    }

    @Test("Clear")
    func clear() {
        var game = GameOfLife(width: 10, height: 10)
        game.setCell(x: 5, y: 5, alive: true)
        game.clear()

        #expect(game.populationCount == 0)
    }

    @Test("Randomize")
    func randomize() {
        var game = GameOfLife(width: 10, height: 10)
        game.randomize(probability: 0.5, seed: 42)

        let population = game.populationCount
        #expect(population > 0)
        #expect(population < 100)
    }

    @Test("Randomize deterministic")
    func randomizeDeterministic() {
        var game1 = GameOfLife(width: 10, height: 10)
        var game2 = GameOfLife(width: 10, height: 10)

        game1.randomize(probability: 0.5, seed: 12345)
        game2.randomize(probability: 0.5, seed: 12345)

        #expect(game1.populationCount == game2.populationCount)
    }

    @Test("Still life")
    func stillLife() {
        var game = GameOfLife(width: 10, height: 10)

        game.setCell(x: 5, y: 5, alive: true)
        game.setCell(x: 6, y: 5, alive: true)
        game.setCell(x: 5, y: 6, alive: true)
        game.setCell(x: 6, y: 6, alive: true)

        let initialPopulation = game.populationCount
        game.step()

        #expect(game.populationCount == initialPopulation)
    }

    @Test("Blinker oscillator")
    func blinkerOscillator() {
        var game = GameOfLife(width: 5, height: 5)

        game.setCell(x: 1, y: 2, alive: true)
        game.setCell(x: 2, y: 2, alive: true)
        game.setCell(x: 3, y: 2, alive: true)

        let initialState = game.grid

        game.step()
        let afterOneStep = game.grid

        #expect(initialState != afterOneStep)

        game.step()
        let afterTwoSteps = game.grid

        #expect(initialState == afterTwoSteps)
    }

    @Test("Multiple steps")
    func multipleSteps() {
        var game = GameOfLife(width: 10, height: 10)
        game.randomize(probability: 0.5, seed: 42)

        game.step(count: 10)

        #expect(game.populationCount >= 0)
    }

    @Test("Living cells")
    func livingCells() {
        var game = GameOfLife(width: 10, height: 10)
        game.setCell(x: 2, y: 3, alive: true)
        game.setCell(x: 5, y: 7, alive: true)

        let living = game.livingCells

        #expect(living.count == 2)
        #expect(living.contains(Point2D(x: 2, y: 3)))
        #expect(living.contains(Point2D(x: 5, y: 7)))
    }

    @Test("Place pattern glider")
    func placePatternGlider() {
        var game = GameOfLife(width: 20, height: 20)
        game.placePattern(.glider, at: Point2D(x: 5, y: 5))

        let population = game.populationCount
        #expect(population == 5)
    }

    @Test("Place pattern blinker")
    func placePatternBlinker() {
        var game = GameOfLife(width: 20, height: 20)
        game.placePattern(.blinker, at: Point2D(x: 10, y: 10))

        #expect(game.populationCount == 3)
    }

    @Test("Place pattern block")
    func placePatternBlock() {
        var game = GameOfLife(width: 20, height: 20)
        game.placePattern(.block, at: Point2D(x: 5, y: 5))

        game.step()

        #expect(game.populationCount == 4)
    }

    @Test("Pattern beehive")
    func patternBeehive() {
        let pattern = GameOfLife.Pattern.beehive
        #expect(pattern.cells.count == 3)
    }

    @Test("Glider movement")
    func gliderMovement() {
        var game = GameOfLife(width: 20, height: 20)
        game.placePattern(.glider, at: Point2D(x: 5, y: 5))

        let initialCells = game.livingCells
        game.step(count: 4)
        let finalCells = game.livingCells

        #expect(initialCells != finalCells)
    }

    @Test("Init with grid")
    func initWithGrid() {
        let grid = [
            [true, false, true],
            [false, true, false],
            [true, false, true]
        ]

        let game = GameOfLife(grid: grid)

        #expect(game.width == 3)
        #expect(game.height == 3)
        #expect(game.populationCount == 5)
    }
}
