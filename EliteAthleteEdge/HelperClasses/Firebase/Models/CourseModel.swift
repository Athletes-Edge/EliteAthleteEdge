//
//  CourseModel.swift
//  athletes
//
//  Created by asim on 02/10/2024.
//

enum CourseModelKey: String {
    case id = "id"
    case Imageurl = "Imageurl"
    case allowedFor = "allowedFor"
    case allowedTeams = "allowedTeams"
    case categoryId = "categoryId"
    case createdDate = "createdDate"
    case description = "description"
    case imageUrl = "imageUrl"
    case isPro = "isPro"
    case rating = "rating"
    case title = "title"
    case totalTime = "totalTime"
    case isSaved = "isSaved"
    case isCompleted = "isCompleted"
    case contentType = "contentType"
    case badgeAvailable = "badgeAvailable"
    case courseCompletionUser = "courseCompletionUser"
    case requiredCourse = "requiredCourse"
}

class CourseModel: GenericDictionary {
    
    var isselect:Bool! = false
    var title:String!
    {
        get{ return stringForKey(key: CourseModelKey.title.rawValue)}
        set{setValue(newValue, forKey: CourseModelKey.title.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: CourseModelKey.id.rawValue)}
        set{setValue(newValue, forKey: CourseModelKey.id.rawValue)}
    }
    var dscription:String!
    {
        get{ return stringForKey(key: CourseModelKey.description.rawValue)}
        set{setValue(newValue, forKey: CourseModelKey.description.rawValue)}
    }
    var Imageurl:String!
    {
        get{ return stringForKey(key: CourseModelKey.Imageurl.rawValue)}
        set{setValue(newValue, forKey: CourseModelKey.Imageurl.rawValue)}
    }
    var allowedFor: String! {
        get{ return stringForKey(key: CourseModelKey.allowedFor.rawValue)}
        set{setValue(newValue, forKey: CourseModelKey.allowedFor.rawValue)}
    }
    var categoryId: [String]! {
        get {return stringArrayForKey(key: CourseModelKey.categoryId.rawValue)}
        set {setValue(newValue, forKey: CourseModelKey.categoryId.rawValue)}
    }
    var requiredCourse: [String]! {
        get {return stringArrayForKey(key: CourseModelKey.requiredCourse.rawValue)}
        set {setValue(newValue, forKey: CourseModelKey.requiredCourse.rawValue)}
    }
    var createdDate: Int64! {
        get {return int64ForKey(key: CourseModelKey.createdDate.rawValue)}
        set {setValue(newValue, forKey: CourseModelKey.createdDate.rawValue)}
    }
    
    var allowedTeams: [String]! {
        get {return stringArrayForKey(key: CourseModelKey.allowedTeams.rawValue)}
        set {setValue(newValue, forKey: CourseModelKey.allowedTeams.rawValue)}
    }
    
    var imageUrl: String! {
        get { return stringForKey(key: CourseModelKey.imageUrl.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.imageUrl.rawValue)}
    }
    var isPro: Bool! {
        get { return boolForKey(key: CourseModelKey.isPro.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.isPro.rawValue)}
    }
    var badgeAvailable: Bool! {
        get { return boolForKey(key: CourseModelKey.badgeAvailable.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.badgeAvailable.rawValue)}
    }
    var rating: Double! {
        get { return doubleForKey(key: CourseModelKey.rating.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.rating.rawValue)}
    }
    var totalTime: Double! {
        get { return doubleForKey(key: CourseModelKey.totalTime.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.totalTime.rawValue)}
    }
    
    var isSaved: [String:Bool]! {
        get { return boolDictForKey(key: CourseModelKey.isSaved.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.isSaved.rawValue)}
    }
    var isCompleted: [String:Bool]! {
        get { return boolDictForKey(key: CourseModelKey.isCompleted.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.isCompleted.rawValue)}
    }
    var courseCompletionUser: [String:String]! {
        get { return stringDictForKey(key: CourseModelKey.courseCompletionUser.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.courseCompletionUser.rawValue)}
    }
    var contentType: String! {
        get { return stringForKey(key: CourseModelKey.contentType.rawValue)}
        set { setValue(newValue, forKey: CourseModelKey.contentType.rawValue)}
    }
    //var coachesData: CoachesModel!
    var courseOverviewData:[CourseOverviewModel]! = []
    var courseQuizData:[QuestionsModel]! = []
    var requiredCourseData:[CourseModel]! = []
}


enum CoachesModelKey: String {
    case id = "id"
    case name = "name"
    case profileImage = "profileImage"
    case averageRating = "averageRating"
    case addedAt = "addedAt"
    case coaches = "coaches"
    case description = "description"
    case duration = "duration"
    case isFree = "isFree"
    case isMarked = "isMarked"
    case rating = "rating"
}

class CoachesModel: GenericDictionary {
    var name:String!
    {
        get{ return stringForKey(key: CoachesModelKey.name.rawValue)}
        set{setValue(newValue, forKey: CoachesModelKey.name.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: CoachesModelKey.id.rawValue)}
        set{setValue(newValue, forKey: CoachesModelKey.id.rawValue)}
    }
    var profileImage:String!
    {
        get{ return stringForKey(key: CoachesModelKey.profileImage.rawValue)}
        set{setValue(newValue, forKey: CoachesModelKey.profileImage.rawValue)}
    }
    var isFree: Bool! {
        get{ return boolForKey(key: CoachesModelKey.isFree.rawValue)}
        set{setValue(newValue, forKey: CoachesModelKey.isFree.rawValue)}
    }
    var averageRating: Double! {
        get {return doubleForKey(key: CoachesModelKey.averageRating.rawValue)}
        set {setValue(newValue, forKey: CoachesModelKey.averageRating.rawValue)}
    }
    var duration: Int64! {
        get {return int64ForKey(key: CoachesModelKey.duration.rawValue)}
        set {setValue(newValue, forKey: CoachesModelKey.duration.rawValue)}
    }
    var addedAt: Int64! {
        get {return int64ForKey(key: CoachesModelKey.addedAt.rawValue)}
        set {setValue(newValue, forKey: CoachesModelKey.addedAt.rawValue)}
    }
    
    var isMarked: [String: Any] {
        get {return dictForKey(key: CoachesModelKey.addedAt.rawValue)}
        set {setValue(newValue, forKey: CoachesModelKey.addedAt.rawValue)}
    }
    
    var coaches: [String]! {
        get { return stringArrayForKey(key: CoachesModelKey.coaches.rawValue)}
        set { setValue(newValue, forKey: CoachesModelKey.coaches.rawValue)}
    }
}

enum CategoryModelKey: String {
    case id = "id"
    case title = "title"
    case icon = "icon"
    case unselected = "unSelected"
    case addedAt = "addedAt"
    case coaches = "coaches"
    case description = "description"
    case duration = "duration"
    case isFree = "isFree"
    case isMarked = "isMarked"
    case rating = "rating"
}

class CategoryModel: GenericDictionary {
    var title:String!
    {
        get{ return stringForKey(key: CategoryModelKey.title.rawValue)}
        set{setValue(newValue, forKey: CategoryModelKey.title.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: CategoryModelKey.id.rawValue)}
        set{setValue(newValue, forKey: CategoryModelKey.id.rawValue)}
    }
    var icon:String!
    {
        get{ return stringForKey(key: CategoryModelKey.icon.rawValue)}
        set{setValue(newValue, forKey: CategoryModelKey.icon.rawValue)}
    }
    var isselect:Bool! = false
    
}


enum QuestionModelKey: String {
    case question = "question"
    case answer = "answer"
    case correctAnswer = "correctAnswer"
}

class QuestionModel: GenericDictionary {
    var answer:[String]!
    {
        get{ return stringArrayForKey(key: QuestionModelKey.answer.rawValue)}
        set{setValue(newValue, forKey: QuestionModelKey.answer.rawValue)}
    }
    var correctAnswer:Int!
    {
        get{ return intForKey(key: QuestionModelKey.correctAnswer.rawValue)}
        set{setValue(newValue, forKey: QuestionModelKey.correctAnswer.rawValue)}
    }
    var question:String!
    {
        get{ return stringForKey(key: QuestionModelKey.question.rawValue)}
        set{setValue(newValue, forKey: QuestionModelKey.question.rawValue)}
    }
}

enum CourseOverviewModelKey: String {
    case id = "id"
    case courseId = "courseId"
    case description = "description"
    case duration = "duration"
    case thumbnailUrl = "thumbnailUrl"
    case title = "title"
    case videoUrl = "videoUrl"
    case progress = "progress"
    case watchHour = "watchHour"
    case isRequired = "isRequired"
    case requiredProgress = "requiredProgress"
}

class CourseOverviewModel: GenericDictionary {
    var id:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.id.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.id.rawValue)}
    }
    var courseId:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.courseId.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.courseId.rawValue)}
    }
    var descriptions:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.description.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.description.rawValue)}
    }
    var duration:Double!
    {
        get{ return doubleForKey(key: CourseOverviewModelKey.duration.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.duration.rawValue)}
    }
    var thumbnailUrl:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.thumbnailUrl.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.thumbnailUrl.rawValue)}
    }
    var title:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.title.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.title.rawValue)}
    }
    var videoUrl:String!
    {
        get{ return stringForKey(key: CourseOverviewModelKey.videoUrl.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.videoUrl.rawValue)}
    }
    var isRequired:Bool!
    {
        get{ return boolForKey(key: CourseOverviewModelKey.isRequired.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.isRequired.rawValue)}
    }
    var progress:[String:Double]!
    {
        get{ return doubleDictForKey(key: CourseOverviewModelKey.progress.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.progress.rawValue)}
    }
    var watchHour:[String:Double]!
    {
        get{ return doubleDictForKey(key: CourseOverviewModelKey.watchHour.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.watchHour.rawValue)}
    }
    var requiredProgress:[String:String]!
    {
        get{ return stringDictForKey(key: CourseOverviewModelKey.requiredProgress.rawValue)}
        set{setValue(newValue, forKey: CourseOverviewModelKey.requiredProgress.rawValue)}
    }
}


enum CourseStatisticKey: String {
    case id = "id"
    case courseId = "courseId"
    case chapterId = "chapterId"
    case progress = "progress"
    case watchHours = "watchHours"
    case date = "date"
    case userId = "userId"
    case weekDay = "weekDay"
    case day = "day"
    case month = "month"
    case year = "year"
}

class CourseStatisticModel: GenericDictionary {
    var id:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.id.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.id.rawValue)}
    }
    var courseId:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.courseId.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.courseId.rawValue)}
    }
    var chapterId:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.chapterId.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.chapterId.rawValue)}
    }
    var userId:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.userId.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.userId.rawValue)}
    }
    var progress:Double!
    {
        get{ return doubleForKey(key: CourseStatisticKey.progress.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.progress.rawValue)}
    }
    var watchHours:Double!
    {
        get{ return doubleForKey(key: CourseStatisticKey.watchHours.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.watchHours.rawValue)}
    }
    
    var date:Int64!
    {
        get{ return int64ForKey(key: CourseStatisticKey.date.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.date.rawValue)}
    }
    var weekDay:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.weekDay.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.weekDay.rawValue)}
    }
    var day:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.day.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.day.rawValue)}
    }
    var month:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.month.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.month.rawValue)}
    }
    var year:String!
    {
        get{ return stringForKey(key: CourseStatisticKey.year.rawValue)}
        set{setValue(newValue, forKey: CourseStatisticKey.year.rawValue)}
    }
    
}

enum InvitationKey: String {
    case email = "email"
    case name = "name"
    case id = "id"
    case teamId = "teamId"
    case type = "type"
   
}

class InvitationModel: GenericDictionary {
    var email:String!
    {
        get{ return stringForKey(key: InvitationKey.email.rawValue)}
        set{setValue(newValue, forKey: InvitationKey.email.rawValue)}
    }
    
    var name:String!
    {
        get{ return stringForKey(key: InvitationKey.name.rawValue)}
        set{setValue(newValue, forKey: InvitationKey.name.rawValue)}
    }
    var id:String!
    {
        get{ return stringForKey(key: InvitationKey.id.rawValue)}
        set{setValue(newValue, forKey: InvitationKey.id.rawValue)}
    }
    var teamId:String!
    {
        get{ return stringForKey(key: InvitationKey.teamId.rawValue)}
        set{setValue(newValue, forKey: InvitationKey.teamId.rawValue)}
    }
    var type:String!
    {
        get{ return stringForKey(key: InvitationKey.type.rawValue)}
        set{setValue(newValue, forKey: InvitationKey.type.rawValue)}
    }
}
enum BadgeModelKey: String {
    case id = "id"
    case completeUsers = "completeUsers"
    case courses = "courses"
    case icon = "icon"
    case title = "title"
}

class BadgeModel: GenericDictionary {
    var id:String!
    {
        get{ return stringForKey(key: BadgeModelKey.id.rawValue)}
        set{setValue(newValue, forKey: BadgeModelKey.id.rawValue)}
    }
    var icon:String!
    {
        get{ return stringForKey(key: BadgeModelKey.icon.rawValue)}
        set{setValue(newValue, forKey: BadgeModelKey.icon.rawValue)}
    }
    var title:String!
    {
        get{ return stringForKey(key: BadgeModelKey.title.rawValue)}
        set{setValue(newValue, forKey: BadgeModelKey.title.rawValue)}
    }
    var courses:[String]!
    {
        get{ return stringArrayForKey(key: BadgeModelKey.courses.rawValue)}
        set{setValue(newValue, forKey: BadgeModelKey.courses.rawValue)}
    }
    var completeUsers:[String]!
    {
        get{ return stringArrayForKey(key: BadgeModelKey.completeUsers.rawValue)}
        set{setValue(newValue, forKey: BadgeModelKey.completeUsers.rawValue)}
    }
    
}
