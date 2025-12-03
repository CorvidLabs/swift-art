import Foundation

/// A 2D character canvas for ASCII art rendering.
public struct ASCIICanvas: Sendable {
    /// The width of the canvas in characters.
    public let width: Int

    /// The height of the canvas in characters.
    public let height: Int

    /// The character data.
    private var data: [[Character]]

    /**
     Creates an empty canvas with the given dimensions.
     - Parameters:
       - width: The width in characters.
       - height: The height in characters.
       - defaultCharacter: The character to fill the canvas with (default: space).
     */
    public init(width: Int, height: Int, defaultCharacter: Character = " ") {
        self.width = max(1, width)
        self.height = max(1, height)
        self.data = Array(
            repeating: Array(repeating: defaultCharacter, count: self.width),
            count: self.height
        )
    }

    /**
     Gets the character at the specified position.
     - Parameters:
       - x: The x coordinate (0 = left).
       - y: The y coordinate (0 = top).
     - Returns: The character at that position, or nil if out of bounds.
     */
    public func get(at position: (Int, Int)) -> Character? {
        let (x, y) = position
        guard x >= 0, x < width, y >= 0, y < height else { return nil }
        return data[y][x]
    }

    /**
     Sets the character at the specified position.
     - Parameters:
       - character: The character to set.
       - position: The (x, y) position.
     */
    public mutating func set(character: Character, at position: (Int, Int)) {
        let (x, y) = position
        guard x >= 0, x < width, y >= 0, y < height else { return }
        data[y][x] = character
    }

    /// Subscript access to canvas characters.
    public subscript(x: Int, y: Int) -> Character {
        get {
            get(at: (x, y)) ?? " "
        }
        set {
            set(character: newValue, at: (x, y))
        }
    }

    /**
     Renders the canvas to a multi-line string.
     - Returns: The rendered ASCII art string.
     */
    public func render() -> String {
        data.map { String($0) }.joined(separator: "\n")
    }

    /**
     Clears the canvas with the specified character.
     - Parameter character: The character to fill with (default: space).
     */
    public mutating func clear(with character: Character = " ") {
        data = Array(
            repeating: Array(repeating: character, count: width),
            count: height
        )
    }

    /**
     Draws a horizontal line.
     - Parameters:
       - y: The y coordinate.
       - fromX: Starting x coordinate.
       - toX: Ending x coordinate.
       - character: The character to draw with.
     */
    public mutating func drawHorizontalLine(y: Int, fromX: Int, toX: Int, character: Character) {
        let startX = min(fromX, toX)
        let endX = max(fromX, toX)
        for x in startX...endX {
            set(character: character, at: (x, y))
        }
    }

    /**
     Draws a vertical line.
     - Parameters:
       - x: The x coordinate.
       - fromY: Starting y coordinate.
       - toY: Ending y coordinate.
       - character: The character to draw with.
     */
    public mutating func drawVerticalLine(x: Int, fromY: Int, toY: Int, character: Character) {
        let startY = min(fromY, toY)
        let endY = max(fromY, toY)
        for y in startY...endY {
            set(character: character, at: (x, y))
        }
    }

    /**
     Draws a rectangle outline.
     - Parameters:
       - x: Top-left x coordinate.
       - y: Top-left y coordinate.
       - rectWidth: Width of the rectangle.
       - rectHeight: Height of the rectangle.
       - character: The character to draw with.
     */
    public mutating func drawRect(x: Int, y: Int, width rectWidth: Int, height rectHeight: Int, character: Character) {
        drawHorizontalLine(y: y, fromX: x, toX: x + rectWidth - 1, character: character)
        drawHorizontalLine(y: y + rectHeight - 1, fromX: x, toX: x + rectWidth - 1, character: character)
        drawVerticalLine(x: x, fromY: y, toY: y + rectHeight - 1, character: character)
        drawVerticalLine(x: x + rectWidth - 1, fromY: y, toY: y + rectHeight - 1, character: character)
    }

    /**
     Fills a rectangle.
     - Parameters:
       - x: Top-left x coordinate.
       - y: Top-left y coordinate.
       - rectWidth: Width of the rectangle.
       - rectHeight: Height of the rectangle.
       - character: The character to fill with.
     */
    public mutating func fillRect(x: Int, y: Int, width rectWidth: Int, height rectHeight: Int, character: Character) {
        for dy in 0..<rectHeight {
            for dx in 0..<rectWidth {
                set(character: character, at: (x + dx, y + dy))
            }
        }
    }

    /**
     Draws text at the specified position.
     - Parameters:
       - text: The text to draw.
       - x: The starting x coordinate.
       - y: The y coordinate.
     */
    public mutating func drawText(_ text: String, x: Int, y: Int) {
        for (index, char) in text.enumerated() {
            set(character: char, at: (x + index, y))
        }
    }
}

// MARK: - CustomStringConvertible

extension ASCIICanvas: CustomStringConvertible {
    public var description: String {
        render()
    }
}
