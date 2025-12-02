import SwiftUI
import Art

/// A SwiftUI view that renders an L-System.
public struct LSystemView: View {
    private let lines: [Turtle.Line]
    private let strokeColor: Color
    private let strokeWidth: CGFloat
    private let backgroundColor: Color

    /// Creates an L-System view.
    /// - Parameters:
    ///   - lsystem: The L-System to render.
    ///   - generations: Number of generations to iterate.
    ///   - turtle: The turtle interpreter to use.
    ///   - strokeColor: The color for the lines.
    ///   - strokeWidth: The width of the lines.
    ///   - backgroundColor: The background color.
    public init(
        lsystem: LSystem,
        generations: Int,
        turtle: Turtle? = nil,
        strokeColor: Color = .white,
        strokeWidth: CGFloat = 1.0,
        backgroundColor: Color = .black
    ) {
        let interpreter = turtle ?? Turtle(stepLength: 5.0, angleIncrement: lsystem.angle)
        let instructions = lsystem.iterate(generations: generations)
        self.lines = interpreter.interpret(instructions)
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.backgroundColor = backgroundColor
    }

    /// Creates an L-System view from pre-computed lines.
    /// - Parameters:
    ///   - lines: The lines to render.
    ///   - strokeColor: The color for the lines.
    ///   - strokeWidth: The width of the lines.
    ///   - backgroundColor: The background color.
    public init(
        lines: [Turtle.Line],
        strokeColor: Color = .white,
        strokeWidth: CGFloat = 1.0,
        backgroundColor: Color = .black
    ) {
        self.lines = lines
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Canvas { context, size in
            // Fill background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(backgroundColor)
            )

            guard !lines.isEmpty else { return }

            // Calculate bounding box
            let turtle = Turtle()
            guard let bbox = turtle.boundingBox(for: lines) else { return }

            // Calculate scale to fit
            let bboxWidth = bbox.max.x - bbox.min.x
            let bboxHeight = bbox.max.y - bbox.min.y

            guard bboxWidth > 0 && bboxHeight > 0 else { return }

            let padding: CGFloat = 20
            let availableWidth = size.width - padding * 2
            let availableHeight = size.height - padding * 2

            let scale = min(availableWidth / bboxWidth, availableHeight / bboxHeight)

            // Calculate offset to center
            let scaledWidth = bboxWidth * scale
            let scaledHeight = bboxHeight * scale
            let offsetX = (size.width - scaledWidth) / 2 - bbox.min.x * scale
            let offsetY = (size.height - scaledHeight) / 2 - bbox.min.y * scale

            // Draw lines
            var path = Path()
            for line in lines {
                let start = CGPoint(
                    x: line.start.x * scale + offsetX,
                    y: line.start.y * scale + offsetY
                )
                let end = CGPoint(
                    x: line.end.x * scale + offsetX,
                    y: line.end.y * scale + offsetY
                )
                path.move(to: start)
                path.addLine(to: end)
            }

            context.stroke(
                path,
                with: .color(strokeColor),
                style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

// MARK: - Previews

#if DEBUG
struct LSystemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LSystemView(
                lsystem: .kochCurve,
                generations: 4,
                strokeColor: .cyan
            )
            .frame(width: 300, height: 200)

            LSystemView(
                lsystem: .fractalPlant,
                generations: 5,
                strokeColor: .green
            )
            .frame(width: 300, height: 300)
        }
    }
}
#endif
