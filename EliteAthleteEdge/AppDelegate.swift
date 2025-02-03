//
//  AppDelegate.swift
//  athletes
//
//  Created by ali john on 02/08/2024.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import FirebaseCore
import LGSideMenuController
import Stripe
import FirebaseDynamicLinks
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        FirebaseApp.configure()
        StripeAPI.defaultPublishableKey = "pk_test_51PgBExCo08Oa4W8HRRlISwH7IOZRW42joDX0KpJRo7RK4tZhrz29Cout7tSsBEWCeODsr7IhT8jQGNiUrMIwwR0h00jZcUoUkr"
        checkUserLogin()
        //self.createDynamicLink()
//        if let url = launchOptions?[.url] as? URL{
//            if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//                handleIncomingDynamicLink(dynamicLink)
//            }
//        }
        return true
    }
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("Dynamic link has no URL")
            return
        }

        // Handle the URL here (e.g., navigate to the specific content within your app)
        print("Dynamic Link URL: \(url)")
        // For example, navigate to a specific view controller
        // self.navigateToContent(for: url)
    }
    private func checkUserLogin(_ controllers: UINavigationController? = nil) {
        if FirebaseData.checkLogin() {
            
            let vc = UIStoryboard.storyBoard(withName: .Home).loadViewController(withIdentifier: .LGSideMenuController)
            UIApplication.shared.setRootViewController(vc)
        } else {
            
            let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController)
            UIApplication.shared.setRootViewController(vc)
        }
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
//                if let dynamicLink = dynamicLink, let url = dynamicLink.url {
//                    self.handleDynamicLink(url: url)
//                }
//            }
//            return handled
//        }
    private func handleDynamicLink(url: URL) {
            // Process your dynamic link URL
            print("Dynamic Link URL: \(url)")
            // Add your navigation or specific action logic here
        }
    func createDynamicLink() {
        let link = URL(string: "https://athletes.page.link/mylogin")!
        let dynamicLinkDomain = "https://athletes.page.link"
        
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinkDomain)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "comm.buzzware.athletes")
        linkBuilder?.iOSParameters?.appStoreID = "6612039777" // Your App Store ID

        // Optionally add social metadata
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = "Athletes Edge"
        linkBuilder?.socialMetaTagParameters?.descriptionText = "Check out this amazing content!"
        linkBuilder?.socialMetaTagParameters?.imageURL = URL(string: "https://example.com/image.png")
        
        let longDynamicLink = linkBuilder?.url
        print("Generated Long Link: \(String(describing: longDynamicLink))")

        // Shorten the dynamic link
        linkBuilder?.shorten(completion: { shortURL, warnings, error in
            if let error = error {
                print("Error shortening link: \(error.localizedDescription)")
                return
            }
            if let shortURL = shortURL {
                print("Shortened URL: \(shortURL)")
            }
        })
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool{
        guard let inCommingURL = userActivity.webpageURL else { return false }
        print("Incomming Web Page URL: \(inCommingURL)")
        let comp = inCommingURL.pathComponents
        var email = ""
        var teamid = ""
        var teamname = ""
        if comp.count > 1{
            if let components = URLComponents(url: inCommingURL, resolvingAgainstBaseURL: false) {
                if let queryItems = components.queryItems {
                        // Extract values from query items
                    email = queryItems.first(where: { $0.name == "email" })?.value ?? ""
                    teamid = queryItems.first(where: { $0.name == "teamid" })?.value ?? ""
                    teamname = queryItems.first(where: { $0.name == "teamname" })?.value ?? ""
                        
                    }
                }
            let path = comp[1]
            switch InviteApp(rawValue: path){
            case .userlogins:
                if FirebaseData.checkLogin(){
                    if let rootViewController = window?.rootViewController as? LGSideMenuController{
                        if let nav = rootViewController.rootViewController as? UINavigationController{
                            if let SignupViewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .SignupViewController) as? SignupViewController {
                                // Push the ProfileViewController onto the navigation stack
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20){
                                    let comp = inCommingURL.lastPathComponent
                                    SignupViewController.email = email
                                    rootViewController.rootViewController?.present(SignupViewController, animated: true)
                                }
                                return true
                            }
                        }
                    }
                }
                else{
                    let NavLoginViewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController) as! UINavigationController
                    let LoginViewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController) as! LoginViewController
                    
                    NavLoginViewController.setViewControllers([LoginViewController], animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50){
                        LoginViewController.signup(email: email)
                    }
                    self.window?.rootViewController = NavLoginViewController
                }
            case .jointeam:
                //this code not in used
                if FirebaseData.checkLogin(){
                    if let rootViewController = window?.rootViewController as? LGSideMenuController{
                        if let nav = rootViewController.rootViewController as? UINavigationController{
                            if let profileViewController = UIStoryboard.storyBoard(withName: .Profile).loadViewController(withIdentifier: .SignupViewController) as? SignupViewController {
                                // Push the ProfileViewController onto the navigation stack
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20){
                                    let comp = inCommingURL.lastPathComponent
                                    if comp != FirebaseData.getCurrentUserId(){
                                        profileViewController.email = comp
                                        
                                        nav.present(profileViewController, animated: true)
                                    }
                                }
                                return true
                            }
                        }
                    }
                }
                else{
                    let NavLoginViewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .NavLoginViewController) as! UINavigationController
                    let LoginViewController = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .LoginViewController) as! LoginViewController
                    LoginViewController.email = email
                    LoginViewController.teamid = teamid
                    LoginViewController.teamname = teamname
                    NavLoginViewController.setViewControllers([LoginViewController], animated: true)
                    
                    
                    self.window?.rootViewController = NavLoginViewController
                }
            default:
                break
            }
           
           
       }
        return false
    }
}

    extension UIApplication {
        func setRootViewController(_ viewController: UIViewController) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                fatalError("No window found")
            }
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
        
        func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                .filter({ $0.activationState == .foregroundActive })
                                .compactMap({ $0 as? UIWindowScene })
                                .first?.windows
                                .filter({ $0.isKeyWindow }).first?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            
            if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
            
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            
            return base
        }
    }



