//
//  ChatModel.swift
//  MyReferral
//
//  Created by vision on 09/06/20.
//  Copyright © 2020 vision. All rights reserved.
//

import UIKit
enum ChatKeys:String{
    case content = "content"
    case fromID = "fromID"
    case toID = "toID"
    case timestamp = "timestamp"
    case type = "type"
    case isRead = "isRead"
    case messageId = "messageId"
    case isLike = "isLike"
    case replyCount = "replyCount"

    
}
class ChatModel: GenericDictionary {
    var content:String!
    {
        get{ return stringForKey(key: ChatKeys.content.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.content.rawValue)}
    }
    
    var fromID:String!
    {
        get{ return stringForKey(key: ChatKeys.fromID.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.fromID.rawValue)}
    }
    
    var toID:String!
    {
        get{ return stringForKey(key: ChatKeys.toID.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.toID.rawValue)}
    }
    
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: ChatKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.timestamp.rawValue)}
    }
    
    var type:String!
    {
        get{ return stringForKey(key: ChatKeys.type.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.type.rawValue)}
    }
    
    var isRead:Bool!
    {
        get{ return boolForKey(key: ChatKeys.isRead.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: ChatKeys.isRead.rawValue)}
    }
    
    var messageId:String!
    {
        get{ return stringForKey(key: ChatKeys.messageId.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.messageId.rawValue)}
    }
    var replyCount:String!
    {
        get{ return stringForKey(key: ChatKeys.replyCount.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.replyCount.rawValue)}
    }
    var isLike:[String]!
    {
        get{ return stringArrayForKey(key: ChatKeys.isLike.rawValue)}
        set{setValue(newValue, forKey: ChatKeys.isLike.rawValue)}
    }
}

enum NotificationKeys:String{
    case message = "message"
    case serviceId = "serviceId"
    case id = "id"
    case title = "title"
    case type = "type"
    case time = "time"
    case userID = "userID"

    
}
class NotificationModel: GenericDictionary {
    var message:String!
    {
        get{ return stringForKey(key: NotificationKeys.message.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.message.rawValue)}
    }
    
    var serviceId:String!
    {
        get{ return stringForKey(key: NotificationKeys.serviceId.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.serviceId.rawValue)}
    }
    
    var id:String!
    {
        get{ return stringForKey(key: NotificationKeys.id.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.id.rawValue)}
    }
    
    var time:Int64!
    {
        get{ return int64ForKey(key: NotificationKeys.time.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.time.rawValue)}
    }
    
    var title:String!
    {
        get{ return stringForKey(key: NotificationKeys.title.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.title.rawValue)}
    }

    var type:String!
    {
        get{ return stringForKey(key: NotificationKeys.type.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.type.rawValue)}
    }
    var userID:String!
    {
        get{ return stringForKey(key: NotificationKeys.userID.rawValue)}
        set{setValue(newValue, forKey: NotificationKeys.userID.rawValue)}
    }
}


class CommentModel{
    var chat:ChatModel!
    var user:UserModel!
    init(chat: ChatModel? = nil, user: UserModel? = nil) {
        self.chat = chat
        self.user = user
    }
}
class RepliesModel{
    var chat:ChatModel!
    var user:UserModel!
    init(chat: ChatModel? = nil, user: UserModel? = nil) {
        self.chat = chat
        self.user = user
    }
}
enum RequestKeys:String {
  case id = "id"
  case heading = "heading"
  case category = "category"
  case subCategory = "subCategory"
    case reKeyLock = "reKeyLock"
  case priceperhr = "priceperhr"
  case aboutme = "aboutme"
  case relevantExperience = "relevantExperience"
  case userId = "userId"
  case date = "date"
  case status = "status"
  case rating = "rating"
}
class RequestModel: GenericDictionary {
  var user:UserModel!
  var id:String!
  {
    get{ return stringForKey(key: RequestKeys.id.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.id.rawValue)}
  }
  var heading:String!
  {
    get{ return stringForKey(key: RequestKeys.heading.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.heading.rawValue)}
  }
  var category:String!
  {
    get{ return stringForKey(key: RequestKeys.category.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.category.rawValue)}
  }
  var subCategory:String!
  {
    get{ return stringForKey(key: RequestKeys.subCategory.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.subCategory.rawValue)}
  }
    var reKeyLock:String!
    {
        get{ return stringForKey(key: RequestKeys.reKeyLock.rawValue)}
        set{setValue(newValue, forKey: RequestKeys.reKeyLock.rawValue)}
    }
  var priceperhr:String!
  {
    get{ return stringForKey(key: RequestKeys.priceperhr.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.priceperhr.rawValue)}
  }
  var aboutme:String!
  {
    get{ return stringForKey(key: RequestKeys.aboutme.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.aboutme.rawValue)}
  }
  var relevantExperience:String!
  {
    get{ return stringForKey(key: RequestKeys.relevantExperience.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.relevantExperience.rawValue)}
  }
  var userId:String!
  {
    get{ return stringForKey(key: RequestKeys.userId.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.userId.rawValue)}
  }
  var date:Int64!
  {
    get{ return int64ForKey(key: RequestKeys.date.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.date.rawValue)}
  }
  var status:String!
  {
    get{ return stringForKey(key: RequestKeys.status.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.status.rawValue)}
  }
  var rating:[Double]!
  {
    get{ return doubleArrayForKey(key: RequestKeys.rating.rawValue)}
    set{setValue(newValue, forKey: RequestKeys.rating.rawValue)}
  }
}
enum CellType:String {
    case btn
    case tf
    case tv
    case tfimage
    case image
    case check
    case drop
    case slider
    case collection


}
import UIKit

class SettingModel {

    var name:String!
    var nameplace:String!
    var key:UserKeys!
    var cellType:CellType!
    var nameDetail: String!
    var nameDetail1: String!
    var nameDetailInt: Int64!
    var keyboardType:UIKeyboardType!
    var isEnable:Bool!
    var isSecure:Bool!
    var isError:Bool!
    var optionDrop:[String]!
    var isValid:Bool!
    var isBtnHide:Bool!
    var isComplete:Bool!
    var borderColor:UIColor!
    var imageName:String!
    
    
    
    init(name:String? = nil,nameplace:String? = nil,cellType:CellType? = nil,key:UserKeys? = nil,detailInt:Int64? = nil,detail:String? = nil,detail1:String? = nil,keyboardType:UIKeyboardType = .default ,isEnable:Bool = true,isSecure:Bool = false,isError:Bool = false,isValid:Bool = false,isComplete:Bool = false,isBtnHide:Bool = false,borderColor:UIColor = .lightGray,imageName:String? = nil,optionDrop:[String]? = nil) {
        self.name = name
        self.key = key
        self.cellType = cellType
        self.nameDetail = detail
        self.nameDetail1 = detail1
        self.keyboardType = keyboardType
        self.isEnable = isEnable
        self.isSecure = isSecure
        self.isError = isError
        self.nameDetailInt = detailInt
        self.isValid = isValid
        self.isBtnHide = isBtnHide
        self.isComplete = isComplete
        self.borderColor = borderColor
        self.imageName = imageName
        self.optionDrop = optionDrop
        self.nameplace = nameplace
    }
}
class SettingRequestModel {

    var name:String!
    var nameplace:String!
    var key:RequestKeys!
    var cellType:CellType!
    var nameDetail: String!
    var nameDetail1: String!
    var nameDetailInt: Int64!
    var keyboardType:UIKeyboardType!
    var isEnable:Bool!
    var isSecure:Bool!
    var isError:Bool!
    var optionDrop:[String]!
    var isValid:Bool!
    var isBtnHide:Bool!
    var isComplete:Bool!
    var borderColor:UIColor!
    var imageName:String!
    
    
    
    init(name:String? = nil,nameplace:String? = nil,cellType:CellType? = nil,key:RequestKeys? = nil,detailInt:Int64? = nil,detail:String? = nil,detail1:String? = nil,keyboardType:UIKeyboardType = .default ,isEnable:Bool = true,isSecure:Bool = false,isError:Bool = false,isValid:Bool = false,isComplete:Bool = false,isBtnHide:Bool = false,borderColor:UIColor = .lightGray,imageName:String? = nil,optionDrop:[String]? = nil) {
        self.name = name
        self.key = key
        self.cellType = cellType
        self.nameDetail = detail
        self.nameDetail1 = detail1
        self.keyboardType = keyboardType
        self.isEnable = isEnable
        self.isSecure = isSecure
        self.isError = isError
        self.nameDetailInt = detailInt
        self.isValid = isValid
        self.isBtnHide = isBtnHide
        self.isComplete = isComplete
        self.borderColor = borderColor
        self.imageName = imageName
        self.optionDrop = optionDrop
        self.nameplace = nameplace
    }
}
