//
//  AppCoordinator.swift
//

import Foundation
import UIKit
import MessageUI
import DeviceKit

enum RoutingDestination: String {
    case TOC = "toc"
    case AudioPlayer = "track"
    case SummaryText = "article"
    case Profile = "profile"
    case MembershipPurchase = "purchase"
    case ExternalLink = "external_link"
    case None
    
    var hasData: Bool {
        switch self {
        case .TOC, .AudioPlayer, .SummaryText, .ExternalLink:
            return true
        default:
            return false
        }
    }
}

enum SurveyType {
    case suggestTitle
    case deleteAccount
    
    var title: String {
        switch self {
        case .suggestTitle:
            return NSLocalizedString("vote_recommend_title", comment: "")
        case .deleteAccount:
            return NSLocalizedString("personal_info_row_delete_account", comment: "")
        }
    }
    
    var surveyURL: String {
        switch self {
        case .suggestTitle:
            return HostAppContants.suggestTitleURL
        case .deleteAccount:
            return HostAppContants.deleteAccountURL
        }
    }
}

class AppCoordinator {
    
    static func inAppRouting(_ params: [String: Any]?) {
        
        guard let params = params,
              let currentVC = UIViewController.getLastPresentedViewController() else { return }

        if let payload = params["payload"] as? String {
            let dest = RoutingDestination(rawValue: payload) ?? .None
            if dest.hasData {
                if let data = params["data"] as? String {
                    switch dest {
                    case .ExternalLink:
                        AppCoordinator.openWebBrowser(to: data)
                    default:
                        break
                    }
                }
            } else {
                if let mainVC = currentVC as? MainViewController,
                   let tabVC = mainVC.selectedViewController {
                    
                    switch dest {
                    case .Profile:
                        tabVC.tabBarController?.selectedIndex = SummitTab.Profile.rawValue
                    default:
                        break
                    }
                }
            }
        }
    }
    
    static func openLoginPage(from sourceVC: UIViewController, page source: AppLocation, success: (()->())? = nil) {
        let loginVC = LoginViewController(sourcePage: source, success: success)
        let vc = UINavigationController(rootViewController: loginVC)
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .fullScreen
        
        sourceVC.showDetailViewController(vc, sender: sourceVC)
    }
    
    
    static func openWebBrowser(to url: String) {
        guard let targetURL = URL(string: url) else { return }
        UIApplication.shared.open(targetURL)
    }
    
    static func openMailService(from sourceVC: ViewController, withSubject subject: String) {
        
        if !MFMailComposeViewController.canSendMail() {
            
            let okAction = SummitAlertAction(title: NSLocalizedString("no_email_alert_action", comment: ""), style: .default, handler: nil)
            SummitAlertView.shared.show(
                title: NSLocalizedString("no_email_alert_title", comment: ""),
                message: NSLocalizedString("no_email_alert_description", comment: ""),
                actions: [okAction]
            )
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = sourceVC
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([HostAppContants.contactRecipient])
        composeVC.setSubject(subject)
        let noticeString = "\n\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n請保留以下資訊"
        let defaultReportString = String(format: "%@\nUser ID: %@ \niOS version: %@ \nApp version: %@ \nDevice: %@", noticeString, (User.instance.userId ?? ""),
                                         (Device.current.systemVersion ?? ""),
                                         Utility.getAppVersion(),
                                         Device.current.description
        )
        
        composeVC.setMessageBody(defaultReportString, isHTML: false)
         
        // Present the view controller modally.
        sourceVC.present(composeVC, animated: true, completion: nil)
    }
    static func openSurvey(from sourceVC: ViewController, for surveyType: SurveyType) {
        let accountDeletionVC = GoogleSurveyViewController(surveyTitle: surveyType.title, surveyURL: surveyType.surveyURL)
        accountDeletionVC.hidesBottomBarWhenPushed = true
        
        guard
            let navigationVC = sourceVC.navigationController
        else {
            sourceVC.show(accountDeletionVC, sender: nil)
            return
        }
        
        navigationVC.pushViewController(accountDeletionVC, animated: true)
    }
}
