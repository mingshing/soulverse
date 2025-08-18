//
//  MainViewController.swift
//

import UIKit

enum Tab: Int {
    
    case Home
    case FeelingPlanet
    case Canvas
    case Seed
    case Wall
    
    var viewController: UIViewController {
        switch self {
        case .Home:
            return HomeViewController()
        case .FeelingPlanet:
            return FeelingPlanetViewController()
        case .Canvas:
            return CanvasViewController()
        case .Seed:
            return SeedViewController()
        case .Wall:
            return WallViewController()
        }
    }
    
    var tabTitle: String {
        switch self {
        case .Home:
            return NSLocalizedString("Home", comment: "")
        case .FeelingPlanet:
            return NSLocalizedString("FeelingPlanet", comment: "")
        case .Canvas:
            return NSLocalizedString("Canvas", comment: "")
        case .Seed:
            return NSLocalizedString("Seed", comment: "")
        case .Wall:
            return NSLocalizedString("Wall", comment: "")
        }
    }
    
    var tabImage: UIImage? {
        switch self {
        case .Home:
            return UIImage(named: "tabiconHomeOutline")
        case .FeelingPlanet:
            return UIImage(named: "tabiconPlanetFilled")
        case .Canvas:
            return UIImage(named: "tabiconCanvasFilled")
        case .Seed:
            return UIImage(named: "tabiconSeedFilled")
        case .Wall:
            return UIImage(named: "tabiconWallFilled")
        }
    }
    
    var tabSelectedImage: UIImage? {
        switch self {
        case .Home:
            return UIImage(named: "tabiconHomeFilled")?.withRenderingMode(.alwaysOriginal)
        case .FeelingPlanet:
            return UIImage(named: "tabiconPlanetFilled")?.withRenderingMode(.alwaysOriginal)
        case .Canvas:
            return UIImage(named: "tabiconCanvasFilled")?.withRenderingMode(.alwaysOriginal)
        case .Seed:
            return UIImage(named: "tabiconSeedFilled")?.withRenderingMode(.alwaysOriginal)
        case .Wall:
            return UIImage(named: "tabiconWallFilled")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
}


class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.shadowColor = .clear
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        let tabs: [Tab] = [.Home, .FeelingPlanet, .Canvas, .Seed, .Wall]
        var navs: [UINavigationController] = []
        
        for tabItem in tabs {
            let vc = tabItem.viewController
            
            vc.tabBarItem = UITabBarItem(title: tabItem.tabTitle, image: tabItem.tabImage, selectedImage: tabItem.tabSelectedImage)
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            navs.append(UINavigationController(rootViewController: vc))
        }
        setViewControllers(navs, animated: false)
    }
}
