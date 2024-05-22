import UIKit
import CoreData
import AVFoundation
import FirebaseMessaging
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate  {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    var restrictRotation: UIInterfaceOrientationMask = .all
    var conversionCompletion: ((String, Int) -> Void)?
    var show = false
    var loadingViewController: LoadingViewController?
    var isGameStarted = false
    var isPushAsked = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return self.restrictRotation
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkLocalData()
        UIApplication.shared.applicationIconBadgeNumber = 0
        window = UIWindow(frame: UIScreen.main.bounds)
        loadingViewController = LoadingViewController(appDelegate: self)
        showLoadingViewController()
                        
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
            
        application.registerForRemoteNotifications()

            if UserDefaults.standard.bool(forKey: "firstLaunch") {
                
            } else {
                UserDefaults.standard.set(true, forKey: "firstLaunch")
            }
            
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        return true
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
          if let error = error {
          } else if let token = token {
              UserDefaults.standard.set(token, forKey: "push_token")
              UserDefaults.standard.synchronize()
          }
        }
        
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
         NotificationCenter.default.post(
           name: Notification.Name("FCMToken"),
           object: nil,
           userInfo: dataDict
         )
    }

    
    func showLoadingViewController() {
        window?.rootViewController = loadingViewController
        window?.makeKeyAndVisible()
    }
    
    func askNotification() {
        let controller = AllowNotificationsViewController(appDelegate: self)
        let navigationController = UINavigationController(rootViewController: controller)
        self.isPushAsked = true
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func skipNotification() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: "push_decline")
    }
    
    func endedLoading() {
        if shouldAskForNotifications() {
            askNotification()
        } else {
            showGame()
        }
    }
    
    func showGame() {
        
            print("KJKJK Заглушка 1 \(isGameStarted)")
            if !isGameStarted {
                isGameStarted = true
                let viewController = MenuViewController()
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                navigationBarAppearance.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
                    navigationBarAppearance.backgroundColor = UIColor.clear
                    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let coordinator = GameCoordinator(window: self.window ?? UIWindow(frame: UIScreen.main.bounds))
                coordinator.navigate(with: .menu)
            }
        
    }

    
    func firebaseNotificationAccess() {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { success, error in
              DispatchQueue.main.async {
                      self.showGame()
                      self.isPushAsked = true
              }
              if let error = error {
                  print("PUSH ERROR \(error.localizedDescription)")
              }
          }
        )
    }
    
    func shouldAskForNotifications() -> Bool {
        if let lastDeclineDate = UserDefaults.standard.object(forKey: "push_decline") as? Date {
            let currentDate = Date()
            let timeSinceLastDecline = currentDate.timeIntervalSince(lastDeclineDate)
            let threeDaysInSeconds: TimeInterval = 3 * 24 * 60 * 60

            return timeSinceLastDecline >= threeDaysInSeconds
        } else {
            return true
        }
    }
    
    
    func userNotificationCenter(
       _ center: UNUserNotificationCenter,
       willPresent notification: UNNotification,
       withCompletionHandler completionHandler:
       @escaping (UNNotificationPresentationOptions) -> Void
     ) {
       completionHandler([[.banner, .sound]])
     }

     func userNotificationCenter(
       _ center: UNUserNotificationCenter,
       didReceive response: UNNotificationResponse,
       withCompletionHandler completionHandler: @escaping () -> Void
     ) {
       completionHandler()
     }
    
    private func process(_ notification: UNNotification) {
      let userInfo = notification.request.content.userInfo
      UIApplication.shared.applicationIconBadgeNumber = 0
        Messaging.messaging().appDidReceiveMessage(userInfo)
        UserDefaults.standard.set("PROCESS", forKey: "OBTAIN0")
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      Messaging.messaging().apnsToken = deviceToken
    }
    

    
    func application(_ app: UIApplication,open url: URL,
                        options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        
           return false
       }
    

    
    func checkLocalData() {
        if UserDefaults.standard.bool(forKey: "firstLaunch") {
        } else {
            UserDefaultSettings.balance = 0
            
            UserDefaultSettings.levels = [1: true, 2: false, 3: false, 4: false, 5: false, 6: false]
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        
    }

    
    func showViewController() {
        
        let viewController = MenuViewController()
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
            navigationBarAppearance.backgroundColor = UIColor.clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coordinator = GameCoordinator(window: self.window ?? UIWindow(frame: UIScreen.main.bounds))
        coordinator.navigate(with: .menu)
    }
    
    func playMusic() {
        if let soundURL = Bundle.main.url(forResource: "music", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                
                audioPlayer?.volume = 0.5
                audioPlayer?.numberOfLoops = -1
                
                audioPlayer?.play()
            } catch {
                print("Play error: \(error.localizedDescription)")
            }
        } else {
            print("No file")
        }
        
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}

struct ResponseModel: Codable {
    var ok: Bool
    var url: String?
    var message: String?
    var expires: Int?
}


struct YourDataModel: Codable {
    let key1: String
    let key2: Int
}
