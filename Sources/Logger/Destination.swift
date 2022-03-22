import Foundation

extension Logger {
    public struct Destination {
        public var send: (Logger.Entry) -> Void

        public init(send: @escaping (Logger.Entry) -> Void) {
            self.send = send
        }
    }
}

extension Logger.Destination {
    /// Writes a log entry to the console using a formatter only in debug builds.
    public static func console(using formatter: Logger.Formatter = .default) -> Logger.Destination {
        Logger.Destination { entry in
            #if DEBUG
            print(formatter.format(entry))
            #endif
        }
    }
}
