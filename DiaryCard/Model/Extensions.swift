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
