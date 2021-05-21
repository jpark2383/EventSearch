//
//  DateFormatter.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation

class DateFormatterHelper: DateFormatter {
    static let readableDateFormat = "E, MMM d, YYYY"
    
    convenience init(dateFormat: String, timeZoneId: String? = nil) {
        self.init()
        
        // Use our custom AM/PM symbols
        amSymbol = "am"
        pmSymbol = "pm"
        
        self.dateFormat = dateFormat
        if let timeZone = timeZoneId {
            self.timeZone = TimeZone(identifier: timeZone)
        }
    }
    
    static func formatDate(date: String, timeZone: String) -> String {
        if let formattedDate = DateFormatterHelper(dateFormat: "yyyy-MM-dd'T'HH:mm:ss", timeZoneId: timeZone).date(from: date) {
            return DateFormatterHelper(dateFormat: DateFormatterHelper.readableDateFormat, timeZoneId: timeZone).string(from: formattedDate)
        }
        return ""
    }
}
