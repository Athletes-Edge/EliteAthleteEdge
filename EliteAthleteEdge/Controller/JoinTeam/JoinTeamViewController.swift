//
//  JoinTeamViewController.swift
//  athletes
//
//  Created by ali john on 05/08/2024.
//

import UIKit
import LGSideMenuController

class JoinTeamViewController: UIViewController {
    
    @IBOutlet weak var teamLabel: UILabel!
    var teamData: TeamModel?
    var userData:UserModel!
    var teamArray:[TeamModel]!
    var inviteArray:[InvitationModel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    private func setupController() {
        PopupHelper.showAnimating(self)
        FirebaseData.getUserData(uid: FirebaseData.getCurrentUserId()) { error, userData in
            self.stopAnimating()
            self.userData = userData
            self.getallinvites()
        }
        
    }
    func getallinvites(){
        PopupHelper.showAnimating(self)
        FirebaseData.getAllInvitations(email: userData?.email ?? "0") { error, courses in
            self.stopAnimating()
            if let error = error{
                self.fetchTeamData()
                return
            }
            if courses?.count == 0{
                self.fetchTeamData()
                return
            }
            self.inviteArray = courses ?? []
            self.getallteams()
            
        }
    }
    func fetchTeamData(){
        PopupHelper.showAnimating(self)
        FirebaseData.getTeamByNameData(name: Constant.Athletes_Edge) { error, teamsData in
            self.stopAnimating()
            if let error = error{
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription, controler: self)
                return
            }
            self.teamData = teamsData
            self.teamLabel.text = "\(teamsData?.name ?? "") team has asked you to join this app."
        }
    }
    func getallteams(){
        PopupHelper.showAnimating(self)
        let dispatch = DispatchGroup()
        if let invite = self.inviteArray{
            FirebaseData.getAllTeamData(teams: invite.map({$0.teamId})) { error, teamsData in
                self.teamArray = teamsData
                for team in self.teamArray{
                    dispatch.enter()
                    var memarry = [String]()
                    if let members = team.members{
                        memarry = members
                    }
                    memarry.append(FirebaseData.getCurrentUserId())
                    
                    let temdaa = TeamModel()
                    temdaa.members = memarry
                    FirebaseData.updateTeamData(team.docId, dic: temdaa) { error in
                        dispatch.leave()
                    }
                    self.teamLabel.text = "\(team.name ?? "") team has asked you to join this app."
                }
                dispatch.notify(queue: .main) {
                    self.stopAnimating()
                    
                    //self.gotoHome()
                }
            }
        }
        
    }
    private func gotoHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let home = storyboard.instantiateViewController(withIdentifier: "LGSideMenuController") as! LGSideMenuController
        UIApplication.shared.setRootViewController(home)
    }
    
    @IBAction func didTapJoinButtion(_ sender: UIButton) {
        self.gotoHome()
        
    }
    func joinnow(){
        guard let data = self.teamData else { return self.gotoHome() }
        let team = TeamModel()
        var mem = [String]()
        if let member = data.members{
            mem = member
        }
        mem.append(FirebaseData.getCurrentUserId())
        team.members = mem
        PopupHelper.showAnimating(self)
        FirebaseData.updateTeamData(data.docId, dic: team) { error in
            self.stopAnimating()
            if let error = error {
                PopupHelper.alertWithOk(title: "Error", message: error.localizedDescription , controler: self)
            } else {
                self.gotoHome()
            }
        }
    }
}

