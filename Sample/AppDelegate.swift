//
//  AppDelegate.swift
//
import UIKit
import FBSDKCoreKit
import FirebaseMessaging
import Firebase
import Toaster

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appTracker: CoreTracker?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Config 3rd party framework
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        setTrackingAgent()
        
        application.beginReceivingRemoteControlEvents()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        UNUserNotificationCenter.current().delegate = self
        
        //UIApplication.shared.registerForRemoteNotifications()
        
        setupRemoteConfig()
        setDefaultToastAppearance()
        setNavigationBarAppearance()
        checkNotificationPermission()
        return true
    }
    func setTrackingAgent() {
        // TODO: Use factory to build the tracker for individual target
        appTracker = SummitTracker.shared
    }
    
    func setupRemoteConfig() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 720
        settings.fetchTimeout = 10
        remoteConfig.configSettings = settings
        remoteConfig.fetchAndActivate { (status, error) -> Void in
            if status != .error {
                self.checkForceUpdate()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.RemoteConfigFetched), object: nil, userInfo: nil)
        }
        
    }
    
    private func checkForceUpdate() {
        
        let remoteConfig = RemoteConfig.remoteConfig()
        let minimumVersion = remoteConfig[RemoteConfigKeys.minimumSupportVersion].stringValue
        let currentVersion = Utility.getAppVersion()

        
        if currentVersion.isVersion(lessThan: minimumVersion) {
            let confirmAction = SummitAlertAction(title: NSLocalizedString("app_update_alert_action", comment: ""), style: .default) { [weak self] in
                guard let url = URL(string: HostAppContants.appStoreUrl) else { return }
                UIApplication.shared.open(url)
                self?.checkForceUpdate()
            }
            DispatchQueue.main.async {
                SummitAlertView.shared.show(
                    title: NSLocalizedString("app_update_alert_title", comment: ""),
                    message: NSLocalizedString("app_update_alert_description", comment: ""),
                    actions: [confirmAction]
                )
            }
        }
    }

    private func setDefaultToastAppearance() {
        
        let appearance = ToastView.appearance()
        appearance.backgroundColor = .primaryWhite
        appearance.textColor = .primaryBlack
        appearance.bottomOffsetPortrait = 80
        appearance.shadowColor = .black
        appearance.shadowOpacity = 0.4
        appearance.shadowOffset = CGSize(width: 0, height: 2)
        appearance.shadowRadius = 4
        
    }
    
    private func setNavigationBarAppearance() {
        
        UINavigationBar.appearance().tintColor = .themeMainColor
    }
    
    
    private func checkNotificationPermission() {

        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                // Todo: Handle the user not enable the notification
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            
#if DEBUG
        let deviceTokenString = deviceToken.reduce("") {
            $0 + String(format: "%02x", $1)
        }
        print("deviceToken", deviceTokenString)
#endif
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Handle user tapping remote notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        AppCoordinator.inAppRouting(userInfo as? [String: Any])
        //print(content.userInfo)
        completionHandler()
    }
    
    // show the notification while app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner])
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AppDelegate: MessagingDelegate {
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        guard let token = fcmToken else { return }
        User.instance.fcmToken = token
//        print(">>>>token=\(token)")
    }
}
