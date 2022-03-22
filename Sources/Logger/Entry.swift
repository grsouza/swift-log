import Foundation

extension Logger {
    /// Entry is a logged object that can be sent to a destination, it contains helpful informations for identifying when and where the log entry happened.
    public struct Entry {
        public let date: Date
        public let level: Logger.Level
        public let error: Error?
        public let message: String?
        public let function: String
        public let file: String
        public let line: UInt
        public let context: [String: String]?
        public let system: String

        /// Subsystem is the module where the log happened.
        public let subsystem: String
    }
}
