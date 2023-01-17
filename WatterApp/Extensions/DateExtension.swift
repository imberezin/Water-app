//
//  DateExtension.swift
//  ChitatApp
//
//  Created by IsraelBerezin on 16/11/2022.
//

import Foundation

extension Date{
    
    func getHebrowDate(dateFormat:String = "EEEE d MMMM yyyy")->String{
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .hebrew)
        
        formatter.locale = Locale(identifier: "he") // <- this
        formatter.dateStyle = .full                // <- and this
        
        formatter.dateFormat = dateFormat  // after dateStyle
        
        return (formatter.string(from: self)) // כ״ט
        
    }
    
    func getEnHebrowDate(dateFormat:String = "EEEE d MMMM yyyy")->String{
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .hebrew)
        
        formatter.locale = Locale(identifier: "en") // <- this
        formatter.dateStyle = .full                // <- and this
        
        formatter.dateFormat = dateFormat  // after dateStyle
        
        return (formatter.string(from: self)) // כ״ט
        
    }
    
    func getGregorianDate(dateFormat:String = "EEEE d MMMM yyyy")->String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        
        formatter.locale = Locale(identifier: "en") // <- this
        formatter.dateStyle = .full                // <- and this
        
        formatter.dateFormat = dateFormat  // after dateStyle
        
        return (formatter.string(from: self)) // כ״ט

    }
    
    func converHebrowDateToGregoriaDate()->Date?{
        
        let gregorian = Calendar(identifier: .gregorian)
        
        let components = gregorian.dateComponents([.year, .month, .day], from: self)
                
//        print("\(String(describing: components.year)) - \(String(describing: components.month)) - \(String(describing: components.day))")

        return gregorian.date(from: components)!
    }

    func convertGregorianDateToHebrowDate() -> Date?{
        
        let hebrewCalendar = Calendar(identifier: .hebrew)

        let components = hebrewCalendar.dateComponents([.year, .month, .day], from: self)
                
//        print("\(String(describing: components.year)) - \(String(describing: components.month)) - \(String(describing: components.day))")

        return hebrewCalendar.date(from: components)!
    }

    func daysAfter(number: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: number, to: self)!
    }

    func daysBefore(number: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -number, to: self)!
    }
    
    func dayNumberInTheWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    

    func getHebrewYear() -> Int{
        let hebrewCalendar = Calendar(identifier: .hebrew)
        let year = hebrewCalendar.component(.year, from: self)
        return year

    }
    
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func endOfWeek(using calendar: Calendar = .gregorian) -> Date {
        let start = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
        return start.daysAfter(number: 6)
    }

    func getPreviousWeekStartDay(from date:Date) -> Date{
        let startOfCurrentWeek = date.startOfWeek()
        let startOfPreviuseWeek = startOfCurrentWeek.daysBefore(number: 7)
        return startOfPreviuseWeek.startOfDay
    }

    func getNextWeekStartDay(from date:Date) -> Date{
        let startOfCurrentWeek = date.startOfWeek()
        let startOfPreviuseWeek = startOfCurrentWeek.daysAfter(number: 7)
        return startOfPreviuseWeek.startOfDay
    }

    func toString (_ format:String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
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

        
//    // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
//    print(Date().dayNumberOfWeek()!) // 4

}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}


extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
    
    var currentWeek: [WeekDay]{
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start
        else {return []}
        var week: [WeekDay] = []
        for index in 0..<7{
            if let day = self.date(byAdding: .day, value: index, to: firstWeekDay){
                let weekDaySymbol: String =  day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day,  isToday: isToday))
            }
        }
        return week
    }
}



extension DateComponents {
   static func triggerFor(hour: Int, minute: Int) -> DateComponents {
      var component = DateComponents()
      component.calendar = Calendar.current
      component.hour = hour
      component.minute = minute
      // component.weekday = Date().dayNumberInTheWeek()
//       print("component = \(component)")
      return component
   }
}

struct WeekDay: Identifiable{
    var id: UUID = .init()
    var string: String
    var date: Date
    var isToday: Bool = false
}
