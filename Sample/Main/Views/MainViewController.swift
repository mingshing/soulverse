//
//  MainViewController.swift
//  KonoSummit
//

import UIKit
import Toaster

enum SummitTab: Int {
    
    case Home
    case Notification
    case Profile
    
    var viewController: UIViewController {
        switch self {
        case .Home:
            return HomeViewController()
        case .Notification:
            return NotificationViewController()
        case .Profile:
            return ProfileViewController()
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .Home:
            return UIImage(named: "tabiconHomeOutline")
        case .Notification:
            return UIImage(named: "tabiconNotificationOutlined")
        case .Profile:
            return UIImage(named: "tabiconAccountOutline")
        }
    }
    
    var tabSelectedImage: UIImage? {
        switch self {
        case .Home:
            return UIImage(named: "tabiconHomeFilled")?.withRenderingMode(.alwaysOriginal)
        case .Notification:
            return UIImage(named: "tabiconNotificationFilled")?.withRenderingMode(.alwaysOriginal)
        case .Profile:
            return UIImage(named: "tabiconAccountFilled")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}


class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.clipsToBounds = false
        self.tabBar.barTintColor = .backgroundBlack
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.tabBar.layer.shadowRadius = 8
        self.tabBar.layer.shadowOpacity = 0.6
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .backgroundBlack
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
            appearance.shadowColor = .clear
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
        
        //MARK: Vocabulary function modification
        let tabs: [SummitTab] = [.Home, .Notification, .Profile]
        var navs: [UINavigationController] = []
        
        for tabItem in tabs {
            let vc = tabItem.viewController
            
            vc.navigationItem.largeTitleDisplayMode = .always
            vc.tabBarItem = UITabBarItem(title:"" , image: tabItem.tabImage, selectedImage: tabItem.tabSelectedImage)
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            navs.append(UINavigationController(rootViewController: vc))
        }
        setViewControllers(navs, animated: false)

    }
}
