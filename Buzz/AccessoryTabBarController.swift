//
//  AccessoryTabBarController.swift
//  Buzz
//
//  Created by Laurence Andersen on 12/3/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class AccessoryTabBarController: UITabBarController {

    private var accessoryContanerViewController: AccessoryContainerViewController = AccessoryContainerViewController()
    private var showAccessoryGestureRecognizer: UIGestureRecognizer = UIPanGestureRecognizer()
    private var tapAccessoryGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
    private let diningController = DiningViewController(nibName: nil, bundle: nil)
    
    private let accessoryTransitionThreshold = 0.5
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessoryContanerViewController.accessoryViewController = diningController
        configureAccessoryView()
        setAccessoryViewPresented(presented: false, animated: false)
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true
    }
    
    func configureAccessoryView () {
        let acvc = accessoryContanerViewController
        
        accessoryContanerViewController.willMove(toParentViewController: self)
        addChildViewController(accessoryContanerViewController)
        view.insertSubview(acvc.view, belowSubview: tabBar)
        accessoryContanerViewController.didMove(toParentViewController: self)
        
        showAccessoryGestureRecognizer.addTarget(self, action:#selector(AccessoryTabBarController.handleAccessoryTransition(pan:)))
        tapAccessoryGestureRecognizer.addTarget(self, action: #selector(AccessoryTabBarController.handleAccessoryTapped(tap:)))
        
        let title = (acvc.accessoryViewController?.title != nil) ? acvc.accessoryViewController!.title! : ""
        let navigationItem = UINavigationItem(title:title)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(AccessoryTabBarController.dismissAccessoryView))
        acvc.navBar.pushItem(navigationItem, animated: false)
    }
    
    func handleAccessoryTapped (tap: UITapGestureRecognizer) {
        setAccessoryViewPresented(presented: true, animated: true)
    }
    
    func handleAccessoryTransition (pan: UIPanGestureRecognizer) {
        guard let currentFrame = pan.view?.frame, let enclosingView = pan.view?.superview else {
            return
        }
        
        let acvc = accessoryContanerViewController
        
        let tabBarHeight = tabBar.bounds.height
        let pullViewHeight = acvc.pullView.bounds.height
        
        let travelDistance = enclosingView.bounds.height
        let translation = pan.translation(in: enclosingView)
        let currentPercentage = fabs(translation.y) / travelDistance
        
        switch pan.state {
        case .began:
            fallthrough
        case .changed:
            let currentTabBarDisplacement = (currentPercentage < 0.1) ? CGFloat(0.0) : tabBarHeight * currentPercentage
            var tabBarY = (travelDistance - tabBarHeight) + currentTabBarDisplacement
            
            var accessoryY = currentFrame.maxY + translation.y
            var accessoryHeight = travelDistance - accessoryY - (tabBarHeight - currentTabBarDisplacement)
            
            if translation.y >= tabBarHeight.negated() {
                tabBarY = view.frame.height - tabBarHeight
                accessoryHeight = pullViewHeight
                accessoryY = tabBarY - accessoryHeight
            }
            
            tabBar.frame = CGRect(x: tabBar.frame.minX, y: tabBarY, width: tabBar.bounds.width, height: tabBarHeight)
            acvc.view.frame = CGRect(x: acvc.view.frame.minX, y: accessoryY, width: acvc.view.bounds.width, height: (accessoryHeight < pullViewHeight) ? pullViewHeight : accessoryHeight)
        case .ended:
            var shouldPresent = false
            if currentPercentage > CGFloat(accessoryTransitionThreshold) {
                shouldPresent = true
            }
            
            setAccessoryViewPresented(presented: shouldPresent, animated: true)
        default:
            break
        }
    }
    
    func setAccessoryViewPresented(presented: Bool, animated: Bool) {
        let acvc = accessoryContanerViewController
        
        let topBarLength = self.topLayoutGuide.length
        
        // Tab Bar Geometry
        let tabBarHeight = tabBar.bounds.height
        
        var tabBarY = view.frame.height - tabBarHeight
        if presented {
            tabBarY = view.frame.size.height
        }
        
        let tabBarEndFrame = CGRect(x: view.frame.minX, y: tabBarY, width: view.frame.width, height: tabBarHeight)
        
        // Accessory View Geometry
        let pullViewHeight = CGFloat(50.0)
        
        var accessoryViewY = tabBarY - pullViewHeight
        var accessoryViewHeight = view.frame.height
        if presented {
            accessoryViewY = view.frame.minY + topBarLength
            accessoryViewHeight = view.frame.height - topBarLength
        }

        let accessoryViewEndFrame = CGRect(x: view.frame.minX, y: accessoryViewY, width: view.bounds.width, height: accessoryViewHeight)
        
        // Animation
        let animationBlock = {
            
            acvc.view.frame = accessoryViewEndFrame
            self.tabBar.frame = tabBarEndFrame
            acvc.setPullViewVisible(visible: !presented, animated: true)
        }
        
        let completionBlock: ((Bool) -> Void)  = { _ in
            acvc.endAppearanceTransition()
            
            if presented {
                acvc.view.removeGestureRecognizer(self.showAccessoryGestureRecognizer)
                acvc.view.removeGestureRecognizer(self.tapAccessoryGestureRecognizer)
            } else {
                acvc.view.addGestureRecognizer(self.showAccessoryGestureRecognizer)
                acvc.view.addGestureRecognizer(self.tapAccessoryGestureRecognizer)
            }
        }
        
        acvc.beginAppearanceTransition(false, animated: true)
        
        if (animated) {
            UIView.animate(withDuration: 0.3, animations: animationBlock, completion: completionBlock)
        } else {
            animationBlock()
            completionBlock(true)
        }
    }
    
    func dismissAccessoryView () {
        setAccessoryViewPresented(presented: false, animated: true)
    }
}
