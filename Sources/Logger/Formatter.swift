import CustomDump
import Foundation

extension Logger {
    public struct Formatter {
        public var format: (Logger.Entry) -> String

        public init(format: @escaping (Logger.Entry) -> String) {
            self.format = format
        }
    }
}

let dateFormatter = ISO8601DateFormatter()

extension Logger.Formatter {
    /// Default formatter used for formatting a ``Logger.Entry`` into a friendly string, for writing to the console or sending it to a backend service.
    public static let `default` = Logger.Formatter { entry in
        let dateString = dateFormatter.string(from: entry.date)
        let contextString = formatContext(entry.context)

        var messageOutput = ""
        if let message = entry.message {
            messageOutput = message
        } else {
            customDump(entry.error, to: &messageOutput)
        }

        let fileNameWithoutExtension = entry.file.components(separatedBy: ".").first ?? entry.file
        let formattedMessage =
            "\(dateString) [\(entry.level.description)][\(entry.system)\(entry.subsystem != entry.system ? ".\(entry.subsystem)" : "")] \(fileNameWithoutExtension).\(entry.function):\(entry.line) | \(messageOutput) | \(contextString)"
        return formattedMessage
    }
}

private func formatContext(_ context: [String: String]?) -> String {
    guard let context = context else { return "nil" }
    var output = ""
    customDump(context, to: &output)
    return output
}
