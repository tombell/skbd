public extension StringProtocol {
    subscript(_ offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: Swift.max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: Swift.min(count, range.upperBound))

        return String(self[start ..< end])
    }
}
