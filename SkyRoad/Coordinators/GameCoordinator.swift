import Foundation
import UIKit


class GameCoordinator: Coordinator {
    enum Route {
        case menu
        case backMenu
        case play
        case top
        case settings
        case maps
    }
    private let window: UIWindow
    var navigationController = UINavigationController()
    private lazy var menuCoordinator: MenuCoordinator = {
       let coordinator = MenuCoordinator()
       coordinator.mainCoordinator = self
        return coordinator
    }()
    
    init(window: UIWindow) {
        self.window = window
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
            navigationBarAppearance.backgroundColor = UIColor.clear
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance 
    }
    
    // MARK: - Navigation method
    
    func navigate(with route: Route) {
        switch route {
        
        case .menu:
            setRootViewController(viewController: menuCoordinator.configureMainController())
        case .play:
            let viewController = GameController()
            viewController.coordinator = self
            setRootViewController(viewController: viewController)
        case .top:
            let viewController = TopViewController()
            navigationController.pushViewController(viewController, animated: true)
        case .settings:
            let viewController = SettingsViewController()
            navigationController.pushViewController(viewController, animated: true)
        case .maps:
            let coordinator = SettingsCoordinator()
            let viewController = coordinator.configureMainController()
            navigationController.pushViewController(viewController, animated: true)
        case .backMenu:
            navigationController.popViewController(animated: true)
        }
    }
    
    func configureMainController() -> UIViewController {
        navigate(with: .menu)
        return navigationController
    }
    
    func setRootViewController(viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.6,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
    func setTabBarRootViewController(viewController: UIViewController) {
        navigationController.viewControllers = [viewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        UIView.transition(
            with: window,
            duration: 0.6,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}
