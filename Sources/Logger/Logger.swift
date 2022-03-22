import Foundation

/// Logger
///
/// Usage:
/// ```swift
/// let logger = Logger(system: "dev.grds.app", destinations: [.console(), .myCustomDestination])
/// ```
public struct Logger {
    public let system: String
    public let destinations: [Destination]
    public let formatter: Formatter

    public enum Level: Int, Codable {
        case verbose
        case debug
        case info
        case warning
        case error

        public var description: String {
            switch self {
            case .verbose: return "VERBOSE"
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            }
        }
    }

    public init(system: String, destinations: [Destination], formatter: Formatter = .default) {
        self.system = system
        self.destinations = destinations
        self.formatter = formatter
    }

    internal static var dateProvider: () -> Date = Date.init
}

extension Logger {
    private func log(level: Level, error: Error?, msg: String?, function: StaticString, file: StaticString, line: UInt, context: [String: String]?) {
        let message = Entry(date: Logger.dateProvider(), level: level, error: error, message: msg, function: "\(function)", file: "\(file)", line: line, context: context, system: system, subsystem: "\(file)".components(separatedBy: "/").first ?? system)

        destinations.forEach {
            $0.send(message)
        }
    }

    public func verbose(_ msg: String, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line, context: [String: String]? = nil) {
        log(level: .verbose, error: nil, msg: msg, function: function, file: file, line: line, context: context)
    }

    public func debug(_ msg: String, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line, context: [String: String]? = nil) {
        log(level: .debug, error: nil, msg: msg, function: function, file: file, line: line, context: context)
    }

    public func info(_ msg: String, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line, context: [String: String]? = nil) {
        log(level: .info, error: nil, msg: msg, function: function, file: file, line: line, context: context)
    }

    public func warning(_ msg: String, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line, context: [String: String]? = nil) {
        log(level: .warning, error: nil, msg: msg, function: function, file: file, line: line, context: context)
    }

    public func error(_ error: Error, function: StaticString = #function, file: StaticString = #fileID, line: UInt = #line, context: [String: String]? = nil) {
        log(level: .error, error: error, msg: nil, function: function, file: file, line: line, context: context)
    }
}

extension Logger {
    /// A dummy logger used for testing purpose only.
    public static var testing: Logger {
        #if RELEASE
        #error("Logger.testing should not be used on RELEASE mode.")
        #endif
        return Logger(system: "markets.alpaca.dummy", destinations: [.console()])
    }
}
