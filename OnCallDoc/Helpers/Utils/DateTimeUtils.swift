import Foundation
class DateTimeUtils: NSObject{
    static let yyyymmddThhmm                   = "yyyy-MM-dd'T'hh:mm"
    static let MMM                             = "MMM"
    static let ddMMM                           = "dd MMM"
    static let dd                              = "dd"
    static let EEEE                            = "EEEE"
    static let EEE                             = "EEE"
    static let MMMdd                           = "MMM dd"
    static let mmdd                            = "MM/dd"
    static let mmddyyyy                        = "MM/dd/yyyy"
    static let mm_dd_yyyy                      = "MM-dd-yyyy"
    static let mm_dd_yyyy_hh_mm                = "MM-dd-yyyy hh:mm a"
    static let ddmmyyyy                        = "dd/MM/yyyy"
    static let ddmmyyyyhhmma                   = "dd/MM/yyyy hh:mm a"
    static let ddmmyyhhmma                     = "dd MMM yyyy hh:mm a"

    static let ddmmyyyyhhmmss                  = "dd/MM/yyyy hh:mm:ss a"
    static let mmddyyyyhhmmssa                 = "MM/dd/yyyy hh:mm:ss a"
    static let mmddyyyyhhmma                   = "MM/dd/yyyy hh:mm a"
    static let ddmmmyyyy                       = "dd MMM yyyy"
    static let dd_MMMM_yyyy                      = "dd-MMMM-yyyy"

    static let hhmmss                          = "hh:mm:ss"
    static let hhmma                           = "hh:mm a"
    static let hhmmssa                         = "hh:mm:ss a"
    static let yyyyMMdd                        = "yyyy-MM-dd"
    static let yyyymmddThhmmss                 = "yyyy-MM-dd'T'hh:mm:ss"
    static let yyyymmddTHHmmss                 = "yyyy-MM-dd'T'HH:mm:ss"
    static let yyyyMMddTHHmmssSSS_Z            = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let yyyyMMddTHHmmssSSS              = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let ddmmmyyyyHHmm                   = "dd MMM yyyy HH:mm"
    static let mmm_dd_yyyy                     = "MMM dd, yyyy"
    static let dd_MM_yyyy                      = "dd-MM-yyyy"
    static let dd_MMM_yyyy_HH_mm_a             = "dd MMM yyyy hh:mm a"
    
    static let firstWeekDay                    = "Mon"
    
    static let TZ_UTC = TimeZone.init(abbreviation: "UTC")!
    static let TZ_DEFAULT = TimeZone.current
    
    class func getDay(from date : String, format : String, timeZone:TimeZone = TZ_DEFAULT) -> String{
        let date = DateTimeUtils.stringToDate(date: date, inFormat: format, timeZone: timeZone)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeUtils.EEE
        return dateFormatter.string(from: date)
    }
    
    class func dateUTCToStringLocal(date: Date,toFormat: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    class func dateToString(date: Date,toFormat: String,timeZone:TimeZone = TZ_DEFAULT, locale : String = "")-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = timeZone
        if locale == "current"{
            dateFormatter.locale = Locale.current
        }else if locale != ""{
            dateFormatter.locale = Locale(identifier: locale)
        }
        return dateFormatter.string(from: date)
    }
    
    class func dateToStringLocal(date: Date,toFormat: String,timeZone:TimeZone = TZ_DEFAULT)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    class func localStringToUTCDate(date: String,inFormat: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        return dateFormatter.date(from: date) ?? Date()
    }
    class func stringToDate(date: String,inFormat: String,timeZone:TimeZone = TZ_DEFAULT, formatterLocale : String = "")-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        if formatterLocale == "current"{
            dateFormatter.locale =  Locale(identifier: Locale.preferredLanguages.first ?? "en_US_POSIX")//Locale.current
        }else if formatterLocale != ""{
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale
        }
       
        dateFormatter.timeZone = timeZone
        debugPrint(date)
       
        if dateFormatter.date(from: date)  == nil
        {
            if inFormat == DateTimeUtils.yyyyMMddTHHmmssSSS{
                return stringToDate(date: date, inFormat: DateTimeUtils.yyyymmddTHHmmss)
            }else  if inFormat == DateTimeUtils.yyyymmddTHHmmss{
                return stringToDate(date: date, inFormat: DateTimeUtils.yyyyMMddTHHmmssSSS_Z )
            }else if inFormat == yyyyMMddTHHmmssSSS_Z{
                return stringToDate(date: date, inFormat: DateTimeUtils.yyyyMMddTHHmmssSSS )
            }
        }
        return dateFormatter.date(from: date) ?? Date()
    }
    
    class func dateStringToDateString(dateString: String, inFormat: String, toFormat: String,timeZone:TimeZone = TZ_DEFAULT)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        dateFormatter.timeZone = timeZone
        let date = dateFormatter.date(from: dateString)
        let dtFormatter = DateFormatter()
        dtFormatter.timeZone = timeZone
        dtFormatter.dateFormat = toFormat
        if date == nil
        {
            if inFormat == DateTimeUtils.yyyyMMddTHHmmssSSS{
                return dateStringToDateString(dateString: dateString, inFormat: DateTimeUtils.yyyymmddTHHmmss, toFormat: toFormat)
            }else if inFormat == DateTimeUtils.yyyymmddTHHmmss{
                return dateStringToDateString(dateString: dateString, inFormat: DateTimeUtils.yyyyMMddTHHmmssSSS, toFormat: toFormat)
            }
            return ""
        }
        return dtFormatter.string(from: date!)
    }
    class func UTCStrToLocalStr(dateString: String, inFormat: String, toFormat: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateString) ?? Date()
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = toFormat
        dtFormatter.timeZone = TimeZone.current
        return dtFormatter.string(from: date)
    }
    class func localToUTC(date: Date)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = yyyymmddThhmmss
        let dateStr = dateFormatter.string(from: date)
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormater.date(from: dateStr) ?? Date()
    }
    
    class func UTCToLocal(date:String, inFormat : String, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateValue = dateFormatter.date(from: date)
        let dateFrmatter = DateFormatter()
        dateFrmatter.dateFormat = toFormat
        dateFrmatter.timeZone = TimeZone.current
        return dateFrmatter.string(from: dateValue ?? Date())
    }
    
    class func convertSecondsToHrMinuteSec(seconds:Double) -> String{
             let formatter = DateComponentsFormatter()
             formatter.allowedUnits = [.hour, .minute, .second]
             formatter.unitsStyle = .abbreviated

             let formattedString = formatter.string(from: TimeInterval(seconds))!
             return formattedString
         }
    
}
