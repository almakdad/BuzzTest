//
//  AccessoryViewController.swift
//  Buzz
//
//  Created by Laurence Andersen on 12/4/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class AccessoryContainerViewController: UIViewController {

    let navBar: UINavigationBar = UINavigationBar()
    var pullView: PullView = PullView()
    var contentView: UIView = UIView()
    
    var accessoryViewController: UIViewController? = nil {
        willSet {
            accessoryViewController?.removeFromParentViewController()
        }
        didSet {
            guard let avc = accessoryViewController else {
                return
            }

            addChildViewController(avc)
            contentView.addSubview(avc.view)
            avc.didMove(toParentViewController: self)
            
            avc.view.translatesAutoresizingMaskIntoConstraints = false
            avc.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            avc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            avc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            avc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        
        view.addSubview(navBar)
        view.addSubview(contentView)
        
        installConstraints()
        
        pullView.backgroundColor = UIColor.red
        setPullViewVisible(visible: true, animated: false)
    }
    
    func installConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true
    }
    
    func setPullViewVisible(visible: Bool, animated: Bool) {
        // Animation
        let animationBlock = {
            if visible {
                self.view.addSubview(self.pullView)
                
                self.pullView.translatesAutoresizingMaskIntoConstraints = false
                
                self.pullView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                self.pullView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                self.pullView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                self.pullView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                
                if let avc = self.accessoryViewController as? AccessoryContainerViewContent {
                    self.pullView.label.text = avc.titleForPullView()
                }
                
            } else {
                self.pullView.removeFromSuperview()
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: animationBlock, completion: { _ in
                self.view.setNeedsUpdateConstraints()
            })
        } else {
            animationBlock()
        }
    }
}

class PullView: UIView
{
    let label: UILabel = UILabel()
    
    override func layoutSubviews() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

protocol AccessoryContainerViewContent {
    func titleForPullView() -> String
}
