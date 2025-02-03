//
//  QNATopTableViewCell.swift
//  athletes
//
//  Created by Mac on 06/08/2024.
//

import UIKit
protocol answerDelegate{
    func answerValue(_ value:String,_ index:Int)
}
class QNATopTableViewCell: UITableViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(image: String) {
        titleImage.imageURL(image)
    }
}

class QNATableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var asnwerALabel: UILabel!
    @IBOutlet weak var asnwerBLabel: UILabel!
    @IBOutlet weak var asnwerCLabel: UILabel!
    @IBOutlet weak var asnwerDLabel: UILabel!
    
    @IBOutlet weak var asnwerAView: UIView!
    @IBOutlet weak var asnwerBView: UIView!
    @IBOutlet weak var asnwerCView: UIView!
    @IBOutlet weak var asnwerDView: UIView!
    
    
    var index:Int!
    var answerDelegate:answerDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(questionData: QuestionsModel,indexx:Int) {
        
        index = indexx
        questionLabel.text = questionData.question ?? ""
        asnwerALabel.text = "A. \(questionData.answer1 ?? "")"
        asnwerBLabel.text = "B. \(questionData.answer2 ?? "")"
        asnwerCLabel.text = "C. \(questionData.answer3 ?? "")"
        asnwerDLabel.text = "D. \(questionData.answer4 ?? "")"

        self.asnwerAView.isUserInteractionEnabled = true
        self.asnwerBView.isUserInteractionEnabled = true
        self.asnwerCView.isUserInteractionEnabled = true
        self.asnwerDView.isUserInteractionEnabled = true
        
        self.asnwerAView.tag = AnswerOrder.A.rawValue
        self.asnwerBView.tag = AnswerOrder.B.rawValue
        self.asnwerCView.tag = AnswerOrder.C.rawValue
        self.asnwerDView.tag = AnswerOrder.D.rawValue
        
        asnwerAView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelectedAnswer(_:))))
        asnwerBView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelectedAnswer(_:))))
        asnwerCView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelectedAnswer(_:))))
        asnwerDView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSelectedAnswer(_:))))
        if let answer = questionData.userAnswerOpt,let ans = answer[FirebaseData.getCurrentUserId()]{
            if let selectedAnswer = AnswerOrder(rawValue: Int(ans) ?? 0) {
                switch selectedAnswer {
                case .A:
                    asnwerAView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
                case .B:
                    asnwerBView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
                case .C:
                    asnwerCView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
                case .D:
                    asnwerDView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
                
                }
                answerDelegate?.answerValue("\(selectedAnswer.rawValue)", index)
            }
        }
        
    }

    @objc func didTapSelectedAnswer(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
    
        asnwerAView.backgroundColor = .white
        asnwerBView.backgroundColor = .white
        asnwerCView.backgroundColor = .white
        asnwerDView.backgroundColor = .white
        
       
        
        if let selectedAnswer = AnswerOrder(rawValue: tappedView.tag) {
            switch selectedAnswer {
            case .A:
                asnwerAView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
            case .B:
                asnwerBView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
            case .C:
                asnwerCView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
            case .D:
                asnwerDView.backgroundColor = UIColor().colorsFromAsset(name: .blue33)
            }
            answerDelegate?.answerValue("\(selectedAnswer.rawValue)", index)
        }
    }
}


enum AnswerOrder: Int {
    case A = 1
    case B = 2
    case C = 3
    case D = 4
    
}
