import UIKit
import CocoaLumberjack



extension Date {

    static func ISO8601StringFromDate(_ date: Date) -> String {
        let dateFormatter = ISO8601Formatter
        return dateFormatter.string(from: date)
    }

    static func dateFromISO8601String(_ string: String) -> Date? {
        let dateFormatter = ISO8601Formatter
        return dateFormatter.date(from: string)
    }

    // log form API
    static func logFormStringFromDate(_ date: Date) -> String {
        let dateFormatter = yearMonthDayFormatter
        return dateFormatter.string(from: date)
    }

    // log form API
    static func dateFromLogFormString(_ string: String) -> Date? {
        let dateFormatter = yearMonthDayFormatter
        return dateFormatter.date(from: string)
    }

    // Good for saving file names.
    static func shortISO8601FileStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmm"        // eg. 20201520T2139

        return dateFormatter.string(from: date)
    }

    static func local24hrFormatISO8601StringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"  // eg. 2020-05-16T15:31:22

        return dateFormatter.string(from: date)
    }

    // Date to milliseconds and back to date in Swift.
    // https://stackoverflow.com/a/46294917/7599
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }

    // MARK: -

    static var ISO8601Formatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }

    static var yearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"     // eg. 2020-05-27
        return formatter
    }

    static var monthDayYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }

    static var fullMonthDayYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }

    static var shortMonthTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm a"
        return formatter
    }

    static var fullMonthTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, hh:mm a"
        return formatter
    }

    static var fullMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }

    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter
    }

}


// MARK: -

private let YearKey = "{year}"
private let MonthKey = "{month}"
private let WeekKey = "{week}"
private let DayKey = "{day}"
private let HourKey = "{hour}"
private let MinuteKey = "{minute}"
private let SecondKey = "{second}"

extension Date {

    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }

//    func isTheSameDay(withDate date: Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.component(.year, from: self) == calendar.component(.year, from: date) &&
//            calendar.component(.month, from: self) == calendar.component(.month, from: date) &&
//            calendar.component(.day, from: self) == calendar.component(.day, from: date)
//    }

    func next(_ weekday: Weekday,
              includingTheDate: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)

        if includingTheDate &&
            calendar.component(.weekday, from: self) == weekday.rawValue {
            return self
        }

        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: .forward)!
    }

    func previous(_ weekday: Weekday,
                  includingTheDate: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)

        if includingTheDate &&
            calendar.component(.weekday, from: self) == weekday.rawValue {
            return self
        }

        return calendar.nextDate(after: self,
                                 matching: components,
                                 matchingPolicy: .nextTime,
                                 direction: .backward)!
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }

    var dateStringHumanFriendly: String {
        return Date.fullMonthDayYearFormatter.string(from: self)
    }

    var dateStringWithDayOfWeekHumanFriendly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: self)
    }

    var dateTimeStringHumanFriendly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a, MMMM d, yyyy"
        return formatter.string(from: self)
    }
}
