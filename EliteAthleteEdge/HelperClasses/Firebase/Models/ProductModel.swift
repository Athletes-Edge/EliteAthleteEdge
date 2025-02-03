//
//  ProductModel.swift
//  BetThatecomerce
//
//  Created by Buzzware Tech on 10/01/2023.
//

import UIKit


enum SongKeys:String {
    
    //Must variable
    case userId = "userId"
    case createdDate = "createdDate"
    case modifiedDate = "modifiedDate"
    case SongTitle = "SongTitle"
    case BPM = "BPM"
    case songContributers = "songContributers"
    case songUserColors = "songUserColors"
    case SongKey = "SongKey"
    case songNotes = "songNotes"
    case chatId = "chatId"
    case songLyrics = "songLyrics"
    case songnotifications = "songnotifications"
    case songBrainStrom = "songBrainStrom"
    case songNotifications2 = "songNotifications2"
    case isTyping = "isTyping"


}

class SongModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: SongKeys.userId.rawValue)}
        set{setValue(newValue, forKey: SongKeys.userId.rawValue)}
    }
    var songLyrics:String!
    {
        get{ return stringForKey(key: SongKeys.songLyrics.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songLyrics.rawValue)}
    }
    
    var createdDate:Int64!
    {
        get{ return int64ForKey(key: SongKeys.createdDate.rawValue)}
        set{setValue(newValue, forKey: SongKeys.createdDate.rawValue)}
    }
    var modifiedDate:Int64!
    {
        get{ return int64ForKey(key: SongKeys.modifiedDate.rawValue)}
        set{setValue(newValue, forKey: SongKeys.modifiedDate.rawValue)}
    }
    
    var SongTitle:String!
    {
        get{ return stringForKey(key: SongKeys.SongTitle.rawValue)}
        set{setValue(newValue, forKey: SongKeys.SongTitle.rawValue)}
    }
    var BPM:String!
    {
        get{ return stringForKey(key: SongKeys.BPM.rawValue)}
        set{setValue(newValue, forKey: SongKeys.BPM.rawValue)}
    }
    
    var songnotifications:[String:Bool]!
    {
        get{ return boolDictForKey(key: SongKeys.songnotifications.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songnotifications.rawValue)}
    }
    var songNotifications2:[String:Bool]!
    {
        get{ return boolDictForKey(key: SongKeys.songNotifications2.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songNotifications2.rawValue)}
    }

    var songContributers:[String:String]!
    {
        get{ return stringDictForKey(key: SongKeys.songContributers.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songContributers.rawValue)}
    }
    
    var songBrainStrom:[String:String]!
    {
        get{ return stringDictForKey(key: SongKeys.songBrainStrom.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songBrainStrom.rawValue)}
    }
    var songUserColors:[String:String]!
    {
        get{ return stringDictForKey(key: SongKeys.songUserColors.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songUserColors.rawValue)}
    }
    var songKey:String!
    {
        get{ return stringForKey(key: SongKeys.SongKey.rawValue)}
        set{setValue(newValue, forKey: SongKeys.SongKey.rawValue)}
    }
    var songNotes:String!
    {
        get{ return stringForKey(key: SongKeys.songNotes.rawValue)}
        set{setValue(newValue, forKey: SongKeys.songNotes.rawValue)}
    }
    var chatId:String!
    {
        get{ return stringForKey(key: SongKeys.chatId.rawValue)}
        set{setValue(newValue, forKey: SongKeys.chatId.rawValue)}
    }
    var isTyping:Bool!
    {
        get{ return boolForKey(key: SongKeys.isTyping.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: SongKeys.isTyping.rawValue)}
    }
 
}

enum songNotificationKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case titleNotification = "titleNotification"
    case status = "status"
    case timestamp = "timestamp"
    
}
class songNotifcationModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: songNotificationKeys.userId.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.userId.rawValue)}
    }
    var titleNotification:String!
    {
        get{ return stringForKey(key: songNotificationKeys.titleNotification.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.titleNotification.rawValue)}
    }
    var status:Bool!
    {
        get{ return boolForKey(key: songNotificationKeys.status.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: songNotificationKeys.status.rawValue)}
    }
    
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: songNotificationKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: songNotificationKeys.timestamp.rawValue)}
    }
}

enum ReportModelKeys:String {
    
    //Must variable
    case userId = "userId"
    case reportDetail = "reportDetail"
    case reportType = "reportType"
    case reportTime = "reportTime"
    case reportedUserID = "reportedUserID"


}
class ReportModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: ReportModelKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.userId.rawValue)}
    }
    var reportedUserID:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportedUserID.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportedUserID.rawValue)}
    }
    var reportDetail:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportDetail.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportDetail.rawValue)}
    }
    var reportType:String!
    {
        get{ return stringForKey(key: ReportModelKeys.reportType.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportType.rawValue)}
    }
    
    var reportTime:Int64!
    {
        get{ return int64ForKey(key: ReportModelKeys.reportTime.rawValue)}
        set{setValue(newValue, forKey: ReportModelKeys.reportTime.rawValue)}
    }
}


enum NotifcationKeys:String {
    
    //Must variable
    case UserID = "UserID"
    case content = "content"
    case extradata = "extradata"
    case type = "type"
    case modledata = "modledata"


}
class NotifcationModelData: GenericDictionary {

    var UserID:String!
    {
        get{ return stringForKey(key: NotifcationKeys.UserID.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.UserID.rawValue)}
    }
    var content:String!
    {
        get{ return stringForKey(key: NotifcationKeys.content.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.content.rawValue)}
    }
    var extradata:[String:Any]!
    {
        get{ return dictForKey(key: NotifcationKeys.extradata.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.extradata.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: NotifcationKeys.type.rawValue)}
        set{setValue(newValue, forKey: NotifcationKeys.type.rawValue)}
    }

}


class NotificationDataModel2{
    
    var MainData:NotifcationModelData!
    var extraData:extraModel!
    var userData:UserModel!

    init(MainData:NotifcationModelData? = nil , extraData:extraModel? = nil,userData:UserModel? = nil) {
        self.MainData = MainData
        self.extraData = extraData
        self.userData = userData
    }
    
}

class DatesImages: GenericDictionary {

    var imageUrl:String!
    {
        get{ return stringForKey(key: "imageUrl")}
        set{setValue(newValue, forKey: "imageUrl")}
    }

}
class NotesImages: GenericDictionary {

    var imageUrl:String!
    {
        get{ return stringForKey(key: "imageUrl")}
        set{setValue(newValue, forKey: "imageUrl")}
    }

}



enum extraModelKey:String {
    
    //Must variable
    case isread = "isread"
    case notificationAddedBy = "notificationAddedBy"
    case notificationTime = "notificationTime"
    case songId = "songId"
    case songTitle = "songTitle"
    case status = "status"
    case titleNotification = "titleNotification"

}

class extraModel: GenericDictionary {

    var isread:Bool!
    {
        get{ return boolForKey(key: extraModelKey.isread.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: extraModelKey.isread.rawValue)}
    }
    var status:Bool!
    {
        get{ return boolForKey(key: extraModelKey.status.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: extraModelKey.status.rawValue)}
    }
    var notificationAddedBy:String!
    {
        get{ return stringForKey(key: extraModelKey.notificationAddedBy.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.notificationAddedBy.rawValue)}
    }
    var notificationTime:Int64!
    {
        get{ return int64ForKey(key: extraModelKey.notificationTime.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.notificationTime.rawValue)}
    }
    
    var titleNotification:String!
    {
        get{ return stringForKey(key: extraModelKey.titleNotification.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.titleNotification.rawValue)}
    }
    
    var songTitle:String!
    {
        get{ return stringForKey(key: extraModelKey.songTitle.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.songTitle.rawValue)}
    }
    var songId:String!
    {
        get{ return stringForKey(key: extraModelKey.songId.rawValue)}
        set{setValue(newValue, forKey: extraModelKey.songId.rawValue)}
    }

}


enum WritersSongKeys:String {
    
    //Must variable
    case userId = "userId"
    case verseText = "verseText"
    case isBrainStrom = "isBrainStrom"
    case verseTitle = "verseTitle"
    case verseIndex = "verseIndex"
    case verseTime = "verseTime"


}
class WritersSongModel: GenericDictionary {

    var userId:String!
    {
        get{ return stringForKey(key: WritersSongKeys.userId.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.userId.rawValue)}
    }
    var verseText:String!
    {
        get{ return stringForKey(key: WritersSongKeys.verseText.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseText.rawValue)}
    }
    var verseTitle:String!
    {
        get{ return stringForKey(key: WritersSongKeys.verseTitle.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseTitle.rawValue)}
    }
    
    var verseTime:Int64!
    {
        get{ return int64ForKey(key: WritersSongKeys.verseTime.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseTime.rawValue)}
    }
    var verseIndex:Int64!
    {
        get{ return int64ForKey(key: WritersSongKeys.verseIndex.rawValue)}
        set{setValue(newValue, forKey: WritersSongKeys.verseIndex.rawValue)}
    }
    var isBrainStrom:Bool!
    {
        get{ return boolForKey(key: WritersSongKeys.isBrainStrom.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: WritersSongKeys.isBrainStrom.rawValue)}
    }
}



enum QuestionsKey:String {
    
    //Must variableCategory    case Category = "userId"
    case answer1 = "answer1"
    case answer2 = "answer2"
    case answer3 = "answer3"
    case answer4 = "answer4"
    case yourAnswer = "yourAnswer"
    case courseId = "courseId"
    case chapterId = "chapterId"
    case id = "id"
    case question = "question"
    case userAnswer = "userAnswer"
    case userAnswerOpt = "userAnswerOpt"


}
class QuestionsModel: GenericDictionary {

    var answer1:String!
    {
        get{ return stringForKey(key: QuestionsKey.answer1.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.answer1.rawValue)}
    }
    var answer2:String!
    {
        get{ return stringForKey(key: QuestionsKey.answer2.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.answer2.rawValue)}
    }
    var answer3:String!
    {
        get{ return stringForKey(key: QuestionsKey.answer3.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.answer3.rawValue)}
    }
    var answer4:String!
    {
        get{ return stringForKey(key: QuestionsKey.answer4.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.answer4.rawValue)}
    }
    
    var yourAnswer:String!
    {
        get{ return stringForKey(key: QuestionsKey.yourAnswer.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.yourAnswer.rawValue)}
    }
    var courseId:String!
    {
        get{ return stringForKey(key: QuestionsKey.courseId.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.courseId.rawValue)}
    }
    var chapterId:String!
    {
        get{ return stringForKey(key: QuestionsKey.chapterId.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.chapterId.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: QuestionsKey.id.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.id.rawValue)}
    }
    var question:String!
    {
        get{ return stringForKey(key: QuestionsKey.question.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.question.rawValue)}
    }
    var userAnswer:[String:Bool]!
    {
        get{ return boolDictForKey(key: QuestionsKey.userAnswer.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.userAnswer.rawValue)}
    }
    var userAnswerOpt:[String:String]!
    {
        get{ return stringDictForKey(key: QuestionsKey.userAnswerOpt.rawValue)}
        set{setValue(newValue, forKey: QuestionsKey.userAnswerOpt.rawValue)}
    }
}

enum NotesKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case type = "type"
    case title = "title"
    case description = "description"
    case imageThumnail = "imageThumnail"
    case rating = "rating"
    case recommendation = "recommendation"
    case timestamp = "timestamp"
}


class NotesModel: GenericDictionary {
    
    
    var userId:String!
    {
        get{ return stringForKey(key: NotesKeys.userId.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.userId.rawValue)}
    }
    
    var title:String!
    {
        get{ return stringForKey(key: NotesKeys.title.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.title.rawValue)}
    }
    
    var descriptionDate:String!
    {
        get{ return stringForKey(key: NotesKeys.description.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.description.rawValue)}
    }
    
    var imageThumnail:String!
    {
        get{ return stringForKey(key: NotesKeys.imageThumnail.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.imageThumnail.rawValue)}
    }
    var timestamp:Int64!
    {
        get{ return int64ForKey(key: NotesKeys.timestamp.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.timestamp.rawValue)}
    }

    var type:String!
    {
        get{ return stringForKey(key: NotesKeys.type.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.type.rawValue)}
    }
    
    var rating:Double!
    {
        get{ return doubleForKey(key: NotesKeys.rating.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.rating.rawValue)}
    }

    var recommendation:String!
    {
        get{ return stringForKey(key: NotesKeys.recommendation.rawValue)}
        set{setValue(newValue, forKey: NotesKeys.recommendation.rawValue)}
    }

    
}

enum DateKeys:String {
    
    //Must variable
    
    case userId = "userId"
    case type = "type"
    case title = "title"
    case description = "description"
    case imageThumnail = "imageThumnail"
    case rating = "rating"
    case cost = "cost"
    case location = "location"
    case recommendation = "recommendation"
    case scheduleDate = "scheduleDate"
    case scheldueTime = "scheldueTime"
    case dateLat = "dateLat"
    case timeStamp = "timeStamp"
    case dateLng = "dateLng"

}

class DateModel: GenericDictionary {
    
    
    var userId:String!
    {
        get{ return stringForKey(key: DateKeys.userId.rawValue)}
        set{setValue(newValue, forKey: DateKeys.userId.rawValue)}
    }
    
    var title:String!
    {
        get{ return stringForKey(key: DateKeys.title.rawValue)}
        set{setValue(newValue, forKey: DateKeys.title.rawValue)}
    }
    
    var descriptionDate:String!
    {
        get{ return stringForKey(key: DateKeys.description.rawValue)}
        set{setValue(newValue, forKey: DateKeys.description.rawValue)}
    }
    var imageThumnail:String!
    {
        get{ return stringForKey(key: DateKeys.imageThumnail.rawValue)}
        set{setValue(newValue, forKey: DateKeys.imageThumnail.rawValue)}
    }
    var cost:String!
    {
        get{ return stringForKey(key: DateKeys.cost.rawValue)}
        set{setValue(newValue, forKey: DateKeys.cost.rawValue)}
    }
    var timeStamp:Int64!
    {
        get{ return int64ForKey(key: DateKeys.timeStamp.rawValue)}
        set{setValue(newValue, forKey: DateKeys.timeStamp.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: DateKeys.type.rawValue)}
        set{setValue(newValue, forKey: DateKeys.type.rawValue)}
    }
    
    var rating:Double!
    {
        get{ return doubleForKey(key: DateKeys.rating.rawValue)}
        set{setValue(newValue, forKey: DateKeys.rating.rawValue)}
    }
    var location:String!
    {
        get{ return stringForKey(key: DateKeys.location.rawValue)}
        set{setValue(newValue, forKey: DateKeys.location.rawValue)}
    }
    var recommendation:String!
    {
        get{ return stringForKey(key: DateKeys.recommendation.rawValue)}
        set{setValue(newValue, forKey: DateKeys.recommendation.rawValue)}
    }
    
    var scheldueTime:Int64!
    {
        get{ return int64ForKey(key: DateKeys.scheldueTime.rawValue)}
        set{setValue(newValue, forKey: DateKeys.scheldueTime.rawValue)}
    }
    
    var scheduleDate:Int64!
    {
        get{ return int64ForKey(key: DateKeys.scheduleDate.rawValue)}
        set{setValue(newValue, forKey: DateKeys.scheduleDate.rawValue)}
    }
    
    
    var dateLat:Double!
    {
        get{ return doubleForKey(key: DateKeys.dateLat.rawValue)}
        set{setValue(newValue, forKey: DateKeys.dateLat.rawValue)}
    }
    
    var dateLng:Double!
    {
        get{ return doubleForKey(key: DateKeys.dateLng.rawValue)}
        set{setValue(newValue, forKey: DateKeys.dateLng.rawValue)}
    }
    
    
}




enum ProductKeys:String {
    
    //Must variable
    case category = "category"
    case description = "description"
    case videoLink = "videoLink"
    case thumbnailImage = "thumbnailImage"
    case playedBy = "playedBy"
    case commentUser = "commentUser"
    case name = "name"
    case rate = "rate"
    case status = "status"
    case userId = "userId"
    case endDate = "endDate"
    case publishDate = "publishDate"
    case userName = "userName"
    case userImage = "userImage"
    case reactUser = "reactUser"
    case proLat = "proLat"
    case proLng = "proLng"
    case userPublic = "userPublic"

}
class ProductModel: GenericDictionary {

    
    var userId:String!
    {
        get{ return stringForKey(key: ProductKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.userId.rawValue)}
    }
    var descriptions:String!
    {
        get{ return stringForKey(key: ProductKeys.description.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.description.rawValue)}
    }
    var thumbnailImage:String!
    {
        get{ return stringForKey(key: ProductKeys.thumbnailImage.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.thumbnailImage.rawValue)}
    }
    
    var videoLink:String!
    {
        get{ return stringForKey(key: ProductKeys.videoLink.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.videoLink.rawValue)}
    }
    var playedBy:[String:Bool]!
    {
        get{ return boolDictForKey(key: ProductKeys.playedBy.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.playedBy.rawValue)}
    }
    var commentUser:[String:Bool]!
    {
        get{ return boolDictForKey(key: ProductKeys.commentUser.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.commentUser.rawValue)}
    }
    
    var reactUser:[String:Bool]!
    {
        get{ return boolDictForKey(key: ProductKeys.reactUser.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.reactUser.rawValue)}
    }
    var publishDate:Int64!
    {
        get{ return int64ForKey(key: ProductKeys.publishDate.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.publishDate.rawValue)}
    }
    var status:String!
    {
        get{ return stringForKey(key: ProductKeys.status.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.status.rawValue)}
    }
    var userName:String!
    {
        get{ return stringForKey(key: ProductKeys.userName.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.userName.rawValue)}
    }
    var userImage:String!
    {
        get{ return stringForKey(key: ProductKeys.userImage.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.userImage.rawValue)}
    }
    var userPublic:Bool!
    {
        get{ return boolForKey(key: ProductKeys.userPublic.rawValue, defaultValue: true)}
        set{setValue(newValue, forKey: ProductKeys.userPublic.rawValue)}
    }
    
    var proLat:Double!
    {
        get{ return doubleForKey(key: ProductKeys.proLat.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.proLat.rawValue)}
    }
    
    var proLng:Double!
    {
        get{ return doubleForKey(key: ProductKeys.proLng.rawValue)}
        set{setValue(newValue, forKey: ProductKeys.proLng.rawValue)}
    }
    
    
}


enum instumentsKeys:String {
    
    //Must variable
    case createdDate = "createdDate"
    case imageUrl = "imageUrl"
    case name = "name"
    case id = "id"
    case isSelect = "isSelect"
    
}

class InstrumetnsListModel: GenericDictionary {

    
    var createdDate:String!
    {
        get{ return stringForKey(key: instumentsKeys.createdDate.rawValue)}
        set{setValue(newValue, forKey: instumentsKeys.createdDate.rawValue)}
    }
    
    var imageUrl:String!
    {
        get{ return stringForKey(key: instumentsKeys.imageUrl.rawValue)}
        set{setValue(newValue, forKey: instumentsKeys.imageUrl.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: instumentsKeys.name.rawValue)}
        set{setValue(newValue, forKey: instumentsKeys.name.rawValue)}
    }
    
    var id:String!
    {
        get{ return stringForKey(key: instumentsKeys.id.rawValue)}
        set{setValue(newValue, forKey: instumentsKeys.id.rawValue)}
    }
    
    var isSelect:Bool!
    {
        get{ return boolForKey(key: instumentsKeys.isSelect.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: instumentsKeys.isSelect.rawValue)}
    }

}


enum BannerKeys:String {
    
    //Must variable
    
    case imageUrl = "imageUrl"
    
    
}


class BannerModel: GenericDictionary {

    
    var imageUrl:String!
    {
        get{ return stringForKey(key: BannerKeys.imageUrl.rawValue)}
        set{setValue(newValue, forKey: BannerKeys.imageUrl.rawValue)}
    }
    var isSelect:Bool!
    {
        get{ return boolForKey(key: instumentsKeys.isSelect.rawValue, defaultValue: false)}
        set{setValue(newValue, forKey: instumentsKeys.isSelect.rawValue)}
    }

}


enum ScheduleKeys:String {
    
    //Must variable
    
    case address = "address"
    case lat = "lat"
    case long = "long"
    case userId = "userId"
    case time = "time"
    
}


class ScheduleModel: GenericDictionary {

    
    var userId:String!
    {
        get{ return stringForKey(key: ScheduleKeys.userId.rawValue)}
        set{setValue(newValue, forKey: ScheduleKeys.userId.rawValue)}
    }
    
    var address:String!
    {
        get{ return stringForKey(key: ScheduleKeys.address.rawValue)}
        set{setValue(newValue, forKey: ScheduleKeys.address.rawValue)}
    }
    
    var lat:Double!
    {
        get{ return doubleForKey(key: ScheduleKeys.lat.rawValue)}
        set{setValue(newValue, forKey: ScheduleKeys.lat.rawValue)}
    }
    
    var long:Double!
    {
        get{ return doubleForKey(key: ScheduleKeys.long.rawValue)}
        set{setValue(newValue, forKey: ScheduleKeys.long.rawValue)}
    }
    
    var time:Int64!
    {
        get{ return int64ForKey(key: ScheduleKeys.time.rawValue)}
        set{setValue(newValue, forKey: ScheduleKeys.time.rawValue)}
    }
    
    var userImage:String!
    {
        get{ return stringForKey(key: "userImage")}
        set{setValue(newValue, forKey: "userImage")}
    }
    
    var userName:String!
    {
        get{ return stringForKey(key: "userName")}
        set{setValue(newValue, forKey: "userName")}
    }
    
}


class GalleryModel{
    var image:String!
    var isSelected:Bool!
    init(image: String? = nil, isSelected: Bool = false) {
        self.image = image
        self.isSelected = isSelected
    }
}
enum ReviweKey:String {
    
    //Must variable
    case createdDate = "createdDate"
    case courseId = "courseId"
    case teamId = "teamId"
    case userId = "userId"
    case details = "details"
    

}

class ReviewModel: GenericDictionary {

    
    var createdDate:Int64!
    {
        get{ return int64ForKey(key: ReviweKey.createdDate.rawValue)}
        set{setValue(newValue, forKey: ReviweKey.createdDate.rawValue)}
    }
    
    var courseId:String!
    {
        get{ return stringForKey(key: ReviweKey.courseId.rawValue)}
        set{setValue(newValue, forKey: ReviweKey.courseId.rawValue)}
    }
    
    var teamId:String!
    {
        get{ return stringForKey(key: ReviweKey.teamId.rawValue)}
        set{setValue(newValue, forKey: ReviweKey.teamId.rawValue)}
    }
    
    var userId:String!
    {
        get{ return stringForKey(key: ReviweKey.userId.rawValue)}
        set{setValue(newValue, forKey: ReviweKey.userId.rawValue)}
    }
    
    var details:String!
    {
        get{ return stringForKey(key: ReviweKey.details.rawValue)}
        set{setValue(newValue, forKey: ReviweKey.details.rawValue)}
    }

}
