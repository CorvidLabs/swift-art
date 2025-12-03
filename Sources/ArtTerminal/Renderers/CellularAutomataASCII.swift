import Art

extension GameOfLife {
    /**
     Renders the Game of Life grid to an ASCII string.
     - Parameters:
       - aliveChar: Character for living cells.
       - deadChar: Character for dead cells.
     - Returns: A multi-line string representation.
     */
    public func renderASCII(
        aliveChar: Character = "█",
        deadChar: Character = " "
    ) -> String {
        var result = ""

        for y in 0..<height {
            for x in 0..<width {
                result.append(isAlive(x: x, y: y) ? aliveChar : deadChar)
            }
            if y < height - 1 {
                result.append("\n")
            }
        }

        return result
    }

    /// Creates an ASCII canvas with the grid rendered.
    public func toASCIICanvas(
        aliveChar: Character = "█",
        deadChar: Character = " "
    ) -> ASCIICanvas {
        var canvas = ASCIICanvas(width: width, height: height)

        for y in 0..<height {
            for x in 0..<width {
                let character = isAlive(x: x, y: y) ? aliveChar : deadChar
                canvas.set(character: character, at: (x, y))
            }
        }

        return canvas
    }
}

extension ElementaryCA {
    /**
     Renders the current state to an ASCII string.
     - Parameters:
       - aliveChar: Character for alive cells.
       - deadChar: Character for dead cells.
     - Returns: A single-line string representation.
     */
    public func renderASCII(
        aliveChar: Character = "█",
        deadChar: Character = " "
    ) -> String {
        var result = ""

        for cell in state {
            result.append(cell ? aliveChar : deadChar)
        }

        return result
    }

    /**
     Renders the history to an ASCII string.
     - Parameters:
       - generations: Number of generations to generate.
       - aliveChar: Character for alive cells.
       - deadChar: Character for dead cells.
     - Returns: A multi-line string representation.
     */
    public func renderHistoryASCII(
        generations: Int,
        aliveChar: Character = "█",
        deadChar: Character = " "
    ) -> String {
        let history = generateHistory(generations: generations)
        var result = ""

        for (index, row) in history.enumerated() {
            for cell in row {
                result.append(cell ? aliveChar : deadChar)
            }
            if index < history.count - 1 {
                result.append("\n")
            }
        }

        return result
    }

    /// Creates an ASCII canvas with the history rendered.
    public func toASCIICanvas(
        generations: Int,
        aliveChar: Character = "█",
        deadChar: Character = " "
    ) -> ASCIICanvas {
        let history = generateHistory(generations: generations)
        let height = history.count
        let width = history.first?.count ?? 0

        var canvas = ASCIICanvas(width: width, height: height)

        for (y, row) in history.enumerated() {
            for (x, cell) in row.enumerated() {
                let character = cell ? aliveChar : deadChar
                canvas.set(character: character, at: (x, y))
            }
        }

        return canvas
    }
}
