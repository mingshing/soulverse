//
//  MainViewController.swift
//  Soulverse
//

import UIKit

class MainViewController: SoulverseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        soulverseDelegate = self
    }
}

// MARK: - SoulverseTabBarDelegate
extension MainViewController: SoulverseTabBarDelegate {
    func tabBar(_ tabBar: SoulverseTabBarController, didSelectTab tab: SoulverseTab) {
        // Handle tab selection if needed
        print("Selected tab: \(tab)")
    }
}