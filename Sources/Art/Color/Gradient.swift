import Foundation

/// A multi-stop color gradient.
public struct Gradient: Sendable {
    public struct Stop: Sendable {
        public let color: RGBColor
        public let position: Double

        public init(color: RGBColor, position: Double) {
            self.color = color
            self.position = position.clamped(to: 0...1)
        }
    }

    public let stops: [Stop]

    /// Creates a gradient with the given color stops.
    public init(stops: [Stop]) {
        self.stops = stops.sorted { $0.position < $1.position }
    }

    /// Creates a gradient with evenly spaced colors.
    public init(colors: [RGBColor]) {
        guard !colors.isEmpty else {
            self.stops = []
            return
        }

        if colors.count == 1 {
            self.stops = [Stop(color: colors[0], position: 0)]
        } else {
            self.stops = colors.enumerated().map { index, color in
                let position = Double(index) / Double(colors.count - 1)
                return Stop(color: color, position: position)
            }
        }
    }

    /// Samples the gradient at the given position [0, 1].
    public func sample(at t: Double) -> RGBColor {
        guard !stops.isEmpty else { return .black }
        guard stops.count > 1 else { return stops[0].color }

        let t = t.clamped(to: 0...1)

        if t <= stops[0].position {
            return stops[0].color
        }

        if t >= stops[stops.count - 1].position {
            return stops[stops.count - 1].color
        }

        for i in 0..<(stops.count - 1) {
            let stop1 = stops[i]
            let stop2 = stops[i + 1]

            if t >= stop1.position && t <= stop2.position {
                let range = stop2.position - stop1.position
                guard range > 0 else { return stop1.color }

                let localT = (t - stop1.position) / range
                return stop1.color.lerp(to: stop2.color, t: localT)
            }
        }

        return stops[stops.count - 1].color
    }

    /// Samples multiple colors from the gradient.
    public func sample(count: Int) -> [RGBColor] {
        guard count > 0 else { return [] }

        return (0..<count).map { i in
            let t = Double(i) / Double(max(count - 1, 1))
            return sample(at: t)
        }
    }

    /// Creates a palette from this gradient.
    public func palette(colorCount: Int = 10) -> Palette {
        Palette(colors: sample(count: colorCount))
    }

    /// Returns a reversed gradient.
    public func reversed() -> Gradient {
        let reversedStops = stops.map { stop in
            Stop(color: stop.color, position: 1.0 - stop.position)
        }
        return Gradient(stops: reversedStops)
    }
}

// MARK: - Presets

extension Gradient {
    /// Linear gradient from black to white.
    public static let grayscale = Gradient(colors: [.black, .white])

    /// Rainbow gradient.
    public static let rainbow = Gradient(colors: [
        .red,
        .orange,
        .yellow,
        .green,
        .cyan,
        .blue,
        .purple,
        .magenta
    ])

    /// Sunrise gradient.
    public static let sunrise = Gradient(colors: [
        RGBColor(red: 0.1, green: 0.1, blue: 0.3),
        RGBColor(red: 0.8, green: 0.2, blue: 0.4),
        RGBColor(red: 1.0, green: 0.5, blue: 0.2),
        RGBColor(red: 1.0, green: 0.9, blue: 0.6)
    ])

    /// Sunset gradient.
    public static let sunset = Gradient(colors: [
        RGBColor(red: 1.0, green: 0.9, blue: 0.6),
        RGBColor(red: 1.0, green: 0.5, blue: 0.2),
        RGBColor(red: 0.8, green: 0.2, blue: 0.4),
        RGBColor(red: 0.1, green: 0.1, blue: 0.3)
    ])

    /// Ocean gradient.
    public static let ocean = Gradient(colors: [
        RGBColor(red: 0.0, green: 0.1, blue: 0.3),
        RGBColor(red: 0.0, green: 0.3, blue: 0.6),
        RGBColor(red: 0.0, green: 0.6, blue: 0.8),
        RGBColor(red: 0.5, green: 0.9, blue: 1.0)
    ])

    /// Fire gradient.
    public static let fire = Gradient(colors: [
        .black,
        RGBColor(red: 0.5, green: 0.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.0, blue: 0.0),
        RGBColor(red: 1.0, green: 0.5, blue: 0.0),
        RGBColor(red: 1.0, green: 1.0, blue: 0.0),
        .white
    ])

    /// Ice gradient.
    public static let ice = Gradient(colors: [
        RGBColor(red: 0.0, green: 0.1, blue: 0.3),
        RGBColor(red: 0.3, green: 0.5, blue: 0.8),
        RGBColor(red: 0.6, green: 0.8, blue: 1.0),
        .white
    ])

    /// Forest gradient.
    public static let forest = Gradient(colors: [
        RGBColor(red: 0.1, green: 0.2, blue: 0.1),
        RGBColor(red: 0.2, green: 0.5, blue: 0.2),
        RGBColor(red: 0.5, green: 0.8, blue: 0.3),
        RGBColor(red: 0.7, green: 1.0, blue: 0.5)
    ])

    /// Lavender gradient.
    public static let lavender = Gradient(colors: [
        RGBColor(red: 0.3, green: 0.2, blue: 0.5),
        RGBColor(red: 0.6, green: 0.4, blue: 0.8),
        RGBColor(red: 0.8, green: 0.7, blue: 1.0),
        .white
    ])

    /// Gold gradient.
    public static let gold = Gradient(colors: [
        RGBColor(red: 0.3, green: 0.2, blue: 0.0),
        RGBColor(red: 0.8, green: 0.6, blue: 0.1),
        RGBColor(red: 1.0, green: 0.9, blue: 0.3),
        RGBColor(red: 1.0, green: 1.0, blue: 0.8)
    ])

    /// Copper gradient.
    public static let copper = Gradient(colors: [
        RGBColor(red: 0.2, green: 0.1, blue: 0.0),
        RGBColor(red: 0.7, green: 0.3, blue: 0.1),
        RGBColor(red: 0.9, green: 0.6, blue: 0.3),
        RGBColor(red: 1.0, green: 0.9, blue: 0.7)
    ])

    /// Viridis gradient (perceptually uniform, colorblind-friendly).
    public static let viridis = Gradient(colors: [
        RGBColor(red: 0.267, green: 0.005, blue: 0.329),
        RGBColor(red: 0.283, green: 0.141, blue: 0.458),
        RGBColor(red: 0.254, green: 0.265, blue: 0.530),
        RGBColor(red: 0.207, green: 0.371, blue: 0.553),
        RGBColor(red: 0.164, green: 0.471, blue: 0.558),
        RGBColor(red: 0.128, green: 0.566, blue: 0.551),
        RGBColor(red: 0.135, green: 0.658, blue: 0.518),
        RGBColor(red: 0.267, green: 0.749, blue: 0.441),
        RGBColor(red: 0.478, green: 0.821, blue: 0.318),
        RGBColor(red: 0.741, green: 0.873, blue: 0.150),
        RGBColor(red: 0.993, green: 0.906, blue: 0.144)
    ])

    /// Plasma gradient (perceptually uniform, colorblind-friendly).
    public static let plasma = Gradient(colors: [
        RGBColor(red: 0.050, green: 0.030, blue: 0.529),
        RGBColor(red: 0.280, green: 0.013, blue: 0.602),
        RGBColor(red: 0.478, green: 0.003, blue: 0.658),
        RGBColor(red: 0.647, green: 0.039, blue: 0.656),
        RGBColor(red: 0.785, green: 0.155, blue: 0.593),
        RGBColor(red: 0.883, green: 0.301, blue: 0.490),
        RGBColor(red: 0.949, green: 0.457, blue: 0.372),
        RGBColor(red: 0.985, green: 0.625, blue: 0.253),
        RGBColor(red: 0.988, green: 0.809, blue: 0.145),
        RGBColor(red: 0.940, green: 0.975, blue: 0.131)
    ])
}

// MARK: - Helper

extension Double {
    fileprivate func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
