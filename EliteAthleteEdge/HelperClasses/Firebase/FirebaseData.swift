//
//  FirebaseData.swift
//  MyReferral
//
//  Created by vision on 14/05/20.
//  Copyright © 2020 vision. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseMessaging
import FirebaseAuth

class FirebaseData{
    
    
//    class func createPhoneUser(phone: String? = nil, credential: String? = nil,codes:String? = nil, completion:@escaping (_ user:UserModel? ,_ code:String?,_ error:Error?) -> ()) {
//        if let pho = phone{
//            PhoneAuthProvider.provider().verifyPhoneNumber(pho, uiDelegate: nil) { code, error in
//                if error != nil{
//                    completion(nil,nil,error)
//                    return
//                }
//                completion(nil,code,nil)
//            }
//        }
//        else if let cred = credential,let code = codes{
//            let credential = PhoneAuthProvider.provider().credential(
//              withVerificationID: cred,
//              verificationCode: code
//            )
//            Auth.auth().signIn(with: credential) { user, error in
//                if error != nil{
//                    completion(nil,nil,error)
//                    return
//                }
//                self.getUserData(uid: (user?.user.uid)!) { error, users in
//                    if error != nil{
//                        completion(nil,nil,error)
//                        return
//                    }
//                    if users?.username == nil{
//                        self.saveUserData(uid: (user?.user.uid)!, userData: UserModel()) { error in
//                            if error != nil{
//                                completion(nil,nil,error)
//                                return
//                            }
//                            completion(nil,nil,nil)
//                        }
//                    }
//                    else{
//                        completion(users,nil,nil)
//                    }
//                }
//            }
//        }
//    }
    class func createLinkPhoneUser(phone: String? = nil, credential: String? = nil,codes:String? = nil,userdata:Any? = nil, completion:@escaping (_ user:UserModel? ,_ code:String?,_ error:Error?) -> ()) {
        if let pho = phone{
            PhoneAuthProvider.provider().verifyPhoneNumber(pho, uiDelegate: nil) { code, error in
                if error != nil{
                    completion(nil,nil,error)
                    return
                }
                completion(nil,code,nil)
            }
        }
        else if let cred = credential,let code = codes{
            let credential = PhoneAuthProvider.provider().credential(
              withVerificationID: cred,
              verificationCode: code
            )
            Auth.auth().currentUser?.link(with: credential){
                user, error in
                if error != nil{
                    Auth.auth().currentUser?.delete(){
                        error in
                        completion(nil,nil,error)
                        return
                    }
                    
                }
                else{
                    
                    if let userdataa = userdata{
                        if let userid = user?.user.uid{
                            self.saveUserData(uid: userid, userData: userdataa) { error in
                                if error != nil{
                                    completion(nil,nil,error)
                                    return
                                }
                                completion(nil,nil,nil)
                            }
                        }
                        else{
                            
                            Auth.auth().currentUser?.delete(){
                                error in
                                completion(nil,nil,error)
                                return
                            }
                        }
                    }
                    else{
                        completion(nil,nil,nil)
                    }
                }
                
            }
        }
    }
    class func createUserData(email: String, password: String, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        
        db.createUser(withEmail: email, password: password, completion: completion)
        
    }
    class func loginAnonymusUserData( completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        db.signInAnonymously(completion: completion)
        
    }
    class func deleteAccount(uid:String,completion:@escaping (_ error:Error?) -> ()){
        
        var mAuth = Auth.auth()
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(uid).delete { error in
            if let error = error{
                completion(error)

            }
            else{
                mAuth.currentUser?.delete(completion: { error in
                    if let error = error{
                        
                        completion(error)
                    }
                    else{
                        
                        completion(nil)

                    }
                })
            }
        }
    }
    class func logoutUserData(_ completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        do {
            try db.signOut()
        completion(nil)
        }
        catch let error{
        completion(error)
        }
    }
    
    class func deleteAnonymusUserData( completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth().currentUser
        db?.delete(completion: completion)
        
    }
    class func loginUserData(email: String, password: String, completion:@escaping (_ result:AuthDataResult?,_ error:Error?) -> ()) {
        let db = Auth.auth()
        
        db.signIn(withEmail: email, password: password){
            result,error in
            if let error = error as? NSError{
                switch error.code{
                case AuthErrorCode.wrongPassword.rawValue,AuthErrorCode.internalError.rawValue:
                    completion(nil,NSError(domain: "Wrong Password", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Wrong Password", comment: "")]))
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(nil,NSError(domain: "Wrong Email", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Wrong Email", comment: "")]))
                case AuthErrorCode.missingEmail.rawValue:
                    completion(nil,NSError(domain: "Wrong Email", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Wrong Email", comment: "")]))
                case AuthErrorCode.weakPassword.rawValue:
                    completion(nil,NSError(domain: "Weak Password", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Weak Password", comment: "")]))
                case AuthErrorCode.userNotFound.rawValue:
                    completion(nil,NSError(domain: "Invalid User", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Invalid User", comment: "")]))
                case AuthErrorCode.invalidCredential.rawValue:
                    completion(nil,NSError(domain: "Invalid Email or Password", code: error.code, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Invalid Email or Password", comment: "")]))
                default:
                    completion(nil,error)
                }
            }
            else{
                completion(result,nil)
            }
        }
        
    }
    class func updateUserPassword(password: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth().currentUser
        db?.updatePassword(to: password, completion: completion)
        
    }
    class func updatetokenData(_ isTokn:Bool = false, completion:@escaping (_ error:Error?) -> ()) {
        let user = UserModel()
        if isTokn{
            user.token = Messaging.messaging().fcmToken
            //user.isOnline = true
        }
        else{
            user.token = ""
            //user.isOnline = false
        }
        
        updateUserData(getCurrentUserId(), dic: user, completion: completion)
        
    }
    class func forgotUserPassword(email: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Auth.auth()
        db.sendPasswordReset(withEmail: email, completion: completion)
        
    }
    
    class func saveUserData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        let dic: [String:Any]!
        if let user = userData as? UserModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_USERS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveUserFeedbackData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        let dic: [String:Any]!
        if let user = userData as? ReviewModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_COMMENTS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func saveSubscriptionData(uid: String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        let dic: [String:Any]!
        if let user = userData as? SubcribModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_SUBSCRIPTIONS).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func getTeamData(uid:String,completion:@escaping (_ error:Error?, _ teamsData: TeamModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_Teams).whereField(TeamModelKey.members.rawValue, arrayContains: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let teamModel = TeamModel(snap: queryDocument)!
                        completion(nil, teamModel)
                        return
                    })
                }
                else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]), nil)
                }
            }
        }
    }
    class func getTeamByNameData(name:String,completion:@escaping (_ error:Error?, _ teamsData: TeamModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_Teams).whereField(TeamModelKey.name.rawValue, isEqualTo: name).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let teamModel = TeamModel(snap: queryDocument)!
                        completion(nil, teamModel)
                        return
                    })
                }
                else{
                    completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]), nil)
                }
            }
        }
    }
    
    class func getCoachData(uid: String, completion:@escaping (_ error:Error?, _ userData: CoachesModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COACHES).document(uid).getDocument() { snap, error in
            
            if let err = error {
                completion(err,nil)
            }else {
                if let user = CoachesModel(snap: snap!) {
                     completion(nil, user)
                }
            }
        }
    }
  
    class func getAllTeamData( teams: [String], completion:@escaping (_ error:Error?, _ teamsData: [TeamModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_Teams).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[TeamModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let team = TeamModel(snap: queryDocument)!
                        teams.contains(team.docId) ? referralList.append(team) : ()
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getAllMyTeamData( uid: String, completion:@escaping (_ error:Error?, _ teamsData: [TeamModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_Teams).whereField(TeamModelKey.members.rawValue, arrayContains: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[TeamModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let team = TeamModel(snap: queryDocument)!
                        referralList.append(team)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    class func getAllCategoriesData(completion:@escaping (_ error:Error?, _ teamsData: [CategoryModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CATEGORIES).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[CategoryModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let team = CategoryModel(snap: queryDocument)!
                        referralList.append(team)
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    
    
//    class func getAllCourses(couches:[String],completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
//        let db = Firestore.firestore()
//        let dispatchGroup = DispatchGroup()
//        for couch in couches{
//            dispatchGroup.enter()
//            db.collection(Constant.NODE_COURSES).whereField(CourseModelKey.coachesId.rawValue, isEqualTo: couch).getDocuments { querySnapShot, error in
//                var referralList:[CourseModel] = []
//                dispatchGroup.leave()
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        referralList.append(CourseModel(snap: queryDocument)!)
//                    })
//                }
//                dispatchGroup.notify(queue: .main) {
//                    completion(nil,referralList)
//                }
//            }
//            
//            
//        }
//        
//
//    }
    class func getAllCourses(teamss:[String],completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_COURSES).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[CourseModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = CourseModel(snap: queryDocument)!
                        if course.allowedFor == Constant.All_Teams{
                            
                            referralList.append(course)
                            
                        }
                        else if course.allowedFor == Constant.Specific_Teams{
                            if let teams = course.allowedTeams,teams.contains(where: {teamss.contains($0)}){
                                
                                referralList.append(course)
                                
                            }
                        }
                        
                        
                    })
                    
                }
                completion(nil,referralList)
            }
        }
        

    }
    class func getAllCourses(teamid:String,completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COURSES).getDocuments() { (querySnapShot, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                let dispatchGroup = DispatchGroup()
                var referralList:[CourseModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = CourseModel(snap: queryDocument)!
                        if course.allowedFor == Constant.All_Teams{
                            dispatchGroup.enter()
                            referralList.append(course)
                            dispatchGroup.leave()
                        }
                        else if course.allowedFor == Constant.Specific_Teams{
                            if let teams = course.allowedTeams,teams.contains(where: {$0 == teamid}){
                                dispatchGroup.enter()
                                referralList.append(course)
                                dispatchGroup.leave()
                            }
                        }
                        
                        
                    })
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(nil,referralList)
                    }
                }
            }
        }
    }
    class func getAllLearnCoursesHours(uid:String,completion:@escaping (_ error:Error?, _ courses: [CourseStatisticModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COURSE_Statistic).whereField(CourseStatisticKey.userId.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[CourseStatisticModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = CourseStatisticModel(snap: queryDocument)!
                        referralList.append(course)
                        
                    })
                    
                }
                completion(nil,referralList)
            }
        }
    }
    class func getAllCommentsCours(uid:String,completion:@escaping (_ error:Error?, _ courses: [ReviewModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COMMENTS).whereField(ReviweKey.userId.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[ReviewModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = ReviewModel(snap: queryDocument)!
                        referralList.append(course)
                        
                    })
                    
                }
                completion(nil,referralList)
            }
        }
    }
    class func getAllCourses(completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COURSES).getDocuments() { (querySnapShot, error) in
            let dispatchGroup = DispatchGroup()
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[CourseModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatchGroup.enter()
                        let course = CourseModel(snap: queryDocument)!
                        referralList.append(course)
                        dispatchGroup.leave()
                        
                    })
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(nil,referralList)
                    }
                }
            }
        }
    }
    class func getAllCoursesAndOverview(teamss:[String],completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_COURSES).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                let dispatchGroup = DispatchGroup()
                var referralList:[CourseModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = CourseModel(snap: queryDocument)!
                        if course.allowedFor == Constant.All_Teams{
                            dispatchGroup.enter()
                            FirebaseData.getCourseOveriewData(courseID: course.docId) { error, overview in
                                course.courseOverviewData = overview
                                FirebaseData.getQuestionsList(course.docId) { error, userData in
                                    course.courseQuizData = userData
                                    referralList.append(course)
                                    dispatchGroup.leave()
                                }
                                
                            }
                            
                        }
                        else if course.allowedFor == Constant.Specific_Teams{
                            if let teams = course.allowedTeams,teams.contains(where: {teamss.contains($0)}){
                                dispatchGroup.enter()
                                FirebaseData.getCourseOveriewData(courseID: course.docId) { error, overview in
                                    course.courseOverviewData = overview
                                    FirebaseData.getQuestionsList(course.docId) { error, userData in
                                        course.courseQuizData = userData
                                        referralList.append(course)
                                        dispatchGroup.leave()
                                    }
                                }
                            }
                        }
                        else{
                            dispatchGroup.leave()
                        }
                        
                        
                    })
                    
                    dispatchGroup.notify(queue: .main) {
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
            }
        }
        

    }
    class func getAllInvitations(email:String,completion:@escaping (_ error:Error?, _ courses: [InvitationModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_INVITATIONS).whereField(InvitationKey.email.rawValue, isEqualTo: email).getDocuments() { (querySnapShot, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[InvitationModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        let course = InvitationModel(snap: queryDocument)!
                        referralList.append(course)
                        
                    })
                    
                    
                }
                completion(nil,referralList)
            }
        }
    }
    class func getCoursesByIds(courseIds: [String], completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_COURSES)
            .whereField("id", in: courseIds)
            .getDocuments() { (querySnapShot, error) in
                let dispatchGroup = DispatchGroup()
                if let err = error {
                    completion(err, nil)
                } else {
                    var courseList: [CourseModel] = []
                    
                    if let documents = querySnapShot?.documents, documents.count > 0 {
                        documents.forEach { queryDocument in
                            dispatchGroup.enter()
                            let course = CourseModel(snap: queryDocument)!
                            
                            FirebaseData.getCourseOveriewData(courseID: course.id ?? "") { error, userData in
                                if let userData = userData {
                                    //course.courseOverviewData = userData
                                    courseList.append(course)
                                }
                                dispatchGroup.leave()
                            }
                        }
                        
                        // Notify when all tasks are complete
                        dispatchGroup.notify(queue: .main) {
                            completion(nil, courseList)
                        }
                    } else {
                        completion(nil, [])
                    }
                }
            }
    }

    
    class func getSaveCourses(id: String, completion:@escaping (_ error:Error?, _ courses: [CourseModel]?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_COURSES)
            .whereField("\(CourseModelKey.isSaved.rawValue).\(id)", isEqualTo: true)
            .getDocuments() { (querySnapShot, error) in
                
                if let err = error {
                    completion(err, nil)
                } else {
                    var courseList: [CourseModel] = []
                    let dispatch = DispatchGroup()
                    if let documents = querySnapShot?.documents, documents.count > 0 {
                        documents.forEach { queryDocument in
                            dispatch.enter()
                            let course = CourseModel(snap: queryDocument)!
                            FirebaseData.getCourseOveriewData(courseID: course.docId) { error, overview in
                                course.courseOverviewData = overview
                                FirebaseData.getQuestionsList(course.docId) { error, userData in
                                    course.courseQuizData = userData
                                    courseList.append(course)
                                    dispatch.leave()
                                }
                                
                            }
                        }
                        
                    }
                    dispatch.notify(queue: .main){
                        completion(nil, courseList)
                    }
                    
                }
            }
    }

    
    class func getCourseQuestionData(courseID: String, completion:@escaping (_ error:Error?, _ courses: [QuestionsModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_QUAIZ).whereField(QuestionsKey.courseId.rawValue, isEqualTo: courseID).getDocuments() { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[QuestionsModel] = []
                
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let course = QuestionsModel(snap: queryDocument)!
                        referralList.append(course)
                    })
                }
                completion(nil, referralList)
            }
        }
    }
    
    class func getChapterQuestionData(chapterId: String, completion:@escaping (_ error:Error?, _ courses: [QuestionsModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_QUAIZ).whereField(QuestionsKey.chapterId.rawValue, isEqualTo: chapterId).getDocuments() { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[QuestionsModel] = []
                
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let course = QuestionsModel(snap: queryDocument)!
                        referralList.append(course)
                    })
                }
                completion(nil, referralList)
            }
        }
    }
    
    class func getCourseOveriewData(courseID: String, completion:@escaping (_ error:Error?, _ courses: [CourseOverviewModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHAPTERS).whereField(CourseOverviewModelKey.courseId.rawValue, isEqualTo: courseID).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[CourseOverviewModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        let course = CourseOverviewModel(snap: queryDocument)!
                        referralList.append(course)
                    })
                }
                completion(nil, referralList)
            }
        }
    }

    
    class func UpdateCourseOveriewData(chapterID:String, dic:CourseOverviewModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_CHAPTERS).document(chapterID).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    class func saveCourseStatisticData(uid:String, userData:Any, completion:@escaping (_ error:Error?) -> ()) {
        
        let db = Firestore.firestore()
        
        let dic: [String:Any]!
        if let user = userData as? CourseStatisticModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_COURSE_Statistic).document(uid).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
                
            }
        })
    }
    
    class func UpdateCourseData(courseID:String, dic:CourseModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_COURSES).document(courseID).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func saveBookingDataa(userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        let dic: [String:Any]!
        if let user = userData as? BookingModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_BOOKINGS).document().setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }

    
    class func saveProductCommentData(uid: String,mesageId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        let dic: [String:Any]!
        if let user = userData as? ChatModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).document(mesageId).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func saveReportUser(userData: ReportModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_REPORT).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func reauthenticateUser(currentPassword: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(false, nil)
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                print("Re-authentication failed: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Re-authentication successful.")
                completion(true, nil)
            }
        }
    }
    
    class func saveSongVerseData(uid: String, userData: WritersSongModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_SONGS).document(uid).collection(Constant.NODE_VERSES).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func deleteSongData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SONGS).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    class func deleteReview(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_COMMENTS).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    class func deleteTeam(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_Teams).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    class func saveSongData(uid:String,songData: SongModel, completion:@escaping (_ error:Error?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SONGS).document(uid).setData(songData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    class func UpdateSongVerseData(songId:String,referId: String, dic:WritersSongModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_SONGS).document(songId).collection(Constant.NODE_SONGNOTI).document(referId).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    class func saveBookingsData(userData: BookingModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_BOOKINGS).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    
    class func saveDateData(userData: DateModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_DATES).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    
    class func saveRatingDaat(userData: ReviewModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_RATINGS).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    
    class func SaveImage(node:String,userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(node).document().setData(userData as! [String : Any], completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
    
    class func SaveSongNotiData(uid: String, userData: songNotifcationModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_SONGS).document(uid).collection(Constant.NODE_SONGNOTI).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func UpdateSongData(referId: String, dic:SongModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_SONGS).document(referId).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    class func UpdateNotesData(referId: String, dic:NotesModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_NOTES).document(referId).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func UpdateDateData(referId: String, dic:DateModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        
        db.collection(Constant.NODE_DATES).document(referId).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func getNotificationList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [NotificationModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_NOTI).whereField(NotificationKeys.userID.rawValue, isEqualTo: uid).getDocuments() { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[NotificationModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(NotificationModel(snap: queryDocument )!)
                        
                    })
                    
                }
                completion(nil,referralList)
                
            }
        }
    }
    
    class func saveBannerList(userData: BannerModel, completion:@escaping (_ error:Error?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BANNERS).document().setData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }


    
    class func saveCheckInQuestionData(uid: String,checkInId:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        let dic: [String:Any]!
        if let user = userData as? QuestionsModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_CHECK).document(uid).collection(Constant.NODE_CHECKQues).document(checkInId).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    
    
    class func saveProductCommentReplyData(uid: String,commentID:String,replyID:String, userData: Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        let dic: [String:Any]!
        if let user = userData as? ChatModel{
            dic = user.dictionary
        }
        else{
            dic = userData as? [String:Any]
        }
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).document(commentID).collection(Constant.NODE_REPLIES).document(replyID).setData(dic, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    class func UpdateProductCommentData(uid: String,mesageId:String,userData: ChatModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).document(mesageId).updateData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func UpdateProductCommentreplyData(uid: String,mesageId:String,replyID:String,userData: ChatModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).document(mesageId).collection(Constant.NODE_REPLIES).document(replyID).updateData(userData.dictionary, completion: {
            err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    
    
    class func getnotifcations(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[NotificationModel]?) -> ()) {
         if let err = error {
             completion(err,nil)
         }else {
             
             var referralList:[NotificationModel] = []
             if querySnapShot?.documents.count ?? 0 > 0 {
                 querySnapShot?.documents.forEach({ (queryDocument) in
                     let dic = NotificationModel(snap: queryDocument )!
                     
                     referralList.append(dic)
                 })
                 completion(nil,referralList)

             }
             else{
                 completion(nil,nil)

             }
             
         }
     }
    
    

    
    class func updateUserDataModel(_ referId: String, dic:UserModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(referId).updateData(dic.dictionary, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func updateBookingData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? BookingModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(Constant.NODE_BOOKINGS).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func updateUserData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? UserModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(Constant.NODE_USERS).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateTeamData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? TeamModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(Constant.NODE_Teams).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateUserQuestionData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? QuestionsModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(Constant.NODE_QUAIZ).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    class func updateChatrData(_ docId: String,referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? ChatModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        db.collection(Constant.NODE_CHATS).document(docId).collection(Constant.NODE_CONVERSATIONS).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }
    
    class func getMyServiceList(_ cat:String,subcat:String,rekey:String? = nil, completion:@escaping (_ error:Error?, _ userData: [RequestModel]?) -> ()) {
        let db = Firestore.firestore()
        if let rekey = rekey{
            db.collection(Constant.NODE_REQUESTS).whereField(RequestKeys.category.rawValue, isEqualTo: cat).whereField(RequestKeys.subCategory.rawValue, isEqualTo: subcat).whereField(RequestKeys.reKeyLock.rawValue, isEqualTo: rekey).whereField(RequestKeys.status.rawValue, in: [InviteStatus.accept.rawValue,InviteStatus.accepted.rawValue]).getDocuments() { (querySnapShot, error) in
              if let err = error {
                completion(err,nil)
              }else {
                let dispatch = DispatchGroup()
                var referralList:[RequestModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                  querySnapShot?.documents.forEach({ (queryDocument) in
                    dispatch.enter()
                    let req = RequestModel(snap: queryDocument )!
                    self.getUserData(uid: req.userId) { error, userData in
                      dispatch.leave()
                      req.user = userData
                      referralList.append(req)
                    }
                  })
                  dispatch.notify(queue: .main){
                    completion(nil,referralList)
                  }
                }
                else{
                  completion(nil,referralList)
                }
              }
            }
        }
        else{
            db.collection(Constant.NODE_REQUESTS).whereField(RequestKeys.category.rawValue, isEqualTo: cat).whereField(RequestKeys.subCategory.rawValue, isEqualTo: subcat).whereField(RequestKeys.status.rawValue, in: [InviteStatus.accept.rawValue,InviteStatus.accepted.rawValue]).getDocuments() { (querySnapShot, error) in
                if let err = error {
                    completion(err,nil)
                }else {
                    let dispatch = DispatchGroup()
                    var referralList:[RequestModel] = []
                    if querySnapShot?.documents.count ?? 0 > 0 {
                        querySnapShot?.documents.forEach({ (queryDocument) in
                            dispatch.enter()
                            let req = RequestModel(snap: queryDocument )!
                            self.getUserData(uid: req.userId) { error, userData in
                                dispatch.leave()
                                req.user = userData
                                referralList.append(req)
                            }
                        })
                        dispatch.notify(queue: .main){
                            completion(nil,referralList)
                        }
                    }
                    else{
                        completion(nil,referralList)
                    }
                }
            }
        }
        
    }
    
    
    
    
//    class func updateRecordData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        var dics: [String:Any]!
//        if let dta = dic as? RecordModel{
//            dics = dta.dictionary
//        }
//        else if let dta = dic as? [String:Any]{
//            dics = dta
//        }
//        else{
//            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
//        }
//        db.collection(Constant.NODE_RECORDS).document(referId).updateData(dics, completion: {
//            err in
//            if let err = err {
//                //let erro = FIRErrorCode(raw)
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//
//    }
//
//    class func updateMemoData(_ referId: String,songId:String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        var dics: [String:Any]!
//        if let dta = dic as? RecordModel{
//            dics = dta.dictionary
//        }
//        else if let dta = dic as? [String:Any]{
//            dics = dta
//        }
//        else{
//            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
//        }
//        db.collection(Constant.NODE_SONGS).document(songId).collection(Constant.NODE_MEMOS).document(referId).updateData(dics, completion: {
//            err in
//            if let err = err {
//                //let erro = FIRErrorCode(raw)
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//
//    }

    
    
    class func updateProductData(_ referId: String, dic:Any, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var dics: [String:Any]!
        if let dta = dic as? ProductModel{
            dics = dta.dictionary
        }
        else if let dta = dic as? [String:Any]{
            dics = dta
        }
        else{
            completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
        }
        
        db.collection(Constant.NODE_PRODUCTS).document(referId).updateData(dics, completion: {
            err in
            if let err = err {
                //let erro = FIRErrorCode(raw)
                completion(err)
            } else {
                completion(nil)
            }
        })
        
    }

    class func getUserData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(uid).getDocument { (snap, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, UserModel(snap: snap!))
            }
        }
        
    }
    class func getCategoryByIdData(uid: [String], completion:@escaping (_ error:Error?, _ userData: [CategoryModel]?) -> ()) {
        let db = Firestore.firestore()
        let dispatch = DispatchGroup()
        var referralList:[CategoryModel] = []
        for uidd in uid{
            dispatch.enter()
            db.collection(Constant.NODE_CATEGORIES).document(uidd).getDocument { (snap, error) in
                
                if snap!.exists{
                    referralList.append(CategoryModel(snap: snap!)!)
                }
                dispatch.leave()
            }
        }
        dispatch.notify(queue: .main){
            completion(nil, referralList)
        }
        
        
    }
    class func getUserDataListner(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).document(uid).addSnapshotListener{ (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, UserModel(snap: snap!))
            }
        }
        
    }
    
    class func getNotesData(uid: String, completion:@escaping (_ error:Error?, _ userData: NotesModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_NOTES).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, NotesModel(snap: snap!))
            }
        }
        
    }

    
    class func getDatesModel(uid: String, completion:@escaping (_ error:Error?, _ userData: DateModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DATES).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, DateModel(snap: snap!))
            }
        }
        
    }

    
    class func getUserbyPhoneData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.phoneNumber.rawValue, isEqualTo: uid).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        completion(nil,UserModel(snap: queryDocument ))
                    })
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getUserbyEmailData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.email.rawValue, isEqualTo: uid).getDocuments { querySnapShot, error in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        completion(nil,UserModel(snap: queryDocument ))
                    })
                }
                else{
                    completion(NSError(domain: "No Data found", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No User Found", comment: "")]),nil)
                }
                
            }
        }
        
    }
    class func getSongData(uid: String, completion:@escaping (_ error:Error?, _ songData: SongModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SONGS).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, SongModel(snap: snap!))
            }
        }
        
    }
    class func getSongDatarealtime(uid: String, completion:@escaping (_ error:Error?, _ songData: SongModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SONGS).document(uid).addSnapshotListener{ (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, SongModel(snap: snap!))
            }
        }
        
    }
   
    class func getInstrumetnsData(uid: String, completion:@escaping (_ error:Error?, _ professionData: InstrumetnsListModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_INSTRUMNETS).document(uid).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, InstrumetnsListModel(snap: snap!))
            }
        }
        
    }

    
    class func getProductData(uid: String, completion:@escaping (_ error:Error?, _ userData: ProductModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).document(uid).addSnapshotListener { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, ProductModel(snap: snap!))
            }
        }
        
    }
    class func getUserDateList(userID:String,completion:@escaping (_ error:Error?, _ userData: [DateModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_DATES).whereField(DateKeys.userId.rawValue, isEqualTo: userID).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DateModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DateModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    class func getUserNotesList(userID:String,completion:@escaping (_ error:Error?, _ userData: [NotesModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_NOTES).whereField(NotesKeys.userId.rawValue, isEqualTo: userID).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[NotesModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(NotesModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getUserProductList(userID:String,completion:@escaping (_ error:Error?, _ userData: [ProductModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).whereField(ProductKeys.userId.rawValue, isEqualTo: userID).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ProductModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(ProductModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    
    
    class func getDatesImages(completion:@escaping (_ error:Error?, _ userData: [DatesImages]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection("DateImages").getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[DatesImages] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(DatesImages(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        })
        
    }
    class func getNotesImages(userID:String,completion:@escaping (_ error:Error?, _ userData: [NotesImages]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection("NotesImages").getDocuments(completion: {(querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[NotesImages] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(NotesImages(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        })
        
    }

    
    
    class func getUsersListOneTime(completion:@escaping (_ error:Error?, _ userData: [UserModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.userRole.rawValue, isEqualTo: "user").getDocuments{ (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[UserModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(UserModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getBookingsListApp(_ uid:String,completion:@escaping (_ error:Error?, _ userData: [BookingModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BOOKINGS).whereField(BookingKeys.userId.rawValue, isEqualTo: uid).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[BookingModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(BookingModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getBookingsList(_ uid:String,completion:@escaping (_ error:Error?, _ userData: [BookingModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BOOKINGS).whereField(BookingKeys.userId.rawValue, isEqualTo: uid).getDocuments {(querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[BookingModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(BookingModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }

    
    class func getUsersList(completion:@escaping (_ error:Error?, _ userData: [UserModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_USERS).whereField(UserKeys.userRole.rawValue, isEqualTo: "user").addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[UserModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(UserModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getQuestionsList(completion:@escaping (_ error:Error?, _ userData: [QuestionsModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_QUAIZ).getDocuments{ (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[QuestionsModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(QuestionsModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }

    class func getQuestionsList(_ uid:String,completion:@escaping (_ error:Error?, _ userData: [QuestionsModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_QUAIZ).whereField(QuestionsKey.courseId.rawValue, isEqualTo: uid).getDocuments{ (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[QuestionsModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(QuestionsModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    class func getSceduleList(completion:@escaping (_ error:Error?, _ userData: [ScheduleModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SCHEDULE).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ScheduleModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(ScheduleModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
    }
    
    class func getSongsList(completion:@escaping (_ error:Error?, _ userData: [SongModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SONGS).getDocuments {(querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[SongModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(SongModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    

    
    
    class func getProductList(completion:@escaping (_ error:Error?, _ userData: [ProductModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[ProductModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(ProductModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    
    
    
    class func getBannersList(completion:@escaping (_ error:Error?, _ userData: [BannerModel]?) -> ()) {
        
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BANNERS).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[BannerModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(BannerModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }


    class func getInstrumentsList(completion:@escaping (_ error:Error?, _ userData: [InstrumetnsListModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_INSTRUMNETS).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                var referralList:[InstrumetnsListModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        referralList.append(InstrumetnsListModel(snap: queryDocument )!)
                        
                    })
                }
                completion(nil,referralList)
            }
        }
        
    }
    
    
    
    
    
//    class func getCategoryList(_ completion:@escaping (_ error:Error?, _ userData: [CategoryModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_CATEGORY).getDocuments { (querySnapShot, error) in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                var referralList:[CategoryModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        referralList.append(CategoryModel(snap: queryDocument )!)
//
//                    })
//                }
//                completion(nil,referralList)
//            }
//        }
//
//    }
    
//    class func getFavList(_ uid:String, completion:@escaping (_ error:Error?, _ userData: [ProductModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_PRODUCTS).whereField("\(ProductKeys.likedby.rawValue).\(uid)", isEqualTo: true).getDocuments() { (querySnapShot, error) in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                var referralList:[ProductModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        referralList.append(ProductModel(snap: queryDocument )!)
//
//                    })
//                }
//                completion(nil,referralList)
//            }
//        }
//
//    }

//    class func getAdminUserData(_ completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).whereField(UserKeys.userRole.rawValue, isEqualTo: UserRole.admin.rawValue).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//
//                        completion(nil,UserModel(snap: queryDocument ))
//                    })
//                }
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//
//    }
//
    
    class func getSongVerses(uid: String, completion:@escaping (_ error:Error?, _ userData: [WritersSongModel]?) -> ()) {
        let db = Firestore.firestore()
            db.collection(Constant.NODE_SONGS).document(uid).collection(Constant.NODE_VERSES).getDocuments{ (querySnapShot, error) in
                if let err = error {
                    completion(err,nil)
                }else {
                    var referralList:[WritersSongModel] = []
                    if querySnapShot?.documents.count ?? 0 > 0 {
                        querySnapShot?.documents.forEach({ (queryDocument) in
                            let commen = WritersSongModel(snap: queryDocument )!
                            referralList.append(commen)
                            
                        })
                        completion(nil,referralList)
                    }
                    else{
                        completion(nil,nil)
                    }
                    
                }
            }
        
    }

    
    
   
    class func getProductCommentList(uid: String, completion:@escaping (_ error:Error?, _ userData: [CommentModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let dispatch = DispatchGroup()
                var referralList:[CommentModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let coom = CommentModel()
                        let commen = ChatModel(snap: queryDocument )!
                        coom.chat = commen
                        self.getProductCommentReplyList(uid: uid, commentID: commen.docId) { error, replylist in
                            if let array = replylist{
                                self.getUserData(uid: commen.fromID) { error, userData in
                                    dispatch.leave()
                                    coom.chat.replyCount = "\(array.count)"
                                    coom.user = userData
                                    referralList.append(coom)
                                }
                            }
                            else{
                                
                                self.getUserData(uid: commen.fromID) { error, userData in
                                    dispatch.leave()
                                    coom.user = userData
                                    referralList.append(coom)
                                }
                            }
                        }
                        
                    })
                    dispatch.notify(queue: .main) {
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
        
    }
    
    class func getProductCommentReplyList(uid: String,commentID:String, completion:@escaping (_ error:Error?, _ userData: [RepliesModel]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_PRODUCTS).document(uid).collection(Constant.NODE_COMMENTS).document(commentID).collection(Constant.NODE_REPLIES).addSnapshotListener { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                let dispatch = DispatchGroup()
                var referralList:[RepliesModel] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        dispatch.enter()
                        let coom = RepliesModel()
                        let commen = ChatModel(snap: queryDocument )!
                        coom.chat = commen
                        self.getUserData(uid: commen.fromID) { error, userData in
                            dispatch.leave()
                            coom.user = userData
                            referralList.append(coom)
                        }
                    })
                    dispatch.notify(queue: .main) {
                        completion(nil,referralList)
                    }
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    class func getChatList(uid: String, completion:@escaping (_ error:Error?, _ userData: [MessageListModel1]?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHATS).whereField("participants.\(uid)", isEqualTo: true)/*.whereField(MessageListKeys.chatType.rawValue, isEqualTo: "one")*/.addSnapshotListener { (querySnapShot, error) in
            
            if let err = error {
                completion(err,nil)
            }else {
                
                var referralList:[MessageListModel1] = []
                if querySnapShot?.documents.count ?? 0 > 0 {
                    querySnapShot?.documents.forEach({ (queryDocument) in
                        
                        
                        let commen = MessageListModel1(snap: queryDocument )!
                        referralList.append(commen)
                    })
                    completion(nil,referralList)
                }
                else{
                    completion(nil,referralList)
                }
                
            }
        }
    }
    

    class func getLiveUserData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?,_ list:ListenerRegistration?) -> ()) {
        let db = Firestore.firestore()
        var litn:ListenerRegistration!
        let listn = db.collection(Constant.NODE_USERS).document(uid).addSnapshotListener { (snap, error) in
            if let err = error {
                completion(err,nil,nil)
            }else {
                completion(nil, UserModel(snap: snap!),litn)
            }
        }
        litn = listn
        
    }
    class func removeListener(_ completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.terminate(completion: completion)
        
    }
    class func getRideFareData(_ completion:@escaping (_ error:Error?, _ userData: PriceModel?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SETTINGS).document(Constant.NODE_PRICES).getDocument { (snap, error) in
            if let err = error {
                completion(err,nil)
            }else {
                completion(nil, PriceModel(snap: snap!))
            }
        }
        
    }
    
    
//    class func getDriversList(companyid: String,role:String,isHistory:Bool = false, completion:@escaping (_ error:Error?, _ bookingData: [DriverModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).whereField(UserKeys.comapnyId.rawValue, isEqualTo: companyid).whereField(UserKeys.userRole.rawValue, isEqualTo: role).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getDrivers(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//    }
//    class func getDrivers(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[DriverModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            let dispatch = DispatchGroup()
//            var referralList:[DriverModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//
//                    if let booking = UserModel(snap: queryDocument ){
//                        let driver = DriverModel(user: booking)
//                        if booking.truckId != nil{
//                            dispatch.enter()
//                            self.getVehicleData(uid: booking.truckId) { error, userData in
//                                if booking.trailerId != nil{
//                                    driver.truck = userData
//                                    self.getVehicleData(uid: booking.trailerId) { error, userData in
//                                        driver.trailer = userData
//                                        referralList.append(driver)
//                                        dispatch.leave()
//                                    }
//
//                                }
//                                else{
//                                    driver.truck = userData
//                                    referralList.append(driver)
//                                    dispatch.leave()
//                                }
//                            }
//                        }
//                        else{
//                            referralList.append(driver)
//                        }
//
//
//                    }
//
//                })
//                dispatch.notify(queue: .main) {
//                    completion(nil,referralList)
//                }
//            }
//            else{
//                completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//
//
//
//        }
//    }
//
//
//    class func getNotificationList(_ uid:String,completion:@escaping (_ error:Error?, _ notificationData: [NotificationModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_NOTIFICATIONS).whereField("\(NotificationKeys.isRead.rawValue).\(uid)", in: [true,false]).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getNotification(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//
//    }
//    class func getNotification(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[NotificationModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[NotificationModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//
//                    referralList.append(NotificationModel(snap: queryDocument )!)
//                })
//            }
//            //referralList = referralList.sorted(by: { $0.bookingDate.getInt64toTime() > $1.bookingDate.getInt64toTime() })
//            completion(nil,referralList)
//        }
//    }
//    class func getUserList(_ completion:@escaping (_ error:Error?, _ userData: [UserModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_NOTIFICATIONS).whereField(UserKeys.userRole.rawValue, isEqualTo: UserRole.driver.rawValue).whereField(UserKeys.isActive.rawValue, isEqualTo: true).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getUser(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//        
//    }
    class func getUser(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[UserModel]?) -> ()) {
        if let err = error {
            completion(err,nil)
        }else {
            var referralList:[UserModel] = []
            if querySnapShot?.documents.count ?? 0 > 0 {
                querySnapShot?.documents.forEach({ (queryDocument) in
                    
                    referralList.append(UserModel(snap: queryDocument )!)
                })
            }
            //referralList = referralList.sorted(by: { $0.bookingDate.getInt64toTime() > $1.bookingDate.getInt64toTime() })
            completion(nil,referralList)
        }
    }
    
   
//    class func getPromotionList(_ completion:@escaping (_ error:Error?, _ promotionData: [PromotionModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_PROMOTIONS).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getPromotion(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//
//    }
//    class func getPromotion(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[PromotionModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[PromotionModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//
//                    referralList.append(PromotionModel(snap: queryDocument )!)
//                })
//            }
//            //referralList = referralList.sorted(by: { $0.bookingDate.getInt64toTime() > $1.bookingDate.getInt64toTime() })
//            completion(nil,referralList)
//        }
//    }
//    class func getRequestList(_ uid:String, completion:@escaping (_ error:Error?, _ promotionData: [RequestModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_MY_REQUESTS).whereField(VehicleKeys.userId.rawValue, isEqualTo: uid).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getRequest(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//
//    }
//    class func getRequest(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[RequestModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[RequestModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//
//                    referralList.append(RequestModel(snap: queryDocument )!)
//                })
//            }
//            //referralList = referralList.sorted(by: { $0.bookingDate.getInt64toTime() > $1.bookingDate.getInt64toTime() })
//            completion(nil,referralList)
//        }
//    }
//    class func getScheduleData(uid: String, completion:@escaping (_ error:Error?, _ bookingData: ScheduleModel?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_SCHEDULED_RIDES).whereField(ScheduleKeys.userId.rawValue, isEqualTo: uid).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getSchedule(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//    }
//    class func getSchedule(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:ScheduleModel?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//
//                    completion(nil,ScheduleModel(snap: queryDocument ))
//                })
//            }
//            //referralList = referralList.sorted(by: { $0.bookingDate.getInt64toTime() > $1.bookingDate.getInt64toTime() })
//
//        }
//    }
//    class func getVehicleData(uid: String, completion:@escaping (_ error:Error?, _ userData: VehicleModel?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_VEHICLE).document(uid).getDocument { (querySnapShot, error) in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                completion(nil,VehicleModel(snap: querySnapShot!))
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//
//            }
//        }
//    }
    class func checkUserData(uid: String, completion:@escaping (_ error:Error?, _ userData: UserModel?) -> ()) {
        let db = Firestore.firestore()
        var field = ""
        if uid.contains(".com"){
            field = "email"
        }
        else{
            field = "phoneNumber"
        }
        db.collection(Constant.NODE_USERS).whereField(field, isEqualTo: uid).getDocuments { (querySnapShot, error) in
            if let err = error {
                completion(err,nil)
            }else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    for queryDocument in querySnapShot?.documents ?? [] {
                        completion(nil,UserModel(snap: queryDocument))
                        return
                    }
                }
                else{
                    completion(NSError(domain:"Not Exist", code:0, userInfo:nil),nil)
                }
            }
        }
        
    }
//    class func getLiveDriverData(_ completion:@escaping (_ error:Error?, _ userData: [LocationModels]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_LIVE_DRIVERS).addSnapshotListener(includeMetadataChanges: true) { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                var array = [LocationModels]()
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        array.append(LocationModels(snap: queryDocument)!)
//                    }
//                    completion(nil,array)
//                }
//                else{
//                    completion(NSError(domain:"Not Exist", code:0, userInfo:nil),nil)
//                }
//            }
//        }
//
//    }
    class func updatetokenData(isTokn:Bool, completion:@escaping (_ error:Error?) -> ()) {
        let user = UserModel()
        if isTokn{
            user.token = Messaging.messaging().fcmToken
        }
        else{
            user.token = ""
        }
        updateUserData(getCurrentUserId(), dic: user, completion: completion)
        
    }
    
//    class func saveContactSupportData(userData: CSModel, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        userData.userId = getCurrentUserId()!
//        db.collection(Constant.NODE_CONTACT).addDocument(data: userData.dictionary) { error in
//            if let err = error {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        }
//        
//    }
//    
//    class func getAccountData(_ accountName: String, completion:@escaping (_ error:Error?, _ userData: AccountModel?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_ACCOUNT).whereField(Constant.accountName, isEqualTo: accountName).getDocuments { (querySnapShot, error) in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        completion(nil,AccountModel(snap: queryDocument))
//                        return
//                    }
//                }
//                else{
//                    completion(nil,nil)
//                }
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//        
//    }
//    class func getAccountList(uid: String, completion:@escaping (_ error:Error?, _ userData: [AccountModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).document(uid).collection(Constant.NODE_ACCOUNT).addSnapshotListener { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getAccount(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//    }
//    class func getAccount(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[AccountModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[AccountModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    
//                    referralList.append(AccountModel(snap: queryDocument )!)
//                })
//            }
//            referralList = referralList.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() })
//            completion(nil,referralList)
//        }
//    }
//    class func getChargesList(_ completion:@escaping (_ error:Error?, _ userData: [TransectionTypeModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_CHARGES).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getCharges(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//    }
//    class func getCharges(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[TransectionTypeModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[TransectionTypeModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    
//                    referralList.append(TransectionTypeModel(snap: queryDocument )!)
//                })
//            }
//            completion(nil,referralList)
//        }
//    }
//    class func getLimitList(_ completion:@escaping (_ error:Error?, _ userData: [TransectionLimitModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_LIMITS).getDocuments { querySnapShot, error in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                getLimits(querySnapShot: querySnapShot, error: error, completion: completion)
//                //completion(NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Account details", comment: "")]),nil)
//            }
//        }
//    }
//    class func getLimits(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[TransectionLimitModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[TransectionLimitModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    
//                    referralList.append(TransectionLimitModel(snap: queryDocument )!)
//                })
//            }
//            completion(nil,referralList)
//        }
//    }
//    class func getCurrentUserSender()-> SenderUser {
//        return SenderUser(senderId: getCurrentUserId(), displayName:  "", photoURL: "")
//    }
    
//    class func fetchReferrals(role:UserRole,completion:@escaping (_ error:Error?, _ referrals:[ReferralModel]?) -> ()) {
//        let db = Firestore.firestore()
//        if role == UserRole.Admin {
//            db.collection(Constant.NODE_REFERRALS).getDocuments(completion: { (querySnapShot, error) in
//                getRefers(querySnapShot: querySnapShot, error: error, completion: completion)
//                })
//        }else if role == UserRole.BranchManager {
//            db.collection(Constant.NODE_REFERRALS).whereField(Constant.NODE_BRANCH_ID, in: Helper.getCachedUserData()?.userBranches ?? []).getDocuments { (querySnapShot, error) in
//                getRefers(querySnapShot: querySnapShot, error: error, completion: completion)
//            }
//        }else {
//            db.collection(Constant.NODE_REFERRALS).whereField(Constant.NODE_CURRENT_USER_UID, isEqualTo: getCurrentUserId()).getDocuments { (querySnapShot, error) in
//                getRefers(querySnapShot: querySnapShot, error: error, completion: completion)
//            }
//        }
//        
//    }
//    class func fetchUserReferrals(id:String,completion:@escaping (_ error:Error?, _ referrals:[ReferralModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_REFERRALS).whereField(Constant.NODE_CURRENT_USER_UID, isEqualTo: id).getDocuments { (querySnapShot, error) in
//            getRefers(querySnapShot: querySnapShot, error: error, completion: completion)
//        }
//        
//    }
//    class func getReferrals(id:String,completion:@escaping (_ error:Error?, _ referrals:ReferralModel?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_REFERRALS).document(id).getDocument(completion: { (snap, error) in
//            if let err = error {
//                completion(err,nil)
//            }else {
//                completion(nil, ReferralModel(snap: snap!))
//            }
//        })
//        
//    }
//    class func fetchUsers(completion:@escaping (_ error:Error?, _ referrals:[UserModel]?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).getDocuments { (querySnapShot, error) in
//            getUsers(querySnapShot: querySnapShot, error: error, completion: completion)
//        }
//        
//    }
////    class func fetchAllUsersClaimHistory(completion:@escaping (_ error:Error?, _ referrals:[ClaimHistoryModel]?) -> ()) {
////        let db = Firestore.firestore()
////        db.collection(Constant.NODE_USERS).getDocuments { (querySnapShot, error) in
////            getUsers1(querySnapShot: querySnapShot, error: error, completion: completion)
////        }
////        
////    }
//    class func fetchClaimed(completion:@escaping(_ error:Error?, _ users:[UserModel]?) -> ()){
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).whereField(Constant.NODE_CURRENT_USER_UID, isEqualTo: getCurrentUserId()).getDocuments { (querySnapShot, error) in
//            
//        }
//    }
//    
//    class func getRefers(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[ReferralModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//            var referralList:[ReferralModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    
//                    referralList.append(ReferralModel(snap: queryDocument )!)
//                })
//            }
//            referralList = referralList.sorted(by: { $0.date > $1.date })
//            completion(nil,referralList)
//        }
//    }
//    class func getUsers(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[UserModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//
//            var referralList:[UserModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    let dic = UserModel(snap: queryDocument )!
//                    if dic.id != getCurrentUserId(){
//                        referralList.append(dic)
//                    }
//                    
//
//                })
//                completion(nil,referralList)
//            }
//
//        }
//    }
//    class func getUsers1(querySnapShot:QuerySnapshot?, error:Error?,completion:@escaping (_ error:Error?, _ referrals:[ClaimHistoryModel]?) -> ()) {
//        if let err = error {
//            completion(err,nil)
//        }else {
//
//            //var userList:[UserModel] = []
//            var claimHistoryList:[ClaimHistoryModel] = []
//            if querySnapShot?.documents.count ?? 0 > 0 {
//                querySnapShot?.documents.forEach({ (queryDocument) in
//                    let userdic = UserModel(snap: queryDocument )!
//                    var referralPoints = 0
//                    fetchUserReferrals(id: userdic.id) { (error, list) in
//                        if list != nil && list?.count ?? 0 > 0{
//                            for referral in list ?? [] {
//                                if !referral.points.isEmpty {
//                                    referralPoints += Int(referral.points) ?? 0
//                                }
//                            }
//                        }
//                        let array = userdic.arrayClaimedPoints
//
//                        if array.count > 0 {
//
//                            array.forEach({ (data) in
//                                let clampoint = data as! NSDictionary
//
//                                let claimdic = ClaimedModel(dictionary: clampoint)!
//
//                                let claimhistory = ClaimHistoryModel()
//                                claimhistory.userName = userdic.userName
//                                claimhistory.userEmail = userdic.userEmail
//                                claimhistory.phoneNumber = userdic.phoneNumber
//                                claimhistory.date = claimdic.time
//                                claimhistory.claimedPoints = claimdic.claimedPoints
//                                referralPoints = referralPoints - claimdic.claimedPoints
//                                claimhistory.balancePoints = referralPoints
//                                claimHistoryList.append(claimhistory)
//
//                            })
//
//
//                        }
//                        claimHistoryList = claimHistoryList.sorted(by: { $0.date > $1.date })
//                        completion(nil,claimHistoryList)
//                        //dic.earnedPoints = referralPoints
//                        //dic.claimedPoints = claimedPoints
//                        //dic.balancePoints = referralPoints - claimedPoints
//                    }
//                    //userList.append(dic)
//                })
//            }
//
//        }
//    }
    class func checkReferStatus(referalData: ReferralModel, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BOOKINGS).whereField("email", isEqualTo: referalData.email).getDocuments(completion: {
            (querySnapShot, error) in
            if let err = error {
                completion(err)
            } else {
                if querySnapShot?.documents.count ?? 0 > 0 {
                    for queryDocument in querySnapShot?.documents ?? [] {
                        if ReferralModel(snap: queryDocument )?.status != "expired"{
                            completion(NSError(domain: "EmailError", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("User has already been referred", comment: "")]))
                            return
                        }
                    }
                }
                completion(nil)
            }
        })
        
    }
    class func deleteChatData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHATS).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    class func deleteBookingData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_BOOKINGS).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    class func deleteScheduleData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_SCHEDULED_RIDES).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    class func deleteRequestData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        db.collection(Constant.NODE_REQUEST_RIDES).document(uid).delete { (err) in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
    
    class func uploadFile(url:URL,name:String ,folder:String,content:String,index:Int = 0,completion: @escaping (_ url: String?,_ error: Error?,_ index:Int) -> Void) {
        let path = "\(folder)/\(name).\(url.pathExtension)"
        print(path)
        let storageRef = Storage.storage().reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = content //"audio/mp3"
        storageRef.putFile(from:url, metadata: metadata) { (metadata, error) in
          if error != nil {
            completion(nil, error,index)
          } else {
            storageRef.downloadURL { (url, error) in
              if error != nil {
                completion(nil, error,index)
              }else {
                completion(url?.absoluteString ?? "", nil,index)
              }
            }
          }
        }
      }
    
    
//    class func deleteScheduleData(uid: String, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_SCHEDULED_RIDES).document(uid).delete { (err) in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//    class func  saveEmergencyData(_ uid:String, emerData: EmergencyModel, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_EMERGENCY).document(uid).setData(emerData.dictionary, completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//
//    }
//    class func updateBarData(_ referId: String, dic:BarModel, completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        
//        db.collection(Constant.NODE_BOOKINGS).document(referId).updateData(dic.dictionary, completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//        
//    }
//    class func  getbrachesUserData(referalData: ReferralModel, completion:@escaping (_ error:Error?) -> ()) {
//            let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).whereField(Constant.NODE_USER_BRANCHES, arrayContains:  referalData.branchId).getDocuments { (querySnapShot, error) in
//            if let err = error {
//                completion(err)
//            } else {
//                
//             completion(nil)
//            }
//        }
//    }
//    
//    class func getPurposeList(completion:@escaping (_ purpose:[PurposeModel]?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_PURPOSE_TYPES).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                var purposeList:[PurposeModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        purposeList.append(PurposeModel(snap: queryDocument )!)
//                    })
//                }
//                completion(purposeList,nil)
//            }
//
//        })
//        
//    }
//    
//    class func getCountriesList(completion:@escaping (_ countries:[CountryModel]?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_COUNTRY).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                var countriesList:[CountryModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        countriesList.append(CountryModel(snap: queryDocument )!)
//                    })
//                }
//                countriesList = countriesList.sorted(by: { $0.countryName < $1.countryName })
//                completion(countriesList,nil)
//            }
//
//        })
//        
//    }
//    
//    class func getBranchesListForCountry(countryID:String,completion:@escaping (_ branches:[BranchModel]?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_BRANCHES).whereField(Constant.NODE_COUNTRY_ID, isEqualTo: countryID).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                var brachesList:[BranchModel]?
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    brachesList = []
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        brachesList?.append(BranchModel(snap: queryDocument)!)
//                    })
//                }
//                completion(brachesList,nil)
//            }
//
//        })
//        
//    }
//    
//    class func getCountry(countryID:String,completion:@escaping (_ country:CountryModel?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_COUNTRY).whereField(Constant.NODE_COUNTRY_ID, isEqualTo: countryID).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        completion(CountryModel(snap: queryDocument), nil)
//                        return
//                    }
//                }
//                completion(nil,nil)
//            }
//            
//        })
//        
//    }
//    
//    class func getBranch(branchID:String,completion:@escaping (_ branch:BranchModel?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_BRANCHES).whereField(Constant.NODE_BRANCH_ID, isEqualTo: branchID).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        completion(BranchModel(snap: queryDocument), nil)
//                        return
//                    }
//                }
//                completion(nil,nil)
//            }
//            
//        })
//        
//    }
//    
//    class func getPurpose(purposeID:String,completion:@escaping (_ purpose:PurposeModel?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_PURPOSE_TYPES).whereField(Constant.NODE_PURPOSE_ID, isEqualTo: purposeID).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        completion(PurposeModel(snap: queryDocument), nil)
//                        return
//                    }
//                }
//                completion(nil,nil)
//            }
//            
//        })
//        
//    }
//    
//    class func updateReferalData(referId: String, dic:[AnyHashable:Any], completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        
//        db.collection(Constant.NODE_REFERRALS).document(referId).updateData(dic, completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//             completion(nil)
//            }
//        })
//        
//    }
//    
//    class func updateUserClaimData(Id: String, dic:[Any], completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        //db.collection(Constant.NODE_USERS).document(Id).updateData(FieldValue.arrayUnion(dic))
//        db.collection(Constant.NODE_USERS).document(Id).updateData(["arrayClaimedPoints":FieldValue.arrayUnion(dic)], completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//        
//    }
//    
//    class func getBranchesList(completion:@escaping (_ branches:[BranchModel]?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_BRANCHES).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                var branchList:[BranchModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        branchList.append(BranchModel(snap: queryDocument )!)
//                    })
//                }
//                completion(branchList,nil)
//            }
//
//        })
//    }
//    
//    class func getCountriesWithBranches(countryIds:[Any],completion:@escaping (_ countries:[CountryModel]?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_COUNTRY).whereField(Constant.NODE_COUNTRY_ID, in: countryIds).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                var countriesList:[CountryModel] = []
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    querySnapShot?.documents.forEach({ (queryDocument) in
//                        countriesList.append(CountryModel(snap: queryDocument )!)
//                    })
//                }
//                countriesList = countriesList.sorted(by: { $0.countryName < $1.countryName })
//                completion(countriesList,nil)
//            }
//            
//        })
//    }
//
    class func logout(){
        let user = UserModel()
        user.token = ""
        //user.isOnline = false
        self.updateUserData(self.getCurrentUserId(), dic: user) { error in
            self.logoutUserData { error in
                //CommonHelper.removeCachedUserData()
                
                let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController)
                UIApplication.shared.windows.first?.rootViewController = vc
            }
        }
        
    }
    class func checkLogin() -> Bool{
        return Auth.auth().currentUser != nil
    }
    class func getCurrentUserId() -> String {
        let id = Auth.auth().currentUser?.uid
        print("uid: \(id ?? "")")
        if let di = id{
            return di
        }
        else{
            //self.logout()
            return "0"
        }
    }

    
    
    
    
//    
//    class func getBranchManagerFromBranchId(branchId:String, completion:@escaping (_ user:UserModel?,_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).whereField(Constant.NODE_USER_BRANCHES, arrayContains: branchId).getDocuments(completion: { (querySnapShot, error) in
//            if let err = error {
//                completion(nil,err)
//            }else {
//                if querySnapShot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapShot?.documents ?? [] {
//                        completion(UserModel(snap: queryDocument), nil)
//                        return
//                    }
//                }
//                completion(nil,nil)
//            }
//            
//        })
//    }
//    
    class func addMessageToConversation(documentId: String, chatModel:ChatModel,isSendAdmin:Bool = false,completion:@escaping (_ error:Error?) -> ()) {
        let db = Firestore.firestore()
        var node = Constant.NODE_CHATS
        if isSendAdmin{
            node = Constant.NODE_ADMINCHAT
        }
        db.collection(node).document(documentId).collection(Constant.NODE_CONVERSATIONS).document(chatModel.messageId).setData(chatModel.dictionary, completion: { error in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
        })
    }
//    class func addMessageToAdminConversation(documentId: String,request:RequestModel, chatModel:ChatModel,completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_ADMINCHAT).document(documentId).collection(Constant.NODE_CONVERSATIONS).document(chatModel.messageId).setData(chatModel.dictionary, completion: { error in
//            if let err = error {
//                completion(err)
//            } else {
//                db.collection(Constant.NODE_ADMINCHAT).document(documentId).setData(["lastMessage" : chatModel.dictionary,"participants":[chatModel.fromID:true,chatModel.toID:true]]) { error in
//                    if let err = error {
//                        completion(err)
//                    } else {
//                        db.collection(Constant.NODE_MY_REQUESTS).document(documentId).setData(request.dictionary) { error in
//                            if let err = error {
//                                completion(err)
//                            } else {
//                                completion(nil)
//                            }
//                        }
//                    }
//                }
//
//            }
//        })
//    }
//
    
    class func getConverstationIdOfTwoUsers(senderId:String, receiverId:String, completion:@escaping (_ conversationId:String?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(Constant.NODE_CHATS).whereField("participants.\(senderId)", isEqualTo: true).whereField("participants.\(receiverId)", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                if querySnapshot?.documents.count ?? 0 > 0 {
                    for queryDocument in querySnapshot?.documents ?? [] {
                        completion(queryDocument.documentID, nil)
                        return
                    }
                }
                completion(nil,nil)
            }
        }
    }
    class func getConverstationOfTwoUsersSerivce(_ uid:String,conversationId:String,node:String = Constant.NODE_ADMINCHAT, completion:@escaping (_ user:UserModel?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let chat = ParticepentsModel(snap: querySnapshot!)
                chat?.participants.removeValue(forKey: uid)
                if let recivrid = chat?.participants.keys.first{
                    self.getUserData(uid: recivrid) { error, userData in
                        if let err = error {
                            completion(nil,err)
                        }else {
                            completion(userData,nil)
                        }
                    }
                }
                else{
                    completion(nil,nil)
                }
            }
        }
    }
    class func getConverstationOfManyUsersSerivce(_ uid:String,conversationId:String,node:String = Constant.NODE_ADMINCHAT, completion:@escaping (_ user:[UserModel]?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        db.collection(node).document(conversationId).getDocument { (querySnapshot, error) in
            if let err = error {
                completion(nil,err)
            }else {
                let dispatchgroup = DispatchGroup()
                var users:[UserModel] = []
                if let chat = ParticepentsModel(snap: querySnapshot!){
                //chat.participants.removeValue(forKey: uid)
                for recivrid in chat.participants.keys{
                    dispatchgroup.enter()
                        self.getUserData(uid: recivrid) { error, userData in
                            dispatchgroup.leave()
                            guard let userData = userData else {
                                return
                            }
                            users.append(userData)
                        }
                }
                    dispatchgroup.notify(queue: .main) {
                        completion(users,nil)
                    }
                }
                else{
                    completion(users,nil)
                }
            }
        }
    }
    class func getConverstationOfSongUsersSerivce(_ userid:[String], completion:@escaping (_ user:[UserModel]?, _ error:Error?) -> ()){
        let db = Firestore.firestore()
        let dispatchgroup = DispatchGroup()
        var users:[UserModel] = []
        for uuid in userid{
            dispatchgroup.enter()
            self.getUserData(uid: uuid) { error, userData in
                dispatchgroup.leave()
                guard let userData = userData else {
                    return
                }
                users.append(userData)
            }
        }
        dispatchgroup.notify(queue: .main) {
            completion(users,nil)
        }
    }
//    class func getConverstationOfBookingSerivce(_ uid:String, completion:@escaping (_ conversationId:String?,_ userData:UserModel?, _ error:Error?) -> ()){
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_MY_REQUESTS).whereField(RequestKeys.bookingId.rawValue, isEqualTo: uid).getDocuments { (querySnapshot, error) in
//            if let err = error {
//                completion(nil,nil,err)
//            }else {
//                if querySnapshot?.documents.count ?? 0 > 0 {
//                    for queryDocument in querySnapshot?.documents ?? [] {
//                        let request = RequestModel(snap: queryDocument)
//                        self.getConverstationOfTwoUsersSerivce(self.getCurrentUserId(), conversationId: request!.conversationId, node: Constant.NODE_ADMINCHAT) { userModel, error in
//                            if let error = error {
//                                completion(nil,nil,error)
//                                return
//                            }
//                            completion(request!.conversationId,userModel,nil)
//                            return
//                        }
//
//                    }
//                    return
//                }
//
//                completion(nil,nil,NSError(domain: "No Data", code: 113, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("No Data", comment: "")]))
//            }
//        }
//    }
    class func uploadProfileImage(image:UIImage,name:String ,folder:String,index:Int = 0,completion: @escaping (_ url: String?,_ error: Error?,_ index:Int) -> Void) {
        let storageRef = Storage.storage().reference().child("\(folder)/\(name).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    completion(nil, error,index)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if error != nil {
                            completion(nil, error,index)
                        }else {
                            completion(url?.absoluteString ?? "", nil,index)
                        }
                    }
                }
            }
        }
    }
//    class func updateTokkenData(dic:[String:Any], completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        
//        db.collection(Constant.NODE_USERS).document(getCurrentUserId() ?? "").updateData(dic, completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//        
//    }
//    
//    class func updateUserData(uid: String, userData: [String:Any], completion:@escaping (_ error:Error?) -> ()) {
//        let db = Firestore.firestore()
//        db.collection(Constant.NODE_USERS).document(uid).updateData(userData, completion: {
//            err in
//            if let err = err {
//                completion(err)
//            } else {
//                completion(nil)
//            }
//        })
//        
//    }
}
