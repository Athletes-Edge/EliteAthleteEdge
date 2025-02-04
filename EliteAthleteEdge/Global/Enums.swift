//
//  Enums.swift
//  yahlove
//
//  Created by Buzzware Tech on 22/11/2022.
//

import UIKit

class Enums {

    
}

enum currentType:String{
    case auto = "Automobile"
    case residenal = "Residential"
    case comercial = "Commercial"
}
enum currentSubType:String{
    case lockout = "Lockout"
    case keyprograming = "Key Programming"
    case rekey = "Re-Key"
    case lockRepair = "Lock Repair"
}
enum UserRole:String{
    case user,admin,coach
}
enum InviteApp:String{
    case userlogins,jointeam
}
enum Gender:String{
    case male,female
}
enum bookingStatus:String{
    case await,awaited,accept,accepted,canceld,cancelded,complete,completed,review,reviewed
}
enum InviteStatus:String{
  case request,requested,accept,accepted,reject,rejected
}
enum ChatType:String{
    case one,many
}
enum favType:String{
    case likes,matches,visit
}
enum MessageType:String{
    case text,image,voice
}
enum profileType:String{
    case edit,visit,news
}
enum UserCategory:String,CaseIterable{
    case basic = "BASIC",advance = "ADVANCED",premium = "PREMIUM"
}
enum MediaType:String{
    case image = "public.image",video = "public.movie"
}
enum Weekdays:String,CaseIterable{
    case Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
}
enum FinanceType:String,CaseIterable{
    case repair,fuel,insurance
}
enum rekeyType:String{
  case deadbolt,knob
}
//enum FontMontserrat: String {
//    case Montserrat_Regular,Montserrat_Italic,Montserrat_ExtraLight,Montserrat_Thin,Montserrat_ExtraLightItalic,Montserrat_ThinItalic,Montserrat_Light,Montserrat_LightItalic,Montserrat_Medium,Montserrat_MediumItalic,Montserrat_SemiBold,Montserrat_SemiBoldItalic,Montserrat_Bold,Montserrat_ExtraBoldItalic,Montserrat_Black,Montserrat_BlackItalic,Montserrat_BoldItalic
//
//    var fontName: String {
//        switch self {
//        case .Montserrat_Regular:
//            return Constant.Montserrat_Regular
//        case .Montserrat_Italic:
//            return Constant.Montserrat_Italic
//        case .Montserrat_ExtraLight:
//            return Constant.Montserrat_ExtraLight
//        case .Montserrat_Thin:
//            return Constant.Montserrat_Thin
//        case .Montserrat_ExtraLightItalic:
//            return Constant.Montserrat_ExtraLightItalic
//        case .Montserrat_ThinItalic:
//            return Constant.Montserrat_ThinItalic
//        case .Montserrat_Light:
//            return Constant.Montserrat_Light
//        case .Montserrat_LightItalic:
//            return Constant.Montserrat_LightItalic
//        case .Montserrat_Medium:
//            return Constant.Montserrat_Medium
//        case .Montserrat_MediumItalic:
//            return Constant.Montserrat_MediumItalic
//        case .Montserrat_SemiBold:
//            return Constant.Montserrat_SemiBold
//        case .Montserrat_SemiBoldItalic:
//            return Constant.Montserrat_SemiBoldItalic
//        case .Montserrat_Bold:
//            return Constant.Montserrat_Bold
//        case .Montserrat_BoldItalic:
//            return Constant.Montserrat_BoldItalic
//        case .Montserrat_ExtraBoldItalic:
//            return Constant.Montserrat_ExtraBoldItalic
//        case .Montserrat_Black:
//            return Constant.Montserrat_Black
//        case .Montserrat_BlackItalic:
//            return Constant.Montserrat_BlackItalic
//            
//        
//        }
//    }
//}
enum FontRubik: String {
    case Rubik_Regular,Rubik_Italic,Rubik_Light,Rubik_LightItalic,Rubik_Medium,Rubik_MediumItalic,Rubik_SemiBold,Rubik_SemiBoldItalic,Rubik_Bold,Rubik_ExtraBoldItalic,Rubik_Black,Rubik_BlackItalic,Rubik_BoldItalic

    var fontName: String {
        switch self {
        case .Rubik_Regular:
            return Constant.Rubik_Regular
        case .Rubik_Italic:
            return Constant.Rubik_Italic
        
        case .Rubik_Light:
            return Constant.Rubik_Light
        case .Rubik_LightItalic:
            return Constant.Rubik_LightItalic
        case .Rubik_Medium:
            return Constant.Rubik_Medium
        case .Rubik_MediumItalic:
            return Constant.Rubik_MediumItalic
        case .Rubik_SemiBold:
            return Constant.Rubik_SemiBold
        case .Rubik_SemiBoldItalic:
            return Constant.Rubik_SemiBoldItalic
        case .Rubik_Bold:
            return Constant.Rubik_Bold
        case .Rubik_ExtraBoldItalic:
            return Constant.Rubik_ExtraBoldItalic
        case .Rubik_Black:
            return Constant.Rubik_Black
        case .Rubik_BlackItalic:
            return Constant.Rubik_BlackItalic
        case .Rubik_BoldItalic:
            return Constant.Rubik_BoldItalic
            
        
        }
    }
}
