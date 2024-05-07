//
//  TimeUtils.swift
//  NDVIP
//
//  Created by Ratnesh Swarnkar on 6/3/19.
//  Copyright © 2019 Ratnesh Swarkar. All rights reserved.
//

import UIKit

enum DateFormats {
  static let DD   =   "dd"
  static let DD_MMM_YYYY = "dd MMM yyyy"
  static let DD_MMM = "dd MMM"
  static let MM_DD_YYYY = "MM-dd-YYYY"
  static let YYYY_MM_DD_T_HH_MM_SS_SSSZ   =   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
  static let YYYY_MM_DD_hh_MM_SS   =   "yyyy-MM-dd HH:mm:ss"
  static let YYYY_MM_DD_T_HH_MM_SS_SSS    =   "yyyy-MM-dd'T'HH:mm:ss.SSS"
  static let MMMM_yyyy    =   "MMMM yyyy"
  static let YYYY    =   "yyyy"
  static let MM   =   "MM"
  static let YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
  static let YYYY_MM_DD_T_HH_MM_SS = "yyyy-MM-dd'T'HH:mm:ss"
  static let EEEE_MMM_D_YYYY    =   "EEEE, MMM d, yyyy"
  static let HH_MM_A   =   "h:mm a"
  static let mmddyyyy = "MM/dd/yyyy"
  static let ddmmyyyy = "dd/MM/yyyy"
  static let ddmmyyyy_HH_MM_A = "dd/MM/yyyy h:mm a"
  static let HH_MM_SS = "HH:mm:ss"
  static let HH_MM = "HH:mm"
  static let MMMM = "MMMM"
}

class TimeUtils: NSObject {
  
  // Mark- Convert date from string
  class func dateFromString(_ strDate:String?, with format:String) -> Date? {
    guard let st = strDate else {
      return Date()
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = .current
    let result = dateFormatter.date(from: st)
    return result
  }
  
  // Mark- Convert string form date
  class func stringFromDate(_ date:Date?, with format:String) -> String {
    guard let dt = date else {
      return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: dt)
  }
  
  // Mark-Convert date from Formates
  class func convertdateFormater(_ strDate:String?,fromFormat:String, toFormat:String) -> String {
    guard let st = strDate else {
      return ""
    }
    let outFormatter = DateFormatter()
    outFormatter.dateFormat = fromFormat
    //        outFormatter.timeZone   = TimeZone(abbreviation: "UTC")
    if let date = outFormatter.date(from: st) {
      return self.stringFromDate(date, with: toFormat)
    }
    return ""
  }
  
  class func convertDateFormat(strDate: String,fromFormat:String, toFormat:String) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    let date = dateFormatter.date(from: strDate)
    dateFormatter.dateFormat = toFormat
    return  dateFormatter.string(from: date ?? Date())
  }
  
  class func getMinimumDateOfMonth(date: Date) -> Date? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)
  }
  
  class func getMaximumDateOfMonth(date: Date) -> Date? {
    let calendar = Calendar.current
    var component = DateComponents()
    component.day = -1
    component.month = 1
    return calendar.date(byAdding: component, to: date)
  }
  
  // Mark- Get time diff between dates
  class func timeIntervalBetweenDates(startDate strStartDate:String?, enddate strEndDate:String?, with format:String)->TimeInterval {
    let sDate = self.dateFromString(strStartDate, with: format)
    let edate = self.dateFromString(strEndDate, with: format)
    return edate!.timeIntervalSince(sDate!)
  }
  
  class func convertMilisecondToDate(strMiliseconds : String?, toFormat : String) -> String{
    if let strMiliseconds = strMiliseconds,let time = Double(strMiliseconds) {
      let date = Date(timeIntervalSince1970: TimeInterval(time/1000.0))
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = toFormat
      return dateFormatter.string(from: date)
    }
    return ""
  }
  
  
  class func dateUTCFromString(date: String, format:String) -> Date? {
    let dateFormatter        = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone   = TimeZone(abbreviation: "UTC")
    let newDate           = dateFormatter.date(from: date)
    return newDate ?? Date()
  }
  
  class func localToUTC(date:String, format : String, outputFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = outputFormat
    return dateFormatter.string(from: dt ?? Date())
  }
  
  class func UTCToLocal(date:String, format : String, outputFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = outputFormat
    return dateFormatter.string(from: dt ?? Date())
  }
  
  //date to UTC format
  class func convertDateToServerReadableFormat(date:Date?, format : String) -> String{
    guard let dt = date else {
      return ""
    }
    let dateFormatter        = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone   = TimeZone(abbreviation: "UTC")
    let dateString           = dateFormatter.string(from: dt)
    return dateString
  }
  
  class func getDateFromString(dateString:Date) -> String {
    let locale = NSLocale.current
    let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
    let charset = CharacterSet(charactersIn: "a")
    if formatter.lowercased().rangeOfCharacter(from: charset) != nil {
      // print("yes")
    }else{
      // print("No")
    }
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatterPrint.locale = Locale(identifier: "en_US_POSIX")
    
    let dateStr:String = dateFormatterGet.string(from: dateString)
    var dateConverted:String?
    if let date = dateFormatterGet.date(from: dateStr)  {
      let dateStrConverted:String = dateFormatterPrint.string(from: date)
      if let date1 = dateFormatterPrint.date(from: dateStrConverted)  {
        dateConverted = dateFormatterPrint.string(from: date1)
      }
    }
    if let dateValue = dateConverted  {
      return dateValue
    }
    return ""
  }
  
  class func getDateFetchDataFromString(dateString:String, dateformat: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateformat
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let dateConverted = dateFormatter.date(from: dateString)
    if let dateValue = dateConverted {
      return dateValue
    }
    return Date()
  }
  
  
  //Age Calculation function
  class func getAgeFromDate(date:String, format:String) -> Int? {
    let birthday = self.dateFromString(date, with: format) ?? Date()
    return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year
  }
  
  class func GMTToLocal(date:String, format : String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: dt ?? Date())
      }
    class func LocaleToGMT(date:Date?, format : String) -> String{
      guard let dt = date else {
        return ""
      }
      let dateFormatter        = DateFormatter()
      dateFormatter.dateFormat = format
      dateFormatter.timeZone   = TimeZone(abbreviation: "GMT")
      let dateString           = dateFormatter.string(from: dt)
      return dateString
    }
}



extension Date {
  
  var numberOfDays: Int {
    let calendar = Calendar.current
    let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
    let date = calendar.date(from: dateComponents)!
    let range = calendar.range(of: .day, in: .month, for: date)!
    return range.count
  }
  
  var age: Int {
    return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
  }
  
  var startOfMonth:Date {
    return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
  }
  var endOfMonth:Date {
    return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
  }
  
  var startOfWeek: Date? {
    //        guard let day = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
    //        return Calendar.current.date(byAdding: .day, value: 1, to: day)
    
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.firstWeekday = 1
    gregorian.timeZone = .current
    let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    return gregorian.date(byAdding: .day, value: 1, to: sunday!)!
  }
  
  var endOfWeek: Date? {
    //        guard let day = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
    //        return Calendar.current.date(byAdding: .day, value: 7, to: day)
    
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.firstWeekday = 1
    gregorian.timeZone = .current
    let sunday = gregorian.date(from:
                                  gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    return gregorian.date(byAdding: .day, value: 7, to: sunday!)!
    
  }
  
  //  var startOfPreviousWeek: Date? {
  //      guard let day = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
  //      return Calendar.current.date(byAdding: .day, value: -5, to: day)
  //  }
  
  // Getting first day of the previous week
  var getPreviousWeekEndDay: Date? {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.firstWeekday = 1
    gregorian.timeZone = .current
    let sunday = gregorian.date(from:
                                  gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    return gregorian.date(byAdding: .day, value: -7, to: sunday!)!
  }
  
  // Getting last day of previous week
  var getPreviousWeekStartDay: Date? {
    var gregorian = Calendar(identifier: .gregorian)
    gregorian.timeZone = .current
    gregorian.firstWeekday = 1
    let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
    return gregorian.date(byAdding: .day, value: -1, to: sunday!)!
  }
  
  var startOfQuarter: Date {
    var components = Calendar.current.dateComponents([.month, .year], from: self)
    let newMonth: Int
    switch components.month! {
    case 1,2,3: newMonth = 1
    case 4,5,6: newMonth = 4
    case 7,8,9: newMonth = 7
    case 10,11,12: newMonth = 10
    default: newMonth = 1
    }
    components.month = newMonth
    return Calendar.current.date(from: components)!
  }
  
  var endOfQuarter: Date {
    return Calendar.current.date(byAdding: DateComponents(month: 3, day: -1), to: startOfQuarter)!
  }
  
  var startOfYear: Date {
    var components = Calendar.current.dateComponents([.month, .year], from: self)
    components.month = 1
    return Calendar.current.date(from: components)!
  }
  
  var endOfYear: Date {
    return Calendar.current.date(byAdding: DateComponents(month: 12, day: -1), to: startOfYear)!
  }
  
  var unixTimeStamp:String {
    return "\(self.timeIntervalSince1970 * 1000)"
  }
  
  func toString(with format : String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    let dateString = formatter.string(from: self)
    return dateString
  }
  
  func isBetween(from startDate: Date,to endDate: Date) -> Bool {
    let result = (min(startDate, endDate) ... max(startDate, endDate)).contains(self)
    return result
  }
  
  func isBetweenDates(beginDate: Date, endDate: Date) -> Bool {
    if self.compare(beginDate) == .orderedAscending {
      return false
    }
    if self.compare(endDate) == .orderedDescending {
      return false
    }
    return true
  }
  
  // Convert local time to UTC (or GMT)
  func toGlobalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
  
  // Convert UTC (or GMT) to local time
  func toLocalTime() -> Date {
    let timezone = TimeZone.current
    let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
    return Date(timeInterval: seconds, since: self)
  }
  
}

extension TimeInterval {
  private var milliseconds: Int {
    return Int((truncatingRemainder(dividingBy: 1)) * 1000)
  }
  private var seconds: Int {
    return Int(self) % 60
  }
  private var minutes: Int {
    return (Int(self) / 60 ) % 60
  }
  public var hours: Int {
    return Int(self) / 3600
  }
  var stringTime: String {
    return "\(hours):\(minutes):\(seconds)"
  }
  var doubleTime: Double {
    let stringValue = "\(hours).\(minutes)"
    return NumberFormatter().number(from: stringValue)?.doubleValue ?? 0.0
    //        return Double(stringValue) ?? 0.0
  }
}
