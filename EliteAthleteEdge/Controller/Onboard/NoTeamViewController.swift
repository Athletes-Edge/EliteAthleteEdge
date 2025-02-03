//
//  NoTeamViewController.swift
//  athletes
//
//  Created by ali john on 05/08/2024.
//

import UIKit

class NoTeamViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .LGSideMenuController)
            self.dismiss(animated: true) {
                UIApplication.shared.setRootViewController(vc)
            }
        }
    }
}
