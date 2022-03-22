import XCTest
@testable import Logger

final class LoggerTests: XCTestCase {
    func testLogEntry() {
        let currentDate = Date()
        Logger.dateProvider = { currentDate }

        let mockDestination = Logger.Destination { entry in
            XCTAssertEqual(entry.date, currentDate)
            XCTAssertEqual(entry.level, .debug)
            XCTAssertNil(entry.error)
            XCTAssertEqual(entry.message, "just a debug message")
            XCTAssertEqual(entry.function, "testLogEntry()")
            XCTAssertEqual(entry.file, "LoggerTests/LoggerTests.swift")
            XCTAssertEqual(entry.line, 23)
            XCTAssertEqual(entry.context, ["isTesting": "true"])
            XCTAssertEqual(entry.system, "dev.grds.swift-log.tests")
            XCTAssertEqual(entry.subsystem, "LoggerTests")
        }

        let logger = Logger(
            system: "dev.grds.swift-log.tests",
            destinations: [mockDestination]
        )
        logger.debug("just a debug message", line: 23, context: ["isTesting": "true"])
    }
}
