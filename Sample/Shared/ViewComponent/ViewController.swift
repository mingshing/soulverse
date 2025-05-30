//
//  ViewController.swift
//  KonoSummit
//


import UIKit
import SnapKit
import NVActivityIndicatorView
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    var showLoading: Bool = false {
        didSet {
            toggleLoading()
        }
    }
    var loadingIndicator: NVActivityIndicatorView!
    
    var isCurrentTabRootVC: Bool {
        if let tabBarController = self.tabBarController,
           let selectedNav = tabBarController.selectedViewController as? UINavigationController,
           selectedNav.viewControllers.first == self {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundBlack
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.backgroundBlack
        
        
        navigationController?.navigationBar.backgroundColor = UIColor.backgroundBlack
        navigationController?.navigationBar.barTintColor = UIColor.backgroundBlack
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        loadingIndicator = NVActivityIndicatorView(frame: CGRect.zero, color: .lightGray)
        loadingIndicator.type = .ballSpinFadeLoader
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
    }

    func toggleLoading() {
        if showLoading {
            view.bringSubviewToFront(loadingIndicator)
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension ViewController: SummitNavigationViewDelegate {
    func navigationViewDidTapBack(_ SummitNavigationView: SummitNavigationView) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
