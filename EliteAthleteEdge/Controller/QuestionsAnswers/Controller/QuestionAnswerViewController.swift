//
//  QuestionAnswerViewController.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit

class QuestionAnswerViewController: UIViewController {
    
    @IBOutlet weak var ivTableView: UITableView!
    @IBOutlet weak var btnUpdate: UIButton!
    var courseModel = CourseModel()
    var questionData = [QuestionsModel]()
    var userModel:UserModel!
    var ispdate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        ivTableView.delegate = self
        ivTableView.dataSource = self
        if self.questionData.contains(where: {$0.userAnswer.keys.contains(where: {$0 == FirebaseData.getCurrentUserId()})}){
            self.btnUpdate.setTitle("Update Answers", for: .normal)
        }
        else{
            self.btnUpdate.setTitle("Submit", for: .normal)
        }
        ivTableView.reloadData()
    }
    @IBAction func submitBtn(_ sender:UIButton){
        for data in self.questionData{
            if data.yourAnswer == nil || data.yourAnswer.isEmpty{
                PopupHelper.showAlertControllerWithError(forErrorMessage: "please answer all questions", forViewController: self)
                return
            }
        }
        
        
        var count:Int64 = 0
        if let point = self.userModel.pointsSkill{
            count = point
        }
        for data in self.questionData{
            count += 1
        }
        let uss = UserModel()
        uss.pointsSkill = count
        FirebaseData.updateUserData(FirebaseData.getCurrentUserId(), dic: uss) { error in
            
        }
        let dispatch = DispatchGroup()
        for qus in self.questionData{
            dispatch.enter()
            let quess = QuestionsModel()
            var ans = [String:Bool]()
            if let anss = qus.userAnswer{
                ans = anss
            }
            
            ans[FirebaseData.getCurrentUserId()] = true
            quess.userAnswer = ans
            var ans1 = [String:String]()
            if let anss = qus.userAnswerOpt{
                ans1 = anss
            }
            ans1[FirebaseData.getCurrentUserId()] = qus.yourAnswer
            quess.userAnswerOpt = ans1
            
            FirebaseData.updateUserQuestionData(qus.docId, dic: quess) { error in
                dispatch.leave()
            }
        }
        dispatch.notify(queue: .main) {
            PopupHelper.showAlertControllerWithSuccessBack(forErrorMessage: "Answers Saved & Submitted", forViewController: self)
        }
        
    }
}

extension QuestionAnswerViewController:UITableViewDelegate,UITableViewDataSource,answerDelegate{
    func answerValue(_ value: String, _ index: Int) {
        self.questionData[index].yourAnswer = value
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return questionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QNATopTableViewCell", for: indexPath) as! QNATopTableViewCell
            let image = courseModel.courseOverviewData.first?.thumbnailUrl ?? ""
            cell.courseTitle.text = "\(courseModel.title ?? "") #Questions"
            cell.configureCell(image: image)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QNATableViewCell", for: indexPath) as! QNATableViewCell
        let data = questionData[indexPath.row]
        cell.answerDelegate = self
        cell.configureCell(questionData: data,indexx: indexPath.row )
        
        
        
        return cell
    }
}
