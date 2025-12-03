import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

/// Exports SwiftUI views to image formats.
@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
public struct ImageExporter {
    /// Supported image formats.
    public enum Format: Sendable {
        case png
        case jpeg(quality: CGFloat)
        case tiff
    }

    /// Errors that can occur during export.
    public enum ExportError: Error, Sendable {
        case renderingFailed
        case encodingFailed
        case unsupportedPlatform
        case writeFailed
    }

    /**
     Exports a SwiftUI view to image data.
     - Parameters:
       - view: The view to export.
       - size: The size of the output image.
       - scale: The scale factor (default 2.0 for retina).
       - format: The image format.
     - Returns: The encoded image data.
     */
    @MainActor
    public static func export<V: View>(
        _ view: V,
        size: CGSize,
        scale: CGFloat = 2.0,
        format: Format = .png
    ) throws -> Data {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = scale

        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        guard let nsImage = renderer.nsImage else {
            throw ExportError.renderingFailed
        }

        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            throw ExportError.encodingFailed
        }

        switch format {
        case .png:
            guard let data = bitmap.representation(using: .png, properties: [:]) else {
                throw ExportError.encodingFailed
            }
            return data

        case .jpeg(let quality):
            guard let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: quality]) else {
                throw ExportError.encodingFailed
            }
            return data

        case .tiff:
            return tiffData
        }

        #elseif canImport(UIKit)
        guard let uiImage = renderer.uiImage else {
            throw ExportError.renderingFailed
        }

        switch format {
        case .png:
            guard let data = uiImage.pngData() else {
                throw ExportError.encodingFailed
            }
            return data

        case .jpeg(let quality):
            guard let data = uiImage.jpegData(compressionQuality: quality) else {
                throw ExportError.encodingFailed
            }
            return data

        case .tiff:
            throw ExportError.unsupportedPlatform
        }

        #else
        throw ExportError.unsupportedPlatform
        #endif
    }

    /**
     Exports a SwiftUI view to a file.
     - Parameters:
       - view: The view to export.
       - url: The destination URL.
       - size: The size of the output image.
       - scale: The scale factor.
       - format: The image format.
     */
    @MainActor
    public static func export<V: View>(
        _ view: V,
        to url: URL,
        size: CGSize,
        scale: CGFloat = 2.0,
        format: Format = .png
    ) throws {
        let data = try export(view, size: size, scale: scale, format: format)

        do {
            try data.write(to: url)
        } catch {
            throw ExportError.writeFailed
        }
    }
}
