//
//  DateExt.swift
//  BuzzyTap
//
//  Created by Shiwani Thakur on 20/11/20.
//

import Foundation

let MMMddyyyy = "MMM dd, yyyy"
let ddMMMyyyy12h = "dd-MMM-yyyy hh:mm a"
//let YYYY_MM_DD_T_HH_MM_SS_SSS    =   "yyyy-MM-dd'T'HH:mm:ss.SSS"
// let YYYY_MM_DD_T_HH_MM_SS_SSSZ   =   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

extension Date
{
//  var currentDayName: String {
//          let weekday = Calendar.current.component(.weekday, from: Date())
//          switch weekday {
//          case 1:
//             return WeekDayName.Sunday.rawValue
//          case 2:
//            return WeekDayName.Monday.rawValue
//          case 3:
//            return WeekDayName.Tuesday.rawValue
//          case 4:
//            return WeekDayName.Wednesday.rawValue
//          case 5:
//            return WeekDayName.Thursday.rawValue
//          case 6:
//            return WeekDayName.Friday.rawValue
//          case 7:
//            return WeekDayName.Saturday.rawValue
//          default:
//              print("nothng")
//            return "Invalid"
//          }
//      }
  
  func weekPeriod() -> (startDate: Date, endDate: Date) {
      let calendar = Calendar(identifier: .gregorian)
      guard let sundayDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return (startDate: Date(), endDate: Date()) }
      
      if calendar.isDateInToday(sundayDate) {
          let startDate = calendar.date(byAdding: .day, value: -6, to: sundayDate) ?? Date()
          let endDate = sundayDate
          return (startDate: startDate, endDate: endDate)
      }
      
      let startDate = calendar.date(byAdding: .day, value: 1, to: sundayDate) ?? Date()
      let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) ?? Date()
      
      return (startDate: startDate, endDate: endDate)
  }
  
  func convertDateInWeekString() -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EEE"
      return  dateFormatter.string(from: self)
  }
  
  func getTimeAgo() -> String {
    
      let interval = Calendar.current.dateComponents([.year, .month, .day , .hour ,.minute,.second], from: self, to: Date())
     
           if let year = interval.year, year > 0 {
               return year == 1 ? "\(year)" + " " + "year ago" :
                   "\(year)" + " " + "years ago"
           } else if let month = interval.month, month > 0 {
               return month == 1 ? "\(month)" + " " + "month ago" :
                   "\(month)" + " " + "months ago"
           } else if let day = interval.day, day > 0 {
               return day == 1 ? "\(day)" + " " + "day ago" :
                   "\(day)" + " " + "days ago"
           }
           else if let hour = interval.hour, hour > 0 {
               return hour == 1 ? "\(hour)" + " " + "hour ago" :
                   "\(hour)" + " " + "hour ago"
           }
           else if let minutes = interval.minute, minutes > 0 {
               return minutes == 1 ? "\(minutes)" + " " + "minute ago" :
                   "\(minutes)" + " " + "min ago"
           }
           else {
               return "a moment ago"

           }

       }
  
  func convertToUTC(_ format: String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.locale =  Locale.current
       dateFormatter.dateFormat = format
       dateFormatter.timeZone = TimeZone(abbreviation: "UTC")//TimeZone.current
       let time = dateFormatter.string(from: self)
       return time
     }
  
  func convertToDateString() -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  Locale.current
    dateFormatter.dateFormat = MMMddyyyy
    dateFormatter.timeZone = TimeZone.current
    let time = dateFormatter.string(from: self)
    return time
  }
  
  func convertTo(_ format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  Locale.current
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone.current
    let time = dateFormatter.string(from: self)
    return time
  }
  
  var startOfDay: Date?
  {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    components.timeZone = TimeZone(abbreviation: "UTC")
    components.minute = 0
    components.second = 1
    components.hour = 0
    let date = calendar.date(from: components)
    return date
  }
  var endOfDay : Date? {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    components.timeZone = TimeZone(abbreviation: "UTC")
    components.hour = 23
    components.second = 59
    components.minute = 59
    let date = calendar.date(from: components)
    return date
  }
}
