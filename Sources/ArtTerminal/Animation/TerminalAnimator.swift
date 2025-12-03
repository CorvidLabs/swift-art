import Foundation
import Art

/// An animator for displaying ASCII animations in the terminal.
public struct TerminalAnimator: Sendable {
    /// The frames per second for the animation.
    public let fps: Int

    /// Whether to clear the screen between frames.
    public let clearScreen: Bool

    /**
     Creates a terminal animator.
     - Parameters:
       - fps: Frames per second (default 10).
       - clearScreen: Whether to clear the screen between frames.
     */
    public init(fps: Int = 10, clearScreen: Bool = true) {
        self.fps = max(1, fps)
        self.clearScreen = clearScreen
    }

    /**
     Runs an animation loop.
     - Parameters:
       - frameCount: Number of frames to render (nil for infinite).
       - render: A closure that returns the canvas for each frame.
     */
    public func animate(
        frameCount: Int? = nil,
        render: @escaping (Int) -> ASCIICanvas
    ) async {
        var frame = 0
        let frameDelay = UInt64(1_000_000_000 / fps)

        while frameCount == nil || frame < frameCount! {
            if clearScreen {
                // ANSI escape code to clear screen and move cursor to top-left
                print("\u{001B}[2J\u{001B}[H", terminator: "")
            }

            let canvas = render(frame)
            print(canvas.render())

            try? await Task.sleep(nanoseconds: frameDelay)
            frame += 1
        }
    }

    /**
     Runs an animation loop with a string-based renderer.
     - Parameters:
       - frameCount: Number of frames to render (nil for infinite).
       - render: A closure that returns the ASCII string for each frame.
     */
    public func animateString(
        frameCount: Int? = nil,
        render: @escaping (Int) -> String
    ) async {
        var frame = 0
        let frameDelay = UInt64(1_000_000_000 / fps)

        while frameCount == nil || frame < frameCount! {
            if clearScreen {
                print("\u{001B}[2J\u{001B}[H", terminator: "")
            }

            let output = render(frame)
            print(output)

            try? await Task.sleep(nanoseconds: frameDelay)
            frame += 1
        }
    }
}

// MARK: - Game of Life Animation

/**
 Animates a Game of Life instance in the terminal.
 - Parameters:
   - game: The initial game state (will be copied and evolved).
   - generations: Number of generations to animate (nil for infinite).
   - fps: Frames per second.
   - aliveChar: Character for living cells.
   - deadChar: Character for dead cells.
 */
public func animateGameOfLife(
    _ game: GameOfLife,
    generations: Int? = nil,
    fps: Int = 10,
    aliveChar: Character = "█",
    deadChar: Character = " "
) async {
    let animator = TerminalAnimator(fps: fps)
    var currentGame = game
    var currentGen = 0

    await animator.animateString(frameCount: generations) { _ in
        let output = currentGame.renderASCII(aliveChar: aliveChar, deadChar: deadChar)
        currentGame.step()
        currentGen += 1
        return "Generation: \(currentGen)\n" + output
    }
}

// MARK: - Noise Animation

extension NoiseGenerator {
    /**
     Runs an animated noise visualization in the terminal.
     - Parameters:
       - width: Canvas width.
       - height: Canvas height.
       - scale: Spatial scale.
       - timeScale: Temporal scale (speed of z-axis movement).
       - frames: Number of frames (nil for infinite).
       - fps: Frames per second.
       - palette: The character palette.
     */
    public func animateASCII(
        width: Int = 80,
        height: Int = 40,
        scale: Double = 0.1,
        timeScale: Double = 0.1,
        frames: Int? = nil,
        fps: Int = 15,
        palette: ASCIIPalette = .standard
    ) async {
        let animator = TerminalAnimator(fps: fps)

        await animator.animateString(frameCount: frames) { frame in
            var result = ""
            let time = Double(frame) * timeScale

            for y in 0..<height {
                for x in 0..<width {
                    let value = self.normalized(
                        x: Double(x) * scale,
                        y: Double(y) * scale,
                        z: time
                    )
                    result.append(palette.character(for: value))
                }
                if y < height - 1 {
                    result.append("\n")
                }
            }

            return result
        }
    }
}
