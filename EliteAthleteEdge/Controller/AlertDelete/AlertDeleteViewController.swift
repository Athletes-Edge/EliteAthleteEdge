//
//  AlertDeleteViewController.swift
//  Athlete
//
//  Created by ali john on 05/11/2024.
//

import UIKit

class AlertDeleteViewController: UIViewController {

    var deleagte:ProfileViewController!
    var indx:Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func yesBtn(_ sender:Any){
        self.dismiss(animated: true) {
            self.deleagte.deleteTeam(self.indx)
        }
    }
    @IBAction func noBtn(_ sender:Any){
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
