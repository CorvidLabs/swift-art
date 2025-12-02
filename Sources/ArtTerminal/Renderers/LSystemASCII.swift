import Art

extension Turtle {
    /// Renders lines to an ASCII canvas using Bresenham's line algorithm.
    /// - Parameters:
    ///   - lines: The lines to render.
    ///   - width: The canvas width.
    ///   - height: The canvas height.
    ///   - lineChar: The character for lines.
    ///   - backgroundChar: The background character.
    /// - Returns: An ASCII canvas with the lines rendered.
    public func toASCIICanvas(
        lines: [Line],
        width: Int,
        height: Int,
        lineChar: Character = "#",
        backgroundChar: Character = " "
    ) -> ASCIICanvas {
        var canvas = ASCIICanvas(width: width, height: height, defaultCharacter: backgroundChar)

        guard let bbox = boundingBox(for: lines) else { return canvas }

        let bboxWidth = bbox.max.x - bbox.min.x
        let bboxHeight = bbox.max.y - bbox.min.y

        guard bboxWidth > 0 && bboxHeight > 0 else { return canvas }

        let padding = 2.0
        let availableWidth = Double(width) - padding * 2
        let availableHeight = Double(height) - padding * 2

        let scale = min(availableWidth / bboxWidth, availableHeight / bboxHeight)

        let scaledWidth = bboxWidth * scale
        let scaledHeight = bboxHeight * scale
        let offsetX = (Double(width) - scaledWidth) / 2 - bbox.min.x * scale
        let offsetY = (Double(height) - scaledHeight) / 2 - bbox.min.y * scale

        for line in lines {
            let x0 = Int((line.start.x * scale + offsetX).rounded())
            let y0 = Int((line.start.y * scale + offsetY).rounded())
            let x1 = Int((line.end.x * scale + offsetX).rounded())
            let y1 = Int((line.end.y * scale + offsetY).rounded())

            drawLine(on: &canvas, from: (x0, y0), to: (x1, y1), character: lineChar)
        }

        return canvas
    }

    /// Draws a line on the canvas using Bresenham's algorithm.
    private func drawLine(
        on canvas: inout ASCIICanvas,
        from start: (Int, Int),
        to end: (Int, Int),
        character: Character
    ) {
        var x0 = start.0
        var y0 = start.1
        let x1 = end.0
        let y1 = end.1

        let dx = abs(x1 - x0)
        let dy = -abs(y1 - y0)
        let sx = x0 < x1 ? 1 : -1
        let sy = y0 < y1 ? 1 : -1
        var error = dx + dy

        while true {
            canvas.set(character: character, at: (x0, y0))

            if x0 == x1 && y0 == y1 { break }

            let e2 = 2 * error

            if e2 >= dy {
                error += dy
                x0 += sx
            }

            if e2 <= dx {
                error += dx
                y0 += sy
            }
        }
    }
}

extension LSystem {
    /// Renders the L-system to an ASCII string.
    /// - Parameters:
    ///   - generations: Number of generations to iterate.
    ///   - width: The canvas width.
    ///   - height: The canvas height.
    ///   - turtle: The turtle interpreter.
    ///   - lineChar: The character for lines.
    ///   - backgroundChar: The background character.
    /// - Returns: A multi-line ASCII string.
    public func renderASCII(
        generations: Int,
        width: Int = 80,
        height: Int = 40,
        turtle: Turtle? = nil,
        lineChar: Character = "#",
        backgroundChar: Character = " "
    ) -> String {
        let interpreter = turtle ?? Turtle(stepLength: 1.0, angleIncrement: angle)
        let instructions = iterate(generations: generations)
        let lines = interpreter.interpret(instructions)

        let canvas = interpreter.toASCIICanvas(
            lines: lines,
            width: width,
            height: height,
            lineChar: lineChar,
            backgroundChar: backgroundChar
        )

        return canvas.render()
    }
}
