//
//  PresentAnimatore.swift
//  Voluu
//
//  Created by Mac on 10/10/2023.
//

import UIKit

class CustomPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        
        // Initial position of the presented view (start it offscreen at the bottom)
        toView.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        
        containerView.addSubview(toView)
        
        // Animate the background (fade-in)
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backgroundView.alpha = 0.0
        containerView.insertSubview(backgroundView, belowSubview: toView)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut],
                       animations: {
            // Slide the presented view in from bottom to top
            toView.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
            backgroundView.alpha = 1.0
        },
                       completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toViewController = transitionContext.viewController(forKey: .to),
//              let toView = transitionContext.view(forKey: .to)
//               else {
//            transitionContext.completeTransition(false)
//            return
//        }
//        let containerView = transitionContext.containerView
//        // Configure the presented view
//        toView.frame = containerView.bounds
//        toView.alpha = 0.0
//        toView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        containerView.addSubview(toView)
//        
//        // Animate the background
//        let backgroundView = UIView(frame: containerView.bounds)
//        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        backgroundView.alpha = 0.0
//        containerView.insertSubview(backgroundView, belowSubview: toView)
//        
//        UIView.animate(withDuration: duration,
//                       delay: 0,
//                       usingSpringWithDamping: 0.8,
//                       initialSpringVelocity: 0.5,
//                       options: [.transitionFlipFromBottom],
//                       animations: {
//            toView.alpha = 1.0
//            toView.transform = CGAffineTransform.identity
//            backgroundView.alpha = 1.0
//        },
//                       completion: { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
//    }
}

class CustomDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        UIView.animate(withDuration: duration,
                       animations: {
            // Slide the fromView out from top to bottom
            fromView.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        },
                       completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


//class CustomDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    let duration: TimeInterval = 0.5
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return duration
//    }
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let fromView = transitionContext.view(forKey: .from) else {
//            transitionContext.completeTransition(false)
//            return
//        }
//        
//        UIView.animate(withDuration: duration,
//                       animations: {
//            fromView.alpha = 0.0
//        },
//                       completion: { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
//    }
//}
