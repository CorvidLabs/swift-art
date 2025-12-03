import SwiftUI
import Art

/// A SwiftUI view that renders Conway's Game of Life.
public struct GameOfLifeView: View {
    @Binding private var game: GameOfLife
    private let cellSize: CGFloat
    private let aliveColor: Color
    private let deadColor: Color
    private let gridLines: Bool

    /**
     Creates a Game of Life view.
     - Parameters:
       - game: A binding to the Game of Life instance.
       - cellSize: The size of each cell in points.
       - aliveColor: The color for living cells.
       - deadColor: The color for dead cells.
       - gridLines: Whether to show grid lines.
     */
    public init(
        game: Binding<GameOfLife>,
        cellSize: CGFloat = 10,
        aliveColor: Color = .white,
        deadColor: Color = .black,
        gridLines: Bool = false
    ) {
        self._game = game
        self.cellSize = cellSize
        self.aliveColor = aliveColor
        self.deadColor = deadColor
        self.gridLines = gridLines
    }

    public var body: some View {
        Canvas { context, size in
            // Draw background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(deadColor)
            )

            // Draw living cells
            for y in 0..<game.height {
                for x in 0..<game.width {
                    if game.isAlive(x: x, y: y) {
                        let rect = CGRect(
                            x: CGFloat(x) * cellSize,
                            y: CGFloat(y) * cellSize,
                            width: cellSize,
                            height: cellSize
                        )
                        context.fill(Path(rect), with: .color(aliveColor))
                    }
                }
            }

            // Draw grid lines if enabled
            if gridLines {
                var path = Path()

                for x in 0...game.width {
                    path.move(to: CGPoint(x: CGFloat(x) * cellSize, y: 0))
                    path.addLine(to: CGPoint(x: CGFloat(x) * cellSize, y: CGFloat(game.height) * cellSize))
                }

                for y in 0...game.height {
                    path.move(to: CGPoint(x: 0, y: CGFloat(y) * cellSize))
                    path.addLine(to: CGPoint(x: CGFloat(game.width) * cellSize, y: CGFloat(y) * cellSize))
                }

                context.stroke(path, with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
            }
        }
        .frame(
            width: CGFloat(game.width) * cellSize,
            height: CGFloat(game.height) * cellSize
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let x = Int(value.location.x / cellSize)
                    let y = Int(value.location.y / cellSize)
                    game.setCell(x: x, y: y, alive: true)
                }
        )
    }
}

/// A static view for Game of Life (no binding, no interaction).
public struct GameOfLifeStaticView: View {
    private let game: GameOfLife
    private let cellSize: CGFloat
    private let aliveColor: Color
    private let deadColor: Color

    public init(
        game: GameOfLife,
        cellSize: CGFloat = 10,
        aliveColor: Color = .white,
        deadColor: Color = .black
    ) {
        self.game = game
        self.cellSize = cellSize
        self.aliveColor = aliveColor
        self.deadColor = deadColor
    }

    public var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(deadColor)
            )

            for y in 0..<game.height {
                for x in 0..<game.width {
                    if game.isAlive(x: x, y: y) {
                        let rect = CGRect(
                            x: CGFloat(x) * cellSize,
                            y: CGFloat(y) * cellSize,
                            width: cellSize,
                            height: cellSize
                        )
                        context.fill(Path(rect), with: .color(aliveColor))
                    }
                }
            }
        }
        .frame(
            width: CGFloat(game.width) * cellSize,
            height: CGFloat(game.height) * cellSize
        )
    }
}

/// A SwiftUI view that renders an Elementary Cellular Automaton history.
public struct ElementaryCAView: View {
    private let history: [[Bool]]
    private let cellSize: CGFloat
    private let aliveColor: Color
    private let deadColor: Color

    /**
     Creates an Elementary CA view from pre-generated history.
     - Parameters:
       - history: The 2D array of states (generations x cells).
       - cellSize: The size of each cell in points.
       - aliveColor: The color for alive cells.
       - deadColor: The color for dead cells.
     */
    public init(
        history: [[Bool]],
        cellSize: CGFloat = 4,
        aliveColor: Color = .white,
        deadColor: Color = .black
    ) {
        self.history = history
        self.cellSize = cellSize
        self.aliveColor = aliveColor
        self.deadColor = deadColor
    }

    /**
     Creates an Elementary CA view by generating history.
     - Parameters:
       - ca: The elementary CA to generate from.
       - generations: Number of generations to generate.
       - cellSize: The size of each cell in points.
       - aliveColor: The color for alive cells.
       - deadColor: The color for dead cells.
     */
    public init(
        ca: ElementaryCA,
        generations: Int,
        cellSize: CGFloat = 4,
        aliveColor: Color = .white,
        deadColor: Color = .black
    ) {
        self.history = ca.generateHistory(generations: generations)
        self.cellSize = cellSize
        self.aliveColor = aliveColor
        self.deadColor = deadColor
    }

    public var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(deadColor)
            )

            for (y, row) in history.enumerated() {
                for (x, alive) in row.enumerated() {
                    if alive {
                        let rect = CGRect(
                            x: CGFloat(x) * cellSize,
                            y: CGFloat(y) * cellSize,
                            width: cellSize,
                            height: cellSize
                        )
                        context.fill(Path(rect), with: .color(aliveColor))
                    }
                }
            }
        }
        .frame(
            width: CGFloat(history.first?.count ?? 0) * cellSize,
            height: CGFloat(history.count) * cellSize
        )
    }
}

// MARK: - Previews

#if DEBUG
struct CellularAutomataViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            // Rule 110
            ElementaryCAView(
                ca: {
                    var ca = ElementaryCA.wellKnown(.rule110, size: 101)
                    ca.setSingleCenterCell()
                    return ca
                }(),
                generations: 50
            )

            // Rule 30
            ElementaryCAView(
                ca: {
                    var ca = ElementaryCA.wellKnown(.rule30, size: 101)
                    ca.setSingleCenterCell()
                    return ca
                }(),
                generations: 50
            )
        }
    }
}
#endif
