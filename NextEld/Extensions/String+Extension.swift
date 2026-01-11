import Foundation
import SwiftUI

extension String {
    /// Convert `yyyy-MM-dd HH:mm:ss` string to Date
    func asDate(format: DateFormatterConstants = .defaultDateTime) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self)
    }
    
    func localised() -> LocalizedStringKey {
        return LocalizedStringKey(self)
    }
    


    
    func asTimeInterval() -> TimeInterval {
        let isNegative = self.hasPrefix("-")
        let cleanString = isNegative ? String(self.dropFirst()) : self
        
        let parts = cleanString.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 3 else { return 0 }
        let hours = parts[0]
        let minutes = parts[1]
        let seconds = parts[2]
        
        let timeInterval = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        return isNegative ? -timeInterval : timeInterval
    }
    

}



