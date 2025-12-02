import Foundation

/// Errors that can occur in the Art framework.
public enum ArtError: Error, Sendable, CustomStringConvertible {
    case invalidInput(String)
    case invalidRange(String)
    case invalidColor(String)
    case invalidConfiguration(String)
    case computationFailed(String)
    case notImplemented(String)

    public var description: String {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .invalidRange(let message):
            return "Invalid range: \(message)"
        case .invalidColor(let message):
            return "Invalid color: \(message)"
        case .invalidConfiguration(let message):
            return "Invalid configuration: \(message)"
        case .computationFailed(let message):
            return "Computation failed: \(message)"
        case .notImplemented(let message):
            return "Not implemented: \(message)"
        }
    }
}
