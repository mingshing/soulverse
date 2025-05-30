//
//  SummitAlertView.swift
//  KonoSummit
//
//  Created by mingshing on 2022/1/25.
//

import Foundation
import UIKit
import SwiftMessages

struct SummitAlertAction {
    let title: String
    let style: UIAlertAction.Style
    var isPreferredAction: Bool = false
    let handler: (()-> ())?
}


class SummitAlertView {
    
    static let shared = SummitAlertView()
    
    private var alertWindow: UIWindow?
    
    private init() { }
    
    
    public func show(title: String, message: String, actions: [SummitAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for actionObj in actions {
            let customAction = UIAlertAction(title: actionObj.title, style: actionObj.style) { (action: UIAlertAction!) -> Void in
                actionObj.handler?()
                self.dismissAlertWindow()
            }
            alertController.addAction(customAction)
            if actionObj.isPreferredAction {
                alertController.preferredAction = customAction
            }
        }
        
        alertWindow = createAlertWindow()
        alertWindow?.rootViewController?.present(alertController, animated: true)
    }
    
    private func createAlertWindow() -> UIWindow {
        let scene = UIApplication.shared.connectedScenes.first
        let baseVC = UIViewController()
        let window = UIWindow()
        
        window.windowScene = scene as? UIWindowScene
        window.rootViewController = baseVC
        window.windowLevel = .alert
        window.backgroundColor = .clear
        window.isHidden = false
        window.makeKeyAndVisible()
        return window
    }
    
    private func dismissAlertWindow() {
        
        if alertWindow != nil {
            alertWindow!.isHidden = true
            alertWindow = nil
        }
    }
}
