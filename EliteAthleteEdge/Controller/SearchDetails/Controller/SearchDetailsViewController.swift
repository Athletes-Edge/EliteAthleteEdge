//
//  SearchDetailsViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

struct sreachDetail{
    var name:String
    var type:String
}

import UIKit
import AVKit
import MediaPlayer

class SearchDetailsViewController: UIViewController, AVPlayerViewControllerDelegate {

    @IBOutlet weak var ivitableview: UITableView!
    
    var player: AVPlayer?
    var timeObserverToken: Any?
    
    var courseData: CourseModel!
    var question = [QuestionsModel]()
    var userModel:UserModel!
    var categoryArray = [CategoryModel]()
    var selectedIndex = 0
    var feedback = "Write Review"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        self.loadData()
    }
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        fetchAllQuestions()
    }
    private func setupController() {
        ivitableview.delegate = self
        ivitableview.dataSource = self
        
    }
    func loadData(){
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            self.userModel = userData
        }
    }
    private func fetchAllQuestions() {
        guard let couseData = self.courseData else { return }
        if couseData.courseOverviewData.count > 0 {
            PopupHelper.showAnimating(self)
            
            FirebaseData.getChapterQuestionData(chapterId: couseData.courseOverviewData[self.selectedIndex].docId ) { error, courses in
                
                if let error = error{
                    self.stopAnimating()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                    return
                }
                self.question = courses ?? []
                FirebaseData.getCategoryByIdData(uid: self.courseData.categoryId) { error, userData in
                    self.stopAnimating()
                    if let error = error{
                        
                        PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                        return
                    }
                    self.categoryArray = userData ?? []
                    self.ivitableview.reloadData()
                }
                
                
            }
        }
    }
    
    @objc func didTapSubmit(_ sender: UIButton) {
        if self.feedback.isEmpty || self.feedback == "Write Review"{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please write your feedback", forViewController: self)
            return
        }
        PopupHelper.showAnimating(self)
        let dat = ReviewModel()
        dat.courseId = self.courseData.docId
        dat.teamId = ""
        dat.userId = FirebaseData.getCurrentUserId()
        dat.details = self.feedback
        dat.createdDate = Date().milisecondInt64
        
        FirebaseData.saveUserFeedbackData(uid: UUID().uuidString, userData: dat) { error in
            self.stopAnimating()
            if let error = error{
                PopupHelper.showAlertControllerWithError(forErrorMessage: error.localizedDescription, forViewController: self)
                return
            }
            self.feedback = "Write Review"
            self.ivitableview.reloadData()
        }
    }
    @objc func didTapPlay(_ sender: UIButton) {
        
        let courseOverview = self.courseData.courseOverviewData[self.selectedIndex]
        guard let videoURL = URL(string: courseOverview.videoUrl ?? "") else { return }
        
        self.player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.delegate = self
        
        self.present(playerViewController, animated: true) {
            self.player?.play()
        }
        addTimeObserver()
    }
    @objc func didTapPlay1(_ sender: UIButton) {
        self.selectedIndex = sender.tag
        let courseOverview = self.courseData.courseOverviewData[self.selectedIndex]
        guard let videoURL = URL(string: courseOverview.videoUrl ?? "") else { return }
        
        self.player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = self.player
        playerViewController.delegate = self
        
        self.present(playerViewController, animated: true) {
            self.player?.play()
        }
        addTimeObserver()
    }
    func addTimeObserver() {
        guard let player = player else { return }
        
        // Observe the player's current time every 1 second
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
            
            if duration > 0 {
                let percentageWatched = (currentTime / duration) * 100
                print("Percentage watched: \(percentageWatched)%")
            }
        }
    }
    
    func removeTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func updateOverviewCourseData(overviewData: CourseOverviewModel, currentTimeMiliSecond: Double) {
        guard let course = courseData else { return }
        PopupHelper.showAnimating(self)
        let data = CourseStatisticModel()
        data.userId = FirebaseData.getCurrentUserId()
        data.courseId = course.id
        data.chapterId = overviewData.id
        if let watchHour = overviewData.watchHour,let time = watchHour[FirebaseData.getCurrentUserId()]{
            data.watchHours = time
        }
        if let progress = overviewData.progress,let time = progress[FirebaseData.getCurrentUserId()]{
            data.progress = time
        }
        let date = Date()
        data.date = date.milisecondInt64
        data.weekDay = date.weekDay
        data.day = "\(date.day)"
        data.month = "\(date.getMonth)"
        data.year = "\(date.year)"
        
        FirebaseData.saveCourseStatisticData(uid: UUID().uuidString, userData: data) { error in
            FirebaseData.UpdateCourseOveriewData(chapterID: overviewData.id , dic: overviewData) { error in
                self.courseData.courseOverviewData[self.selectedIndex] = overviewData
                self.stopAnimating()
                self.updatecourse()
            }
        }
        
    }
    func updatecourse(){
        let user = UserModel()
        let chapter = courseData.courseOverviewData[selectedIndex]
        if let progress = chapter.progress{
            if let time = progress[FirebaseData.getCurrentUserId()]{
                if time < 100{
                    return
                }
                else{
                    var countr:Int64 = 0
                    if let skill = self.userModel.pointsSkill{
                        countr = skill
                    }
                    countr += 1
                    user.pointsSkill = countr
                }
            }
        }
        
        var data = [String:Bool]()
        if let complete = courseData.isCompleted{
            data = complete
        }
       
        data[FirebaseData.getCurrentUserId()] = true
        let cor = CourseModel()
        cor.isCompleted = data
        FirebaseData.UpdateCourseData(courseID: courseData.docId, dic: cor) { error in
            
            FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: user) { error in
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    
//    func getCurrentDateInMilliseconds() -> Int64? {
//        
//        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
//        if let date = calendar.date(from: dateComponents) {
//            return Int64(date.timeIntervalSince1970 * 1000)
//        }
//        
//        return nil
//    }
    
    // need to update this delegat method this is for only check 
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        guard let player = self.player else { return }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        
        let currentTimeInMillis = Double(currentTime * 1000)
        
        var percentageWatched  = 0.0
        if duration > 0 {
            percentageWatched = (currentTime / duration) * 100
            print("Final percentage watched: \(percentageWatched)%")
        }
        
        // Clean up
        removeTimeObserver()
        
        let overview = self.courseData.courseOverviewData ?? []
        let userId = FirebaseData.getCurrentUserId()
        if overview.count > self.selectedIndex {
            let overveiwData = overview[selectedIndex]
            let progress = (overveiwData.progress[userId]) ?? 0
            if percentageWatched > progress {
                overveiwData.progress[userId] = percentageWatched
                overveiwData.watchHour[userId] = currentTimeInMillis
                self.updateOverviewCourseData(overviewData: overveiwData, currentTimeMiliSecond: currentTimeInMillis)
            }
            else{
                let overveiwData = overview[selectedIndex]
                self.updateOverviewCourseData(overviewData: overveiwData, currentTimeMiliSecond: currentTimeInMillis)
            }
        }
        
        
    }

}

extension SearchDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    @objc func btngotoansers(_ sender:UIButton){
        if self.question.count > 0 {
            let vc = UIStoryboard.storyBoard(withName: .Search).loadViewControllersss(withIdentifier: "QuestionAnswerViewController") as! QuestionAnswerViewController
            vc.courseModel = self.courseData
            vc.questionData = self.question
            vc.userModel = self.userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "No questions found", forViewController: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self)?.first as! HeaderView
        if section == 2 {
            headerView.lblname.text = "Course Overview"
        } else {
            headerView.lblname.text = ""
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 35.0
        }
        else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return self.courseData.courseOverviewData.count
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topSerachDetailTableViewCell", for: indexPath) as! topSerachDetailTableViewCell
            cell.ivCollection.dataSource = self
            cell.ivCollection.delegate = self
        
            cell.playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
            cell.configureCell(course: self.courseData, selectedIndex: self.selectedIndex)
            cell.ivCollection.reloadData()
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonTableViewCell", for: indexPath) as! buttonTableViewCell
            cell.btnseerestults.addTarget(self, action: #selector(self.btngotoansers), for: .touchUpInside)
            if self.question.count > 0{
                cell.btnseerestults.isHidden = false
            }
            else{
                cell.btnseerestults.isHidden = true
            }
            return cell
        } else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourcesTableViewCell", for: indexPath) as! CourcesTableViewCell
            let data = self.courseData.courseOverviewData[indexPath.row]
            cell.lbnmae.text = data.title ?? ""
            cell.lbldetais.text = data.descriptions ?? ""
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.addTarget(self, action: #selector(self.didTapPlay1(_:)), for: .touchUpInside)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topSerachDetail1TableViewCell", for: indexPath) as! topSerachDetail1TableViewCell

            cell.submitButton.addTarget(self, action: #selector(didTapSubmit(_:)), for: .touchUpInside)
            cell.feedbackTextfield.delegate = self
            cell.feedbackTextfield.text = self.feedback
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            self.selectedIndex = indexPath.row
            self.ivitableview.reloadData()
            self.ivitableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            self.fetchAllQuestions()
        }
    }
}

extension SearchDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategforyCollectionViewCell", for: indexPath) as! CategforyCollectionViewCell
        let data = self.categoryArray[indexPath.row]
        cell.lbname.text = data.title
        return cell
    }
}
extension SearchDetailsViewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text! == "Write Review"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView){
        if textView.text!.isEmpty{
            textView.text = "Write Review"
            textView.textColor = .lightGray
        }
        else{
            self.feedback = textView.text ?? ""
        }
    }
}
