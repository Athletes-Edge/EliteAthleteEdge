//
//  AppStoryBoard.swift
//  TradeAir
//
//  Created by Adeel on 08/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit

class AppStoryBoard: NSObject {

}
extension UIStoryboard {
    
    //MARK:- Generic Public/Instance Methods
    
    func loadViewController(withIdentifier identifier: viewControllers) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier.rawValue)
    }
    
    func loadViewControllersss(withIdentifier identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier)
    }
    
    //MARK:- Class Methods to load Storyboards
    
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
}

enum storyboards : String {
    case login = "Registration",
         Saved = "Saved",
         Courses = "Courses",
         Profile = "Profile",
         Search = "Search",
         Home = "Home",
         main = "Main"
}



//navLoginVC = "navLoginVC",
//navLeftMenuVC = "navLeftMenuVC",
//leftMenuVC = "LeftMenuVC",
//navHomeVC = "navHomeVC",
//homeVC = "HomeVC",
//swRevealViewController = "SWRevealViewController",
//homeDetailVC = "HomeDetailVC",
enum viewControllers: String {
    
    //Login Storyboard
    case FriendsViewController = "FriendsViewController",
         LoginViewController = "LoginViewController",
         NavLoginViewController = "NavLoginViewController",
         SearchResultsViewController = "SearchResultsViewController",
         ChatViewController = "ChatViewController",
         SignupViewController = "SignupViewController",
         ProfileViewController = "ProfileViewController",
         LGSideMenuController = "LGSideMenuController",
         SettingsViewController = "SettingsViewController",
         MembershipViewController = "MembershipViewController",
         NotificationsViewController = "NotificationsViewController",
         FavouritesViewController = "FavouritesViewController",
         CoursesViewController = "CoursesViewController",
         JoinTeamViewController = "JoinTeamViewController",
         SearchDetailsViewController = "SearchDetailsViewController",
         SearchDetails1ViewController = "SearchDetails1ViewController",
         HomeViewController = "HomeViewController",
         SavedViewController = "SavedViewController",
         noTeamViewController = "NoTeamViewController",
         AddCardViewController = "AddCardViewController",
         SelectCardPaymentViewController = "SelectCardPaymentViewController",
         SubscriptionViewController = "SubscriptionViewController",
         CategoryCourseViewController = "CategoryCourseViewController",
         MyReviewViewController = "MyReviewViewController",
         AlertDeleteViewController = "AlertDeleteViewController"
    
    
    
}
