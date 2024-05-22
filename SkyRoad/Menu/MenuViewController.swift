import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    var coordinator: MenuCoordinator?
    
    lazy var logoImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.sizeToFit()
        return image
    }()
    
    lazy var pointsView = PointsView()
    
    lazy var topButton = MenuButton(title: "Top")

    lazy var settingsButton = MenuButton(title: "Settings")

    lazy var mapButton = MenuButton(title: "Maps")
    
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
        view.addSubview(pointsView)
        view.addSubview(logoImageView)
        view.addSubview(playNowButton)
        view.addSubview(topButton)
        view.addSubview(settingsButton)
        view.addSubview(mapButton)
        pointsView.setupConstraints()
        setupConstraints()
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        topButton.addTarget(self, action: #selector(openTop), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        playNowButton.addTarget(self, action: #selector(playNow), for: .touchUpInside)
        fetchLocalData()
    }
    
    @objc
    func openSettings() {
        print("Srttings \(String(describing: coordinator))")
        coordinator?.navigate(with: .settings)
    }
    
    @objc
    func openTop() {
        coordinator?.navigate(with: .top)
    }
    
    @objc
    func openMaps() {
        coordinator?.navigate(with: .maps)
    }
    
    @objc
    func playNow() {
        coordinator?.navigate(with: .play)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.popViewController(animated: true)
        fetchLocalData()
    }
    
    func fetchLocalData() {
       var balance = UserDefaultSettings.balance
        pointsView.textLabel.text = "Points : \(balance)"
        pointsView.updateLabel(value: balance)
    }
    
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pointsView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.52)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(pointsView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
        
        playNowButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.52)
        }
        
        topButton.snp.makeConstraints { make in
            make.top.equalTo(playNowButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(playNowButton.snp.width).multipliedBy(0.5)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.top.equalTo(topButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(playNowButton.snp.width).multipliedBy(0.5)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(settingsButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(playNowButton.snp.width).multipliedBy(0.5)
        }
        
    }
}

