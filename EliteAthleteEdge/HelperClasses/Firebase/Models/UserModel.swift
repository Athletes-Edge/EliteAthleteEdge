//
//  UserModel.swift
//  MyReferral
//
//  Created by vision on 15/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit

enum UserKeys:String {
    
    //Must variable
    case firstName = "firstName"
    case lastName = "lastName"
    case email = "email"
    case username = "username"
    case userImage = "userImage"
    case userName = "name"

    case pointsSkill = "pointsSkill"
    case isSubsCribed = "isSubsCribed"
    
    case dob = "dob"
    case address = "address"
    case userDate = "userDate"

    case deviceType = "deviceType"
    case isOnline = "isOnline"
    case token = "token"

    
    
    

    
    case password = "password"
    case phoneNumber = "phoneNumber"
    case ratings = "ratings"
    case confirmPassword = "confirmPassword"
    case userRole = "userRole"
    case lat = "lat"
    case lng = "lng"
    
    //optional variable
    case stripeCustid = "stripeCustid"
    case userId = "userId"
    case city = "city"
    case state = "state"
    case zipcode = "zipcode"
    
    case pm_id = "pm_id"
    case team = "team"
    case isVerified = "isVerified"
    
}
class UserModel: GenericDictionary {
    
    var stripeCustid:String!
    {
        get{ return stringForKey(key: UserKeys.stripeCustid.rawValue)}
        set{setValue(newValue, forKey: UserKeys.stripeCustid.rawValue)}
    }
    var team:[String]!
    {
        get{ return stringArrayForKey(key: UserKeys.team.rawValue)}
        set{setValue(newValue, forKey: UserKeys.team.rawValue)}
    }
    var userName:String!
    {
        get{ return stringForKey(key: UserKeys.userName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userName.rawValue)}
    }
    var phoneNumber:String!
    {
        get{ return stringForKey(key: UserKeys.phoneNumber.rawValue)}
        set{setValue(newValue, forKey: UserKeys.phoneNumber.rawValue)}
    }
    
    var firstName:String!
    {
        get{ return stringForKey(key: UserKeys.firstName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.firstName.rawValue)}
    }
    var lastName:String!
    {
        get{ return stringForKey(key: UserKeys.lastName.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lastName.rawValue)}
    }
    var userImage:String!
    {
        get{ return stringForKey(key: UserKeys.userImage.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userImage.rawValue)}
    }
    
    var pointsSkill:Int64!
    {
        get{ return int64ForKey(key: UserKeys.pointsSkill.rawValue)}
        set{setValue(newValue, forKey: UserKeys.pointsSkill.rawValue)}
    }
    
    var email:String!
    {
        get{ return stringForKey(key: UserKeys.email.rawValue)}
        set{setValue(newValue, forKey: UserKeys.email.rawValue)}
    }
    
    var address:String!
    {
        get{ return stringForKey(key: UserKeys.address.rawValue)}
        set{setValue(newValue, forKey: UserKeys.address.rawValue)}
    }
    
    var confirmPassword:String!
    {
        get{ return stringForKey(key: UserKeys.password.rawValue)}
        set{setValue(newValue, forKey: UserKeys.password.rawValue)}
    }
    
    
    var password:String!
    {
        get{ return stringForKey(key: UserKeys.password.rawValue)}
        set{setValue(newValue, forKey: UserKeys.password.rawValue)}
        
    }
    var token:String!
    {
        get{ return stringForKey(key: UserKeys.token.rawValue)}
        set{setValue(newValue, forKey: UserKeys.token.rawValue)}
    }
    var userRole:String!
    {
        get{ return stringForKey(key: UserKeys.userRole.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userRole.rawValue)}
    }

    var userDate:Int64!
    {
        get{ return int64ForKey(key: UserKeys.userDate.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userDate.rawValue)}
    }
    
    var deviceType:String!
    {
        get{ return stringForKey(key: UserKeys.deviceType.rawValue)}
        set{setValue(newValue, forKey: UserKeys.deviceType.rawValue)}
    }

    var userId:String!
    {
        get{ return stringForKey(key: UserKeys.userId.rawValue)}
        set{setValue(newValue, forKey: UserKeys.userId.rawValue)}
    }
    
    var dob:Int64!
    {
        get{ return int64ForKey(key: UserKeys.dob.rawValue)}
        set{setValue(newValue, forKey: UserKeys.dob.rawValue)}
    }
    var isSubsCribed:Bool!
    {
        get{ return boolForKey(key: UserKeys.isSubsCribed.rawValue)}
        set{setValue(newValue, forKey: UserKeys.isSubsCribed.rawValue)}
    }
    var isVerified:Bool!
    {
        get{ return boolForKey(key: UserKeys.isVerified.rawValue)}
        set{setValue(newValue, forKey: UserKeys.isVerified.rawValue)}
    }
    var ratings:[Double]!
    {
        get{ return doubleArrayForKey(key: UserKeys.ratings.rawValue)}
        set{setValue(newValue, forKey: UserKeys.ratings.rawValue)}
    }
    
    var lat:Double!
    {
        get{ return douleForKey(key: UserKeys.lat.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lat.rawValue)}
    }
    var lng:Double!
    {
        get{ return douleForKey(key: UserKeys.lng.rawValue)}
        set{setValue(newValue, forKey: UserKeys.lng.rawValue)}
    }
    var pm_id:String!
    {
        get{ return stringForKey(key: UserKeys.pm_id.rawValue)}
        set{setValue(newValue, forKey: UserKeys.pm_id.rawValue)}
    }
    
}
enum BookingKeys:String {
    
    //Must variable
    case name = "name"
    case number = "number"
    case Make = "Make"
    case Model = "Model"
    case Year = "Year"
    case dateTime = "dateTime"
    case Picture = "Picture"
    case city = "city"

    case Address = "Address"
    case lat = "lat"
    case lng = "lng"
    case createdDate = "createdDate"

    case status = "status"
    case serviceProId = "serviceProId"
    case userId = "userId"
    case clientSecret = "clientSecret"

    case price = "price"

    case paymentStatus = "paymentStatus"
    case category = "category"
    case subCategory = "subCategory"
    case knobCount = "knobCount"
    case deadboltCount = "deadboltCount"
    case doorType = "doorType"
    
    
    
}
class BookingModel: GenericDictionary {
    
    var name:String!
    {
        get{ return stringForKey(key: BookingKeys.name.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.name.rawValue)}
    }
    var clientSecret:String!
    {
        get{ return stringForKey(key: BookingKeys.clientSecret.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.clientSecret.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: BookingKeys.userId.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.userId.rawValue)}
    }
    var category:String!
    {
        get{ return stringForKey(key: BookingKeys.category.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.category.rawValue)}
    }
    var subCategory:String!
    {
        get{ return stringForKey(key: BookingKeys.subCategory.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.subCategory.rawValue)}
    }
    var deadboltCount:Int64!
    {
        get{ return int64ForKey(key: BookingKeys.deadboltCount.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.deadboltCount.rawValue)}
    }
    var price:String!
    {
        get{ return stringForKey(key: BookingKeys.price.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.price.rawValue)}
    }
    var city:String!
    {
        get{ return stringForKey(key: BookingKeys.city.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.city.rawValue)}
    }
    var number:String!
    {
        get{ return stringForKey(key: BookingKeys.number.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.number.rawValue)}
    }
    var Make:String!
    {
        get{ return stringForKey(key: BookingKeys.Make.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.Make.rawValue)}
    }
    
    var Model:String!
    {
        get{ return stringForKey(key: BookingKeys.Model.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.Model.rawValue)}
    }
    var Year:String!
    {
        get{ return stringForKey(key: BookingKeys.Year.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.Year.rawValue)}
    }
    var status:String!
    {
        get{ return stringForKey(key: BookingKeys.status.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.status.rawValue)}
    }
    var paymentStatus:Bool!
    {
        get{ return boolForKey(key: BookingKeys.paymentStatus.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.paymentStatus.rawValue)}
    }
    
    var serviceProId:String!
    {
        get{ return stringForKey(key: BookingKeys.serviceProId.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.serviceProId.rawValue)}
    }
    
    var Address:String!
    {
        get{ return stringForKey(key: BookingKeys.Address.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.Address.rawValue)}
    }
    
    var dateTime:Int64!
    {
        get{ return int64ForKey(key: BookingKeys.dateTime.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.dateTime.rawValue)}
    }
    
    var createdDate:Int64!
    {
        get{ return int64ForKey(key: BookingKeys.createdDate.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.createdDate.rawValue)}
    }
    var lat:Double!
    {
        get{ return doubleForKey(key: BookingKeys.lat.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.lat.rawValue)}
    }
    var lng:Double!
    {
        get{ return doubleForKey(key: BookingKeys.lng.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.lng.rawValue)}
    }
    var knobCount:Int64!
    {
        get{ return int64ForKey(key: BookingKeys.knobCount.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.knobCount.rawValue)}
    }
    var doorType:String!
    {
        get{ return stringForKey(key: BookingKeys.doorType.rawValue)}
        set{setValue(newValue, forKey: BookingKeys.doorType.rawValue)}
    }
}

enum TeamModelKey: String {
    case id = "id"
    case name = "name"
    case image = "image"
    case isDefault = "isDefault"
    case coachIds = "coachIds"
    case createdDate = "createdDate"
    case intro = "intro"
    case members = "members"
}

class TeamModel: GenericDictionary {
    var name:String!
    {
        get{ return stringForKey(key: TeamModelKey.name.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.name.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: TeamModelKey.id.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.id.rawValue)}
    }
    var image:String!
    {
        get{ return stringForKey(key: TeamModelKey.image.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.image.rawValue)}
    }
    var coachIds: [String]! {
        get{ return stringArrayForKey(key: TeamModelKey.coachIds.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.coachIds.rawValue)}
    }
    var createdDate: Int64! {
        get{ return int64ForKey(key: TeamModelKey.createdDate.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.createdDate.rawValue)}
    }
    var intro: String! {
        get{ return stringForKey(key: TeamModelKey.intro.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.intro.rawValue)}
    }
    var members: [String]! {
        get{ return stringArrayForKey(key: TeamModelKey.members.rawValue)}
        set{setValue(newValue, forKey: TeamModelKey.members.rawValue)}
    }
}

enum SubcribKey: String {
    case id = "id"
    case fee = "fee"
    case plan = "plan"
    case userId = "userId"
    case endDate = "endDate"
    case createdDate = "createdDate"
    case startDate = "startDate"
    case status = "status"
}

class SubcribModel: GenericDictionary {
    var plan:String!
    {
        get{ return stringForKey(key: SubcribKey.plan.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.plan.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: SubcribKey.id.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.id.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: SubcribKey.userId.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.userId.rawValue)}
    }
    var status: String! {
        get{ return stringForKey(key: SubcribKey.status.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.status.rawValue)}
    }
    var createdDate: Int64! {
        get{ return int64ForKey(key: SubcribKey.createdDate.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.createdDate.rawValue)}
    }
    var endDate: Int64! {
        get{ return int64ForKey(key: SubcribKey.endDate.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.endDate.rawValue)}
    }
    var startDate: Int64! {
        get{ return int64ForKey(key: SubcribKey.startDate.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.startDate.rawValue)}
    }
    var fee: Double! {
        get{ return doubleForKey(key: SubcribKey.fee.rawValue)}
        set{setValue(newValue, forKey: SubcribKey.fee.rawValue)}
    }
    
}
