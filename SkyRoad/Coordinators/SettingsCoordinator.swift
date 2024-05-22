import Foundation
import UIKit
protocol SettingsCoordinatorProtocol: Coordinator {
}

// MARK: - Coordinator for Onboarding screen

class SettingsCoordinator: SettingsCoordinatorProtocol {
    
    enum Route {
        case settings
    }
    
    // MARK: - Variables
    
    private let navigationController = UINavigationController()
    
    // MARK: - coordinator's navigation method
    
    func navigate(with route: Route) {
            switch route {
            case .settings:
                let viewController = SettingsViewController()
                navigationController.pushViewController(viewController, animated: true)
            }
        }
        func configureMainController() -> UIViewController {
            navigate(with: .settings)
            return navigationController
        }
}
