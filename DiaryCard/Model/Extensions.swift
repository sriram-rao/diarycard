import os.log
import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String? {
    func isNilOrWhiteSpace() -> Bool {
        guard let self = self else {
            return true 
        }
        return self.isEmptyOrWhitespace()
    }
}

extension Logger {
    static let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.srao.diarycard", category: "MyApp")
}
