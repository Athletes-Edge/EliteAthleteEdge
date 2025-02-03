//
//  Extensions.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage


class Extensions: NSObject {

}
typealias Rational = (num : Int, den : Int)

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}



enum CustomAppFont: String {
    case Rubik_Black = "Rubik-Black"
    case Rubik_BlackItalic = "Rubik-BlackItalic"
    case Rubik_Bold = "Rubik-Bold"
    case Rubik_BoldItalic = "Rubik-BoldItalic"
    case Rubik_ExtraBold = "Rubik-ExtraBold"
    case Rubik_ExtraBoldItalic = "Rubik-ExtraBoldItalic"
    case Rubik_Italic = "Rubik-Italic"
    case Rubik_Light = "Rubik-Light"
    case Rubik_LightItalic = "Rubik-LightItalic"
    case Rubik_Medium = "Rubik-Medium"
    case Rubik_MediumItalic = "Rubik-MediumItalic"
    case Rubik_Regular = "Rubik-Regular"
    case Rubik_SemiBold = "Rubik-SemiBold"
    case Rubik_SemiBoldItalic = "Rubik-SemiBoldItalic"
}

extension UIFont {
    
    class func getFont(type: CustomAppFont, fontSize: CGFloat) -> UIFont {
        return getCustomFontByName(name: type.rawValue, fontSize: fontSize)
    }
    
    class func getCustomFontByName(name: String, fontSize: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: fontSize) {
            return font
        }
        
        return UIFont.systemFont(ofSize: fontSize)
    }
}


enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
extension String {
    
    func getHoursFromString() -> String{
        
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        inFormatter.locale = Locale(identifier: "fr-CA")
        inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.setLocalizedDateFormatFromTemplate("H:mm:ss")
        inFormatter1.locale = Locale(identifier: "fr-CA")
        inFormatter1.timeZone = TimeZone(abbreviation: "EDT")
        

        let outFormatter = DateFormatter()
        
        outFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        //outFormatter.locale = Locale(identifier: "fr-CA")
        //outFormatter.timeZone = TimeZone(abbreviation: "EDT")
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"
        
        
        if let time = Double.init(self) {
            
            if Date(timeIntervalSince1970: time) != nil{
            
                let date = Date(timeIntervalSince1970: time)
                let out = outFormatter.string(from: date)
                return out
                
            }
            else{
            
                return ""
            }
        }
        else{
            return ""
        }

//        if let date = inFormatter.date(from: self){
//            let out = outFormatter.string(from: date)
//            return out
//        }
//        else if let date = inFormatter1.date(from: self){
//            let out = outFormatter.string(from: date)
//            return out
//        }
//        else{
//            return ""
//        }
        
        
    }
    func getTimeFromString() -> String{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        inFormatter.locale = Locale(identifier: "fr-CA")
        inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.setLocalizedDateFormatFromTemplate("H:mm:ss")
        inFormatter1.locale = Locale(identifier: "fr-CA")
        inFormatter1.timeZone = TimeZone(abbreviation: "EDT")
        

        let outFormatter = DateFormatter()
        
        outFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        outFormatter.locale = Locale(identifier: "fr-CA")
        outFormatter.timeZone = TimeZone(abbreviation: "EDT")
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"
        
        
        

        if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else if let date = inFormatter1.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else{
            return ""
        }
        
        
    }
    func getDateTimeFromString(_ date:String,_ time:String) -> String{
        let inDFormatter = DateFormatter()
        inDFormatter.dateFormat = "yyyy-MM-dd"
        
        let inTFormatter = DateFormatter()
        inTFormatter.dateFormat = "HH:mm:ss"

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd MMM,yyyy hh:mm a"
        
        if let datestr = inDFormatter.date(from: date),let timestr = inTFormatter.date(from: time){
            if let comnine = combineDateWithTime(date: datestr, time: timestr){
               let out = outFormatter.string(from: comnine)
                return out
            }
            else{
                return ""
            }
        }
        else{
            return Date().formattedWithString("dd MMM,yyyy hh:mm a")
        }
        
        
    }
    func getDateTimeFromStringToDate(_ ind:String) -> Date{
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = ind
        inFormatter.calendar = Calendar.current
        inFormatter.timeZone = .current
        inFormatter.locale = .current
        if let date = inFormatter.date(from: self){
            let calender = Calendar.current
            let d = Date()
            
            let d1 = calender.date(bySetting: .month, value: date.getMonth, of: d)
            let d2 = calender.date(bySetting: .day, value: date.day, of: d1!)
            let d3 = calender.date(bySetting: .hour, value: date.hour(), of: d2!)
            let d4 = calender.date(bySetting: .minute, value: date.minute(), of: d3!)
            
            return d4 ?? Date()
        }
        else{
            return Date()
        }
        
        
    }
    func getDateFromStringTimeStampToDate() -> Date{
        return Date(timeIntervalSince1970: TimeInterval(self)!/1000)
    }
    func getDateFromString(_ ind:String,outd: String) -> String{
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = ind
        
        //let inFormatter1 = DateFormatter()
        //inFormatter1.dateFormat = "yyyy-MM-dd"

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = outd

        if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else{
            return ""
        }
        
        
    }
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments) ?? Date()
    }
    func getDateFromString() -> String{
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy-MM-dd"
        
        let inFormatter1 = DateFormatter()
        inFormatter1.dateFormat = "yyyy-MM-dd"

        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "dd MMM"

        if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else{
            return ""
        }
        
        
    }
    func getDateTimeFromString() -> String{
//        var str = self.replacingOccurrences(of: "T", with: " ")
//        //let range =
//        //str.removeSubrange(self.range(of: ".")!)
//        let index = str.lastIndex { (char) -> Bool in
//            return char == "."
//        }
        //str.removeSubrange(Range(uncheckedBounds: (lower: index!, upper: str.endIndex)))
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inFormatter.timeZone = TimeZone(abbreviation: "UTC")
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.dateFormat = "yyyy-MM-dd'T'H:mm:ss.SSSZ"
        inFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        inFormatter1.locale = Locale(identifier: "en_US_POSIX")
        
        let outFormatter = DateFormatter()
        outFormatter.dateFormat = "hh:mm, dd MMMM yyyy"
        //outFormatter.timeZone = .current

        if let date = inFormatter.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else if let date = inFormatter1.date(from: self){
            let out = outFormatter.string(from: date)
            return out
        }
        else{
            return ""
        }
        
        
    }
    func isTimeGreater()->Bool{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        //inFormatter.locale = Locale(identifier: "fr-CA")
        //inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.setLocalizedDateFormatFromTemplate("H:mm:ss")
        inFormatter1.locale = Locale(identifier: "fr-CA")
        inFormatter1.timeZone = TimeZone(abbreviation: "EDT")
        
        let curentDate = Date()
    
        if let time = Double.init(self) {
            if Date(timeIntervalSince1970: time) != nil{
                let date = Date(timeIntervalSince1970: time)
                if date > curentDate{
                    return true
                }
                else{
                    return false
                }
            }
            else{
                return false
            }
        }
        else{
            return false
        }
//        if let date = inFormatter.date(from: self){
//            let datestr = inFormatter.string(from: curentDate)
//            if let finaldate = inFormatter.date(from: datestr){
//                if date > finaldate{
//                    return true
//                }
//                else{
//                    return false
//                }
//            }
//            else{
//                return false
//            }
//
//
//        }
//        else{
//            return false
//        }
    }
    func isTimeLess()->Bool{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        inFormatter.locale = Locale(identifier: "fr-CA")
        inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.setLocalizedDateFormatFromTemplate("H:mm:ss")
        inFormatter1.locale = Locale(identifier: "fr-CA")
        inFormatter1.timeZone = TimeZone(abbreviation: "EDT")
        
        let curentDate = Date()
    
        if let time = Double.init(self) {
            if Date(timeIntervalSince1970: time) != nil{
                let date = Date(timeIntervalSince1970: time)
                if date < curentDate{
                    return true
                }
                else{
                    return false
                }
            }
            else{
                return false
            }
        }
        else{
            return false
        }
        
//        if let date = inFormatter.date(from: self){
//            let datestr = inFormatter.string(from: curentDate)
//            if let finaldate = inFormatter.date(from: datestr){
//                if date < finaldate{
//                    return true
//                }
//                else{
//                    return false
//                }
//            }
//            else{
//                return false
//            }
//
//
//        }
//        else{
//            return false
//        }
    }
    func isTimeEqual()->Bool{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        //inFormatter.locale = Locale(identifier: "fr-CA")
        //inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let inFormatter1 = DateFormatter()
        inFormatter1.setLocalizedDateFormatFromTemplate("H:mm:ss")
        inFormatter1.locale = Locale(identifier: "fr-CA")
        inFormatter1.timeZone = TimeZone(abbreviation: "EDT")
        
        let curentDate = Date()
    
        if let time = Double.init(self) {
            if Date(timeIntervalSince1970: time) != nil{
                let date = Date(timeIntervalSince1970: time)
                if date == curentDate{
                    return true
                }
                else{
                    return false
                }
            }
            else{
                return false
            }
        }
        else{
            return false
        }
//        if let date = inFormatter.date(from: self){
//            let datestr = inFormatter.string(from: curentDate)
//            if let finaldate = inFormatter.date(from: datestr){
//                if date == finaldate{
//                    return true
//                }
//                else{
//                    return false
//                }
//            }
//            else{
//                return false
//            }
//
//
//        }
//        else{
//            return false
//        }
    }
    func getTime()->Date?{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        inFormatter.locale = Locale(identifier: "fr-CA")
        inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        if let time = Double.init(self) {
            if Date(timeIntervalSince1970: time) != nil{
                let date = Date(timeIntervalSince1970: time)
                return date
            }
            else{
                return nil
            }
        }
        else{
            return nil
        }
        
//        if let date = inFormatter.date(from: self){
//            return date
//            }
//            else{
//                return nil
//            }
    }
    func getDistance() -> Double? {
        let val =  Double(self)!
        return val.rounded(.toNearestOrEven)
    }
    func getCurrentTime()->Date?{
        let inFormatter = DateFormatter()
        inFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        inFormatter.locale = Locale(identifier: "fr-CA")
        inFormatter.timeZone = TimeZone(abbreviation: "EDT")
        
        let curentDate = Date()
        let datestr = inFormatter.string(from: curentDate)
        if let finaldate = inFormatter.date(from: datestr){
            return finaldate
        }
        else{
            return nil
        }
    }
    func containsOnlyDigits() -> Bool
    {

        let notDigits = NSCharacterSet.decimalDigits.inverted

        if rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
        {
            return true
        }

        return false
   }
//    func localized() ->String
//    {
//        let currentSelectedLang:String? = LanguageHelper.sharedInstance.getCurrentSelectedLanguage()
//
//        guard let currentLang:String = currentSelectedLang else
//        {
//            fatalError("Current Language cannot be nil")
//        }
//
//        var lang:String = Globals.shared.kApplicationLanguage_English
//        if(currentLang == Globals.shared.kAppCurrentLanguage__Urdu)
//        {
//            lang = Globals.shared.kApplicationLanguage_urdu
//        }
//
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//
    func suffixNumber() -> String {
        
        var num:Double = Double(self)!;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)";
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","B"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
//    func isValidPhone() -> Bool {
//        let phonekit = PhoneNumberKit()
//        do{
//            let val = try phonekit.parse(self)
//            let all = phonekit.allCountries()
//            return true
//        }
//        catch{
//            print("error parsing")
//            return false
//        }
//
//    }
    func isValidPassword() -> Bool{
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range) != nil
        } catch{return false}
    }
    
    
    func isEmail(_ text:String?) -> Bool
    {
        let EMAIL_REGEX = "^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
        return predicate.evaluate(with: text)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).uppercased()
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func monthFullNameToInt() -> Int {
        
        switch self {
        case "January":
            return 1
        case "February":
            return 2
        case "March":
            return 3
        case "April":
            return 4
        case "May":
            return 5
        case "June":
            return 6
        case "July":
            return 7
        case "August":
            return 8
        case "September":
            return 9
        case "October":
            return 10
        case "November":
            return 11
        case "December":
            return 12
        default:
            return 13
        }
    }
    
    func monthFullNameTo() -> String {
        
        switch self {
        case "January":
            return "1"
        case "February":
            return "2"
        case "March":
            return "3"
        case "April":
            return "4"
        case "May":
            return "5"
        case "June":
            return "6"
        case "July":
            return "7"
        case "August":
            return "8"
        case "September":
            return "9"
        case "October":
            return "10"
        case "November":
            return "11"
        case "December":
            return "12"
        default:
            return "13"
        }
    }
    
}

extension URL {
    
    func isEmpty(_ text:String?) -> Bool
    {
        if text == nil {return true}
        
        if text!.isEmpty == true {return true}
        
        //    if text?.lowercaseString == "null" {return true}
        
        return false
        
    }
    
    func isURLValid(_ urlString:String?) -> Bool
    {
        if isEmpty(urlString) {return false}
        
        let url =  URL(string: urlString!)
        if url == nil {return false}
        
        
        let request = URLRequest(url: url!)
        return NSURLConnection.canHandle(request)
        
    }
}

extension Date {
    
    var day:Int {
        get {
            return (Calendar.current as NSCalendar).components([.day], from: self).day!
        }
    }
    
    var weekDay:String {
        get {
            let weekday = (Calendar.current as NSCalendar).components([.weekday], from: self).weekday
            
            switch weekday! {
            case 1:
                return "SUN"
            case 2:
                return "MON"
            case 3:
                return "TUE"
            case 4:
                return "WED"
            case 5:
                return "THU"
            case 6:
                return "FRI"
            case 7:
                return "SAT"
            default:
                return ""
            }
        }
    }
    
    var weekDayIndex:Int {
        get {
            let weekday = (Calendar.current as NSCalendar).components([.weekday], from: self).weekday
            
            switch weekday! {
            case 1:
                return 6
            case 2:
                return 0
            case 3:
                return 1
            case 4:
                return 2
            case 5:
                return 3
            case 6:
                return 4
            case 7:
                return 5
            default:
                return 0
            }
        }
    }
    
    var weekDayWithTwoWords:String {
        get {
            let weekday = (Calendar.current as NSCalendar).components([.weekday], from: self).weekday
            
            switch weekday! {
            case 1:
                return "Su"
            case 2:
                return "Mo"
            case 3:
                return "Tu"
            case 4:
                return "We"
            case 5:
                return "Th"
            case 6:
                return "Fr"
            case 7:
                return "Sa"
            default:
                return ""
            }
        }
    }
    
    var weekDayWithThreeWords:String {
        get {
            let weekday = (Calendar.current as NSCalendar).components([.weekday], from: self).weekday
            
            switch weekday! {
            case 1:
                return "Sun"
            case 2:
                return "Mon"
            case 3:
                return "Tue"
            case 4:
                return "Wed"
            case 5:
                return "Thu"
            case 6:
                return "Fri"
            case 7:
                return "Sat"
            default:
                return ""
            }
        }
    }
    
    var weekFullDay:String {
        get {
            let weekFullDay = (Calendar.current as NSCalendar).components([.weekday], from: self).weekday
            
            switch weekFullDay! {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return ""
            }
        }
    }
    
    var monthThreeWordsName: String {
        get {
            let nameInt = (Calendar.current as NSCalendar).components([.month], from: self).month
            switch nameInt! {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "Mar"
            case 4:
                return "Apr"
            case 5:
                return "May"
            case 6:
                return "Jun"
            case 7:
                return "Jul"
            case 8:
                return "Aug"
            case 9:
                return "Sep"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
                
            default:
                return ""
            }
        }
    }
    
    var monthFullName: String {
        get {
            let nameInt = (Calendar.current as NSCalendar).components([.month], from: self).month
            switch nameInt! {
            case 1:
                return "January"
            case 2:
                return "February"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "June"
            case 7:
                return "July"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "October"
            case 11:
                return "November"
            case 12:
                return "December"
                
            default:
                return ""
            }
        }
    }
    
    var getMonth: Int {
        return (Calendar.current as NSCalendar).components([.month], from: self).month!
    }
    
    var dateDayOfMonth: String? {
        get {
            let dateDay = (Calendar.current as NSCalendar).components([.day], from: self).day!
            return String(describing: dateDay)
        }
    }
    
    var year:Int {
        get {
            return (Calendar.current as NSCalendar).components([.year], from: self).year!
        }
    }
    
    // you can create a read-only computed property to return just the nanoseconds as Int
    var nanosecond: Int { return Calendar.current.component(.nanosecond,  from: self)}
    var milisecond: Double { return Double(self.timeIntervalSince1970 * 1000)}
    var milisecondInt64: Int64 { return Int64(self.timeIntervalSince1970 * 1000)}
    // or an extension function to format your date
    func formattedWith(_ format:String)-> String {
        let formatter = DateFormatter()
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        formatter.timeZone = NSTimeZone.local        // or as local time
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //Replica
    func formattedWithString(_ format:String)-> String {
        let formatter = DateFormatter()
        //formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)  // you can set GMT time
        formatter.timeZone = NSTimeZone.local        // or as local time
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    //12:18 PM
    static func timeStringFromUnixTime(_ unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func dayStringFromTime(_ unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "dd-MMMM"
        return dateFormatter.string(from: date)
    }
    
    //2016-19-18 12:18 PM
    static func timeAndDateFromUnix(_ unixTime:Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "yyyy-dd-MM hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func yearFromUnixTime(_ unixTime:Double) -> Date {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "MM dd yyyy"
        let string = dateFormatter.string(from: date)
        return dateFormatter.date(from: string)!
    }
    
    static func yearStringFromUnixTime(_ unixTime:Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
        //        return dateFormatter.dateFromString(string)!
    }
    
    static func dateFromStrings(_ stringDate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        //        dateFormatter.dateFormat = "hh:mm:ss a"
        //        dateFormatter.dateStyle = .NoStyle
        //        dateFormatter.timeStyle = .ShortStyle
        let date = dateFormatter.date(from: stringDate)
        return date!
    }
    
    static func dateFromStringConvertToString(_ stringDate: String) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat =  "hh:mm a"
        let  newTime =  dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date!)
        return newDate + " " + newTime
    }
    
    //    static func date(withFormat format: String, dateString: String) -> Date? {
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = format
    //        let newDate = dateFormatter.date(from: dateString)
    //        return newDate
    //    }
    
    static func date(withFormat format: String, dateString: String) -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        let newDate1 = dateFormatter.string(from: newDate!)
        return newDate1
    }
    
    static func date(fromString: String) -> Date?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: fromString)
        return newDate
    }
    
    static func date2(fromString: String) -> Date?  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: fromString)
        return newDate
    }
    static func getTodayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: Date())
        return newDate
    }
    static func getTodayTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let newDate = dateFormatter.string(from: Date())
        return newDate
    }
    static func getTodayNameString(str:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: str)
        let strng = newDate!.weekFullDay
        return strng
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: .distantFuture)!
    }
    static func getTommorowDateString() -> String {
        
        var tomorrow:  Date { return Date().dayAfter }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: tomorrow)
        return newDate
    }
    static func getTommorowTimeString() -> String {
        
        var tomorrow:  Date { return Date().dayAfter }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:MM:ss a"
        let newDate = dateFormatter.string(from: tomorrow)
        return newDate
    }
    
    
    //    static func date(withFormat format: String, date: Date) -> Date? {
    //        let dateString = String(describing: date)
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
    //        let newDate = dateFormatter.date(from: dateString)
    //        dateFormatter.dateFormat = format
    //        let newDate1 = dateFormatter.string(from: date)
    //        return newDate1
    //    }
    
    static func date(withFormat format: String, date: Date) -> String  {
        let dateString = String(describing: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = format
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    
    static func dateFromStringConvertToStringInTuple(_ stringDate: String) -> (newDate:String,newTime:String)  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat =  "hh:mm a"
        let  newTime =  dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date!)
        return (newDate,newTime)
    }
    
    static func checkDate(_ date: Date) -> String {
        var returnedDate = ""
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            returnedDate = "Today"
        } else if calendar.isDateInYesterday(date) {
            returnedDate = "Yesterday"
        }
        else if calendar.isDateInTomorrow(date){
            returnedDate = "Tommorow"
        }
        else {
            returnedDate = "None"
        }
        return returnedDate
    }
    
    static func dateFromStringConvertToDate(_ stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: stringDate)
        return newDate!
    }
    
    func lastDayOfMonth() -> (Date,Int)
    {
        let calendar = Calendar.current
        let now = self
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        let range = calendar.range(of: .day, in: .month, for: now)!
        //        return range.upperBound - 1
        components.day = range.upperBound - 1
        return (calendar.date(from: components)!, range.upperBound - 1)
    }
    
    func lowerDate(limit: Int = -5) -> Date
    {
        return Calendar.current.date(byAdding: .day, value: limit, to: self)!
    }
    
    func upperDate(limit: Int = 5) -> Date
    {
        return Calendar.current.date(byAdding: .day, value: limit, to: self)!
    }
    
    /// Returns a Date with the specified days added to the one it is called with
    func add(days: Int = 0) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(days: Int = 0) -> Date {
        let inverseDays = -1 * days
        return add(days: inverseDays)
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        //Return Hour
        return hour
    }
    func is1HourDiff(date: Date) -> Bool{
        let timestamp1 = date.milisecondInt64/1000
        let timesamp2 = self.milisecondInt64/1000
        var finaltimestamp:Int64!
        if timestamp1 < timesamp2{
            finaltimestamp =  timesamp2 - timestamp1
        }
        else{
            finaltimestamp =  timestamp1 - timesamp2
        }
        
        let hours = finaltimestamp/3600
        if hours >= 1{
            return true
        }
        else{
            return false
        }
    }
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self)
        
        //Return Minute
        return minute
    }
    func getTimeBetweenTwoTime(_ date:Date) -> Bool{
        let now = date.hour()
        let early = self.hour() - 1
        let later = self.hour() + 1
        if self > date{
            return false
        }else if self == date {
            if now >= early && now <= later
            {
              print("The time is between 8:00 and 16:30")
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
        
    }
    func getTime1HrsBigTime(_ date:Date) -> Bool{
        let now = date.hour()
        let early = self.hour()
        if (now - early) >= 1{
            return true
        }
        else{
            return false
        }
        
    }
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from:self)
        
        //Return Short Time String
        return timeString
    }
}
extension Int64{
    
    func secondsToTime(isHours:Bool = true,isFull:Bool = false) -> String {
        
        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        
        var hors = ""
        var mins = ""
        var secs = ""
        if isHours{
            hors = h > 1 ? "hrs" : "hr"
            mins = m > 1 ? "mins" : "min"
            secs = s > 1 ? "secs" : "sec"
        }
        
        if isFull{
            var h_string = ""
            h_string = "\(m < 10 ? "0\(m)" : "\(m)"):\(s < 10 ? "0\(s)" : "\(s)")"
            return h_string
        }
        else{
            if h != 0{
                var h_string = ""
                h_string = h < 10 ? "0\(h) \(hors) \(m < 10 ? "0\(m)" : "\(m)") \(mins)" : "\(h) \(hors) \(m < 10 ? "0\(m)" : "\(m)") \(mins)"
                return h_string
                
            }
            else if m != 0{
                var m_string = ""
                m_string = m < 10 ? "0\(m) \(mins) \(s < 10 ? "0\(s)" : "\(s)") \(secs)" : "\(m) \(mins) \(s < 10 ? "0\(s)" : "\(s)") \(secs)"
                return m_string
            }
            else{
                var s_string = ""
                s_string = s < 10 ? "0\(s) \(secs)" : "\(s) \(secs)"
                return s_string
            }
        }
        
    }

    
    func check5Mins(_ tz:Calendar? = nil) -> Bool{
        let calendar = tz ?? Calendar.current
        let now = Date()
        let date = Date(timeIntervalSince1970: TimeInterval(self/1000))
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        if components.minute! >= 5{
            return true
        }
        else{
            return false
        }
    }
    func getInt64toTime() -> Date{
        return Date(timeIntervalSince1970: TimeInterval(self/1000))
    }
    func getInt64toDate(date:Date) -> Bool{
        let dat = Date(timeIntervalSince1970: TimeInterval(self/1000))
        let calender = Calendar.current
        let final = calender.dateComponents([.day,.month,.year], from: dat)
        let final1 = calender.dateComponents([.day,.month,.year], from: date)
        if final == final1 {
            
            return true
        }
        else{
            return false
        }
    }
    
    
    
    
    func metersToDistance() -> String{
        let (km,m) = (self / 1000, (self % 1000) % 1000)
        
        if km != 0{
            var km_string = ""
            if km > 1{
                km_string = km < 10 ? "0\(km) km" : "\(km) km"
            }
            else{
                km_string = km < 10 ? "0\(km) km" : "\(km) km"
            }
            return km_string
            
        }
        else {
            var m_string = ""
            if m > 1{
                m_string = m < 10 ? "0\(m) m" : "\(m) m"
            }
            else{
                m_string = m < 10 ? "0\(m) m" : "\(m) m"
            }
            return m_string
        }
    }
    func metersToMiles() -> Double{
        var measer = Double(self)
        measer *= 0.000621
        return measer
    }
    
    func metersToKM() -> Double{
        var measer = Double(self)
        measer = measer / 1000
        return measer
    }

    func secondsToMins() -> Double{
        return Double((self % 3600) / 60)
    }
    func secondsToTime() -> String {
        
        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        if h != 0{
            var h_string = ""
            if h > 1{
                h_string = h < 10 ? "0\(h) hrs" : "\(h) hrs"
            }
            else{
                h_string = h < 10 ? "0\(h) hr" : "\(h) hr"
            }
            return h_string
            
        }
        else if m != 0{
            var m_string = ""
            if m > 1{
                m_string = m < 10 ? "0\(m) mins" : "\(m) mins"
            }
            else{
                m_string = m < 10 ? "0\(m) min" : "\(m) min"
            }
            return m_string
        }
        else{
            var s_string = ""
            if s > 1{
                s_string = s < 10 ? "0\(s) secs" : "\(s) secs"
            }
            else{
                s_string = s < 10 ? "0\(s) sec" : "\(s) sec"
            }
            return s_string
        }
    }
}

extension Float {
    func getFullTime() -> String{
        let val = Int(self)
        if val == 23{
           return "\(val):50:00"
        }
        else{
           return "\(val):00:00"
        }
    }
    var round: String {
        return String(format: "%.1f", self)
    }
    var string2: String {
        return String(format: "%.2f", self)
    }
}

extension Double {
    
    /**
     Rounds the double to decimal places value
     */
    
    
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    mutating func calculatePercentage(percentageVal:Double)->Double{
        var val = self * percentageVal
        val = val/100.0
        
        return val
    }
    mutating func calculateServiceChargePercentage(percentageVal:Double)->Double{
        var val = self * percentageVal
        val = val/100.0
        
        return val
    }
    func metersToMiles() -> Double{
        var measer = Double(self)
        measer *= 0.000621
        return measer
    }
}

extension CALayer {
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

func *=(left:CGSize, right:CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}
enum GradientDirection {
    case topBottom, leftRight, rightLeft
}
extension UIDevice {
    func getDeviceModel() -> String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        // iPhones
        case "iPhone1,1":
            return "iPhone 2G (A1203)"
        case "iPhone1,2":
            return "iPhone 3G (A1241/A1324)"
        case "iPhone2,1":
            return "iPhone 3GS (A1303/A1325)"
        case "iPhone3,1":
            return "iPhone 4 (A1332)"
        case "iPhone3,2":
            return "iPhone 4 (A1332)"
        case "iPhone3,3":
            return "iPhone 4 (A1349)"
        case "iPhone4,1":
            return "iPhone 4S (A1387/A1431)"
        case "iPhone5,1":
            return "iPhone 5 (A1428)"
        case "iPhone5,2":
            return "iPhone 5 (A1429/A1442)"
        case "iPhone5,3":
            return "iPhone 5C (A1456/A1532)"
        case "iPhone5,4":
            return "iPhone 5C (A1507/A1516/A1526/A1529)"
        case "iPhone6,1":
            return "iPhone 5C (A1453/A1533)"
        case "iPhone6,2":
            return "iPhone 5S (A1457/A1518/A1528/A1530)"
        case "iPhone7,1":
            return "iPhone 6 Plus (A1522/A1524)"
        case "iPhone7,2":
            return "iPhone 6 (A1549/A1586)"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
            
        // iPods
        case "iPod1,1":
            return "iPod Touch 1G (A1213)"
        case "iPod2,1":
            return "iPod Touch 2G (A1288)"
        case "iPod3,1":
            return "iPod Touch 3G (A1318)"
        case "iPod4,1":
            return "iPod Touch 4G (A1367)"
        case "iPod5,1":
            return "iPod Touch 5G (A1421/A1509)"
            
        // iPads
        case "iPad1,1":
            return "iPad 1G (A1219/A1337)"
        case "iPad2,1":
            return "iPad 2 (A1395)"
        case "iPad2,2":
            return "iPad 2 (A1396)"
        case "iPad2,3":
            return "iPad 2 (A1397)"
        case "iPad2,4":
            return "iPad 2 (A1395+New Chip)"
        case "iPad2,5":
            return "iPad Mini 1G (A1432)"
        case "iPad2,6":
            return "iPad Mini 1G (A1454)"
        case "iPad2,7":
            return "iPad Mini 1G (A1455)"
        case "iPad3,1":
            return "iPad 3 (A1416)"
        case "iPad3,2":
            return "iPad 3 (A1403)"
        case "iPad3,3":
            return "iPad 3 (A1430)"
        case "iPad3,4":
            return "iPad 4 (A1458)"
        case "iPad3,5":
            return "iPad 4 (A1459)"
        case "iPad3,6":
            return "iPad 4 (A1460)"
        case "iPad4,1":
            return "iPad Air (A1474)"
        case "iPad4,2":
            return "iPad Air (A1475)"
        case "iPad4,3":
            return "iPad Air (A1476)"
        case "iPad4,4":
            return "iPad Mini 2G (A1489)"
        case "iPad4,5":
            return "iPad Mini 2G (A1490)"
        case "iPad4,6":
            return "iPad Mini 2G (A1491)"
            
        // Simulators
        case "i386":
            return "iPhone Simulator 32Bit"
        case "x86_64":
            return "iPhone Simulator 64Bit"
            
        // Default
        default:
            return "watting to update"
        }
        
    }
    
    func getDeviceTypeOn456() -> Int {
        switch getDeviceModel() {
        case "iPhone 4 (A1332)", "iPhone 4 (A1349)", "iPhone 4S (A1387/A1431)":
            return 4
        case "iPhone 5 (A1428)", "iPhone 5 (A1429/A1442)", "iPhone 5C (A1456/A1532)", "iPhone 5C (A1507/A1516/A1526/A1529)",
             "iPhone 5C (A1453/A1533)", "iPhone 5S (A1457/A1518/A1528/A1530)":
            return 5
        case "iPhone 6 Plus (A1522/A1524)", "iPhone 6 (A1549/A1586)":
            return 6
        default:
            return 4
        }
    }
    
    func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    func getIdfv() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}

//MARK:- UIColor Extension
extension UIColor {
    enum assetColors:String {
        
        
        case purplecolor
        case orangeColor
        case greenColor
        case orangeColor30
        case greenColor30
        case bgColor
        case black50
        case blueColor
        case blue33
        case blackColor
        case botomTint
        case bottomTint2
        case greyColor
  
    }
    /**
     To get UIColor from hex string.
     - parameter hex: Hex value of color code.
     */
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func colorsFromAsset(name: assetColors) -> UIColor{
        switch name {
            
        case .greenColor:
            return UIColor(named: name.rawValue)!
        case .greenColor30:
            return UIColor(named: name.rawValue)!
        case .purplecolor:
            return UIColor(named: name.rawValue)!
        case .orangeColor:
            return UIColor(named: name.rawValue)!
        case .orangeColor30:
            return UIColor(named: name.rawValue)!

        case .blueColor:
            return UIColor(named: name.rawValue)!
        case .bgColor:
            return UIColor(named: name.rawValue)!
        case .greyColor:
            return UIColor(named: name.rawValue)!
        case .black50:
            return UIColor(named: name.rawValue)!
        case .blue33:
            return UIColor(named: name.rawValue)!
        case .blackColor:
            return UIColor(named: name.rawValue)!
        case .botomTint:
            return UIColor(named: name.rawValue)!
            
        default:
            return UIColor.white
        
        }
    }
    
    
    
}
public extension Bundle{
    var displayName: String? {
        let name = self.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        debugPrint(name)
        return name
        //return "I Was Framed"
    }
}
public extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    enum UIGradientStyle {
       case leftToRight
       case radial
       case topToBottom
     }
     static func color(withGradientStyle gradientStyle: UIGradientStyle, frame: CGRect, colors: [UIColor]) -> UIColor {
       // Create our background gradient layer
       let backgroundGradientLayer = CAGradientLayer()
       // Set the frame to our object's bounds
       backgroundGradientLayer.frame = frame
       // Convert UIColor array to CGColor array
       let cgColors = colors.map { $0.cgColor }
       switch gradientStyle {
       case .leftToRight:
         // Set our gradient's colors
         backgroundGradientLayer.colors = cgColors
         // Specify the direction our gradient will take
         backgroundGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
         backgroundGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
         // Convert our CALayer to a UIImage object
         return UIColor(patternImage: image(fromLayer: backgroundGradientLayer))
       case .radial:
         return UIColor(patternImage: radialGradientImage(frame: frame, colors: cgColors))
       case .topToBottom:
         // Set our gradient's colors
         backgroundGradientLayer.colors = cgColors
         // Default start and end points for top to bottom gradient
         backgroundGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
         backgroundGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
         // Convert our CALayer to a UIImage object
         return UIColor(patternImage: image(fromLayer: backgroundGradientLayer))
       }
     }
     private static func image(fromLayer layer: CALayer) -> UIImage {
       UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
       layer.render(in: UIGraphicsGetCurrentContext()!)
       let outputImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()
       return outputImage
     }
     private static func radialGradientImage(frame: CGRect, colors: [CGColor]) -> UIImage {
       UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
       let context = UIGraphicsGetCurrentContext()!
       // Specific the spread of the gradient (For now this gradient only takes 2 locations)
       let locations: [CGFloat] = [0.0, 1.0]
       // Default to the RGB Colorspace
       let colorSpace = CGColorSpaceCreateDeviceRGB()
       // Create our Gradient
       let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
       // Normalize the 0-1 ranged inputs to the width of the image
       let centerPoint = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
       let radius = min(frame.size.width, frame.size.height)
       // Draw our Gradient
       context.drawRadialGradient(gradient, startCenter: centerPoint, startRadius: 0, endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
       // Grab it as an Image
       let outputImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()
       return outputImage
     }
}

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
extension UIFont{
    static func fractionFont(ofSize pointSize: CGFloat,weight: UIFont.Weight) -> UIFont
    {
        //let systemFontDesc = UIFont(name: "Exo", size: pointSize)?.fontDescriptor
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize, weight: weight).fontDescriptor
        
        let fractionFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                    ], ]
            ] )
        return UIFont(descriptor: fractionFontDesc, size:pointSize)
    }
}

extension UIButton {

    func imageURLProfile(_ url: String) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)

       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true



        self.addSubview(activityIndicator)

        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

        let placholdr = UIImage(named: "Icon awesome-user-alt")!

        self.sd_setImage(with: URL(string: url), for: .normal, placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }

    func imageURL(_ url: String) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)

       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true



        self.addSubview(activityIndicator)

        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

        let placholdr = UIImage(named: "AppIcon")!

        self.sd_setImage(with: URL(string: url), for: .normal, placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }
}


extension UIImageView {
    
    func imageURLBackProfile(_ url: String) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)

       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true



        self.addSubview(activityIndicator)

        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

        let placholdr = UIImage(named: "AppIcon")!

        self.sd_setImage(with: URL(string: url), placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }


    func imageURLProfile(_ url: String) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)

       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true



        self.addSubview(activityIndicator)

        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

        let placholdr = UIImage(named: "Icon awesome-user-alt")!

        self.sd_setImage(with: URL(string: url), placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }

    func imageURL(_ url: String) {

        let activityIndicator = UIActivityIndicatorView(style: .medium)

       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true



        self.addSubview(activityIndicator)

        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

        let placholdr = UIImage(resource: .logo)

        self.sd_setImage(with: URL(string: url), placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
            activityIndicator.stopAnimating()
        }
    }
}

extension CLLocation{
    func getdistanceInt64(tocord:CLLocation) -> Int64{
        return Int64(tocord.distance(from: self))
        
    }
    func getdistance(tocord:CLLocation) -> Double{
        return tocord.distance(from: self)
        
    }
}

extension MKCoordinateRegion {
    var northWest: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude + span.latitudeDelta / 2, longitude: center.longitude - span.longitudeDelta / 2)
    }

    var southEast: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: center.latitude - span.latitudeDelta / 2, longitude: center.longitude + span.longitudeDelta / 2)
    }
}
extension Notification.Name {
    /// Notification when user successfully sign in using Google
    static var availableRide: Notification.Name {
        return .init(rawValue: #function)
    }
}


//extension AuthErrorCode {
//    var errorMessage: String {
//        switch self {
//        case .emailAlreadyInUse:
//            return "The email is already in use with another account"
//        case .userNotFound:
//            return "Account not found for the specified user. Please check and try again"
//        case .userDisabled:
//            return "Your account has been disabled. Please contact support."
//        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
//            return "Please enter a valid email"
//        case .networkError:
//            return "Network error. Please try again."
//        case .weakPassword:
//            return "Your password is too weak. The password must be 6 characters long or more."
//        case .wrongPassword:
//            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
//        default:
//            return "Unknown error occurred"
//        }
//    }
//}
//
//
//extension UIViewController{
//    func handleError(_ error: Error) {
//        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
//            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//
//        }
//    }
//
//}



//extension UIImageView {
//
//    func imageURL(_ url: String) {
//
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//
//       // activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
//        activityIndicator.frame = CGRect(x: self.frame.size.width  / 2, y: self.frame.size.height / 2, width: 64, height: 64)
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = true
//
//
//
//        self.addSubview(activityIndicator)
//
//        //self.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
//
//        let placholdr = #imageLiteral(resourceName: "playstore")
//
//        self.sd_setImage(with: URL(string: url), placeholderImage: placholdr, options: .continueInBackground){ (image, error, cacheType, url) in
//            activityIndicator.stopAnimating()
//        }
//    }
//}



extension Date {

  func isEqualTo(_ date: Date) -> Bool {
    return self == date
  }
  
  func isGreaterThan(_ date: Date) -> Bool {
     return self > date
  }
  
  func isSmallerThan(_ date: Date) -> Bool {
     return self < date
  }
}

//extension AuthErrorCode {
//    var errorMessage: String {
//        switch self {
//        case .emailAlreadyInUse:
//            return "The email is already in use with another account"
//        case .userNotFound:
//            return "Account not found for the specified user. Please check and try again"
//        case .userDisabled:
//            return "Your account has been disabled. Please contact support."
//        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
//            return "Please enter a valid email"
//        case .networkError:
//            return "Network error. Please try again."
//        case .weakPassword:
//            return "Your password is too weak. The password must be 6 characters long or more."
//        case .wrongPassword:
//            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
//        default:
//            return "Unknown error occurred"
//        }
//    }
//}
//
//
//extension UIViewController{
//    func handleError(_ error: Error) {
//        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
//            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//
//            alert.addAction(okAction)
//
//            self.present(alert, animated: true, completion: nil)
//
//        }
//    }
//
//}
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
       // self.separatorStyle = .none
    }

    func restore() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.textColor = .white
        messageLabel.text = ""
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
    func createDirectionCollection(_ spacing:CGFloat = 16,_ direction:UICollectionView.ScrollDirection = .horizontal){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.scrollDirection = direction
        self.collectionViewLayout = layout
    }
}

extension Date {
    func timeAgoDisplay() -> String {
 
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hr ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat,height: CGFloat, isOpaque: Bool = true) -> UIImage? {
        
        let canvas = CGSize(width: width, height: height)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
               let maxRadius = min(size.width, size.height) / 2
               let cornerRadius: CGFloat
               if let radius = radius, radius > 0 && radius <= maxRadius {
                   cornerRadius = radius
               } else {
                   cornerRadius = maxRadius
               }
               UIGraphicsBeginImageContextWithOptions(size, false, scale)
               let rect = CGRect(origin: .zero, size: size)
               UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
               draw(in: rect)
               let image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               return image
           }
}
typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
  case topRightBottomLeft
  case topLeftBottomRight
  case horizontal
  case vertical

var startPoint: CGPoint {
    return points.startPoint
}

var endPoint: CGPoint {
    return points.endPoint
}

var points: GradientPoints {
    switch self {
    case .topRightBottomLeft:
        return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
    case .topLeftBottomRight:
        return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1, y: 1))
    case .horizontal:
        return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
    case .vertical:
        return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
    }
  }
}

extension UIView {

func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil) {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.locations = locations
    self.layer.insertSublayer(gradient, at: 0)
}

func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation) {
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.colors = colours.map { $0.cgColor }
    gradient.startPoint = orientation.startPoint
    gradient.endPoint = orientation.endPoint
    self.layer.insertSublayer(gradient, at: 0)
    
  }
}
extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}
