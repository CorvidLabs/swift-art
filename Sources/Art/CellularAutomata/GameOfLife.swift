import Foundation

/// Conway's Game of Life cellular automaton.
public struct GameOfLife: Sendable {
    public private(set) var grid: [[Bool]]
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.grid = Array(repeating: Array(repeating: false, count: width), count: height)
    }

    public init(grid: [[Bool]]) {
        self.grid = grid
        self.height = grid.count
        self.width = grid.first?.count ?? 0
    }

    /// Sets a cell to alive or dead.
    public mutating func setCell(x: Int, y: Int, alive: Bool) {
        guard x >= 0 && x < width && y >= 0 && y < height else { return }
        grid[y][x] = alive
    }

    /// Gets the state of a cell.
    public func isAlive(x: Int, y: Int) -> Bool {
        guard x >= 0 && x < width && y >= 0 && y < height else { return false }
        return grid[y][x]
    }

    /// Returns all living cells as coordinates.
    public var livingCells: [Point2D] {
        var cells: [Point2D] = []
        for y in 0..<height {
            for x in 0..<width {
                if grid[y][x] {
                    cells.append(Point2D(x: Double(x), y: Double(y)))
                }
            }
        }
        return cells
    }

    /// Advances the simulation by one generation.
    public mutating func step() {
        var newGrid = grid

        for y in 0..<height {
            for x in 0..<width {
                let neighbors = countNeighbors(x: x, y: y)
                let alive = grid[y][x]

                if alive {
                    newGrid[y][x] = neighbors == 2 || neighbors == 3
                } else {
                    newGrid[y][x] = neighbors == 3
                }
            }
        }

        grid = newGrid
    }

    /// Advances multiple generations.
    public mutating func step(count: Int) {
        for _ in 0..<count {
            step()
        }
    }

    /// Counts the number of living neighbors around a cell.
    private func countNeighbors(x: Int, y: Int) -> Int {
        var count = 0

        for dy in -1...1 {
            for dx in -1...1 {
                if dx == 0 && dy == 0 { continue }

                let nx = x + dx
                let ny = y + dy

                if nx >= 0 && nx < width && ny >= 0 && ny < height {
                    if grid[ny][nx] {
                        count += 1
                    }
                }
            }
        }

        return count
    }

    /// Randomizes the grid with the given probability of a cell being alive.
    public mutating func randomize(probability: Double = 0.5, seed: UInt64? = nil) {
        var rng = RandomSource(seed: seed ?? UInt64(Date().timeIntervalSince1970 * 1_000_000))

        for y in 0..<height {
            for x in 0..<width {
                grid[y][x] = rng.nextBool(probability: probability)
            }
        }
    }

    /// Clears the grid (sets all cells to dead).
    public mutating func clear() {
        grid = Array(repeating: Array(repeating: false, count: width), count: height)
    }

    /// Returns the number of living cells.
    public var populationCount: Int {
        grid.reduce(0) { total, row in
            total + row.filter { $0 }.count
        }
    }
}

// MARK: - Patterns

extension GameOfLife {
    /// Places a pattern at the specified position.
    public mutating func placePattern(_ pattern: Pattern, at origin: Point2D) {
        let x = Int(origin.x)
        let y = Int(origin.y)

        for (dy, row) in pattern.cells.enumerated() {
            for (dx, cell) in row.enumerated() {
                let nx = x + dx
                let ny = y + dy
                if nx >= 0 && nx < width && ny >= 0 && ny < height {
                    grid[ny][nx] = cell
                }
            }
        }
    }

    public struct Pattern: Sendable {
        public let cells: [[Bool]]

        public init(cells: [[Bool]]) {
            self.cells = cells
        }

        /// Glider pattern.
        public static let glider = Pattern(cells: [
            [false, true, false],
            [false, false, true],
            [true, true, true]
        ])

        /// Blinker pattern (oscillator).
        public static let blinker = Pattern(cells: [
            [true, true, true]
        ])

        /// Toad pattern (oscillator).
        public static let toad = Pattern(cells: [
            [false, true, true, true],
            [true, true, true, false]
        ])

        /// Beacon pattern (oscillator).
        public static let beacon = Pattern(cells: [
            [true, true, false, false],
            [true, true, false, false],
            [false, false, true, true],
            [false, false, true, true]
        ])

        /// Block pattern (still life).
        public static let block = Pattern(cells: [
            [true, true],
            [true, true]
        ])

        /// Beehive pattern (still life).
        public static let beehive = Pattern(cells: [
            [false, true, true, false],
            [true, false, false, true],
            [false, true, true, false]
        ])

        /// Lightweight spaceship (LWSS).
        public static let lwss = Pattern(cells: [
            [false, true, false, false, true],
            [true, false, false, false, false],
            [true, false, false, false, true],
            [true, true, true, true, false]
        ])

        /// Gosper glider gun.
        public static let gosperGliderGun = Pattern(cells: [
            [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false],
            [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false],
            [false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, true],
            [false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, true, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, true],
            [true, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, true, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
            [true, true, false, false, false, false, false, false, false, false, true, false, false, false, true, false, true, true, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false],
            [false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false],
            [false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
            [false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
        ])
    }
}
