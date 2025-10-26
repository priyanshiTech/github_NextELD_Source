import Foundation

extension String {
    /// Convert `yyyy-MM-dd HH:mm:ss` string to Date
    func asDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self)
    }
}
