import Foundation
import UIKit

// MARK: - Coordinator protocol

protocol Coordinator {
    associatedtype Route
    func navigate(with route: Route)
    func configureMainController() -> UIViewController
}

extension Coordinator {
    func configureMainController() -> UIViewController {
        return UIViewController()
    }
}
