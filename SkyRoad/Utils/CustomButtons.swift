import Foundation
import UIKit

class PointsButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setBackgroundImage(UIImage(named: "pointsButton"), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        titleLabel?.textColor = .white
        clipsToBounds = true
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
        setTitleColor(.gray, for: .normal)
    }
    
    func setClickable() {
        setTitleColor(.white, for: .normal)
    }
}

class PlayNowButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setBackgroundImage(UIImage(named: "playNowButton"), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(Colors.magenta, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 20)
        titleLabel?.textColor = Colors.magenta
        clipsToBounds = true
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
        setTitleColor(.gray, for: .normal)
    }
    
    func setClickable() {
        setTitleColor(.white, for: .normal)
    }
}

class MenuButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setBackgroundImage(UIImage(named: "menuButton"), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(Colors.magenta, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 15)
        titleLabel?.textColor = .white
        clipsToBounds = true
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
        setTitleColor(.gray, for: .normal)
    }
    
    func setClickable() {
        setTitleColor(.white, for: .normal)
    }
}

class SettingsButton: UIButton {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        setBackgroundImage(UIImage(named: "settingsButton"), for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 15)
        titleLabel?.textColor = .white
        clipsToBounds = true
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setNotClickable() {
        setTitleColor(.gray, for: .normal)
    }
    
    func setClickable() {
        setTitleColor(.white, for: .normal)
    }
}
