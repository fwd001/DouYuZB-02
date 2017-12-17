//
//  MainViewController.swift
//  DYZB-02
//
//  Created by 伏文东 on 2017/12/17.
//  Copyright © 2017年 伏文东. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC(storyName: "Home")
        addChildVC(storyName: "Live")
        addChildVC(storyName: "Follow")
        addChildVC(storyName: "Profile")

    }
    
    private func addChildVC(storyName: String) {
        
        guard let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController() else { return }
        addChildViewController(childVC)
        
    }

}
