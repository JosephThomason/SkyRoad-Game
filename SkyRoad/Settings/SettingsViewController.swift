import Foundation
import UIKit
import SafariServices
import SnapKit
import StoreKit


class SettingsViewController: UIViewController {
    
    lazy var settingsImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "settingsImage")
        image.sizeToFit()
        return image
    }()
    
    lazy var soundOffButton = SettingsButton(title: "SOUND off", color: Colors.magenta)

    lazy var soundOnButton = SettingsButton(title: "SOUND on", color: Colors.darkGreen)

    lazy var privacyPolicyButton = SettingsButton(title: "Privacy Policy", color: Colors.lightGray)
    
    lazy var rateAppButton = SettingsButton(title: "Rate app", color: Colors.lightGray)
    
    lazy var backgroundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "menuBackground")
        image.sizeToFit()
        return image
    }()
    
    lazy var playNowButton = PlayNowButton(title: "PLAY NOW")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(soundOffButton)
        view.addSubview(soundOnButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(rateAppButton)
        view.addSubview(settingsImageView)
        setupConstraints()
        soundOnButton.addTarget(self, action: #selector(soundOnAction), for: .touchUpInside)
        soundOffButton.addTarget(self, action: #selector(soundOffAction), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicy), for: .touchUpInside)
        rateAppButton.addTarget(self, action: #selector(askReview), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc
    func soundOnAction() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.playMusic()
        }
    }
    
    @objc
    func soundOffAction() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.stopMusic()
        }
    }
    
    @objc
    func askReview() {
        guard let scene = view.window?.windowScene else {
            print("No scene")
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    @objc
    func privacyPolicy() {
        guard let url = URL(string: "https://skyroadrocketjackpot.com/privacy-policy.html") else {
            // We should handle an invalid stringURL
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        soundOnButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        soundOffButton.snp.makeConstraints { make in
            make.bottom.equalTo(soundOnButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()

            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(60)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(soundOnButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        rateAppButton.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        settingsImageView.snp.makeConstraints { make in
            make.bottom.equalTo(soundOffButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
