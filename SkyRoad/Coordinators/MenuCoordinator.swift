import Foundation

import UIKit

protocol MenuCoordinatorProtocol {
    
}
class MenuCoordinator: MenuCoordinatorProtocol {
    
    enum Route {
        case menu
        case play
        case top
        case settings
        case maps
        case backMenu
    }
    
    var mainCoordinator: GameCoordinator?
    var navigationController = UINavigationController()

    // MARK: - Navigation method
    
    func navigate(with route: Route) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .white
        navigationController.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController.navigationBar.backgroundColor = .clear

        switch route {
        
        case .menu:

            let viewController = MenuViewController()
            viewController.coordinator = self
            navigationController.pushViewController(viewController, animated: true)
        case .play:
            let viewController = GameController()
            viewController.coordinator = mainCoordinator
            mainCoordinator?.setRootViewController(viewController: viewController)

        case .top:
            let viewController = TopViewController()
            navigationController.pushViewController(viewController, animated: true)
        case .settings:
            let viewController = SettingsViewController()
            navigationController.pushViewController(viewController, animated: true)
        case .maps:
            let viewController = MapsViewController()
            navigationController.pushViewController(viewController, animated: true)
        case .backMenu:
            navigationController.popViewController(animated: true)
        }
    }
    
    func configureMainController() -> UIViewController {
        navigate(with: .menu)
        return navigationController
    }
    
}
