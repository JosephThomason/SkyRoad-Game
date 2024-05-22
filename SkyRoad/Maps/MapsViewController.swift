import Foundation
import UIKit

class MapsViewController: UIViewController {
    
    lazy var topImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "mapsImage")
        image.sizeToFit()
        return image
    }()
    
    lazy var level1ImageView = MapView()
    
    lazy var level2ImageView = MapView()
    
    lazy var level3ImageView = MapView()
    
    lazy var level4ImageView = MapView()

    lazy var level5ImageView = MapView()
    
    lazy var level6ImageView = MapView()
    
    lazy var topUsersView = PointsView()
    
    lazy var backgroundImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "menuBackground")
        image.sizeToFit()
        return image
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.isUserInteractionEnabled = true
        scrollView.backgroundColor = .clear
        scrollView.clipsToBounds = true
        
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var playNowButton = PlayNowButton(title: "PLAY NOW")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)

        level2ImageView.mapImageView.image = UIImage(named: "level2")
        level3ImageView.mapImageView.image = UIImage(named: "level3")
        level4ImageView.mapImageView.image = UIImage(named: "level4")
        level5ImageView.mapImageView.image = UIImage(named: "level5")
        level6ImageView.mapImageView.image = UIImage(named: "level6")

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.bringSubviewToFront(contentView)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 400)
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        contentView.addSubview(topUsersView)
        contentView.addSubview(topImageView)
        contentView.addSubview(level1ImageView)
        contentView.addSubview(level2ImageView)
        contentView.addSubview(level3ImageView)
        contentView.addSubview(level4ImageView)
        contentView.addSubview(level5ImageView)
        contentView.addSubview(level6ImageView)
        
        topUsersView.setupConstraints()
//        topUsersView.textLabel.text = "TOP USERS"
        setupConstraints()
        level1ImageView.setupConstraints()
        level2ImageView.setupConstraints()
        level3ImageView.setupConstraints()
        level4ImageView.setupConstraints()
        level5ImageView.setupConstraints()
        level6ImageView.setupConstraints()


        level1ImageView.roundImage()
        level1ImageView.setAvailableLevel()
        level2ImageView.setUnavailableLevel(price: 500)
        level3ImageView.pointsCount.text = "1000"
        level3ImageView.setUnavailableLevel(price: 1000)
        
        let level1Gesture = UITapGestureRecognizer(target: self, action: #selector(selectLevel1))
        level1ImageView.addGestureRecognizer(level1Gesture)

        
        let level2Gesture = UITapGestureRecognizer(target: self, action: #selector(buyLevel2))
        level2ImageView.addGestureRecognizer(level2Gesture)
        
        let level3Gesture = UITapGestureRecognizer(target: self, action: #selector(buyLevel3))
        level3ImageView.addGestureRecognizer(level3Gesture)
        
        let level4Gesture = UITapGestureRecognizer(target: self, action: #selector(buyLevel4))
        level4ImageView.addGestureRecognizer(level4Gesture)
        
        let level5Gesture = UITapGestureRecognizer(target: self, action: #selector(buyLevel5))
        level5ImageView.addGestureRecognizer(level5Gesture)

        let level6Gesture = UITapGestureRecognizer(target: self, action: #selector(buyLevel6))
        level6ImageView.addGestureRecognizer(level6Gesture)

        fetchLocalData()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc
    func selectLevel1() {
        let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 1!", preferredStyle: .alert)
        let okAction2 = UIAlertAction(title: "OK", style: .cancel)
        contactAlertController.addAction(okAction2)
        present(contactAlertController, animated: true)
        UserDefaultSettings.selected = 1
        level2ImageView.mapImageView.image = UIImage(named: "level2")
        level3ImageView.mapImageView.image = UIImage(named: "level3")
        level1ImageView.mapImageView.image = UIImage(named: "selectedLevel1")
        level5ImageView.mapImageView.image = UIImage(named: "level5")
        level6ImageView.mapImageView.image = UIImage(named: "level6")
        level4ImageView.mapImageView.image = UIImage(named: "level4")



    }
    
    @objc
    func buyLevel2() {
        let levels = UserDefaultSettings.levels
        let balance = UserDefaultSettings.balance
        if levels[2] == true {
            let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 2!", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .cancel)
            contactAlertController.addAction(okAction2)
            present(contactAlertController, animated: true)
            UserDefaultSettings.selected = 2
            level1ImageView.mapImageView.image = UIImage(named: "level1")
            level3ImageView.mapImageView.image = UIImage(named: "level3")
            level2ImageView.mapImageView.image = UIImage(named: "selectedLevel2")
            level5ImageView.mapImageView.image = UIImage(named: "level5")
            level6ImageView.mapImageView.image = UIImage(named: "level6")
            level4ImageView.mapImageView.image = UIImage(named: "level4")



        } else {
            if balance > 500 {
                successfulBuyAlert()
                level2ImageView.setAvailableLevel()
                var newLevels: [Int: Bool] = levels
                newLevels[2] = true
                UserDefaultSettings.levels = newLevels
                print("ADDED 1 \(newLevels.description)")
                print("ADDED 2 \(UserDefaultSettings.levels.description)")
            } else {
                notEnoughBalanceAlert(diff: 500 - balance)
            }
        }
    }
    
    @objc
    func buyLevel3() {
        let balance = UserDefaultSettings.balance
        let levels = UserDefaultSettings.levels

        if levels[3] == true {
            let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 3!", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .cancel)
            contactAlertController.addAction(okAction2)
            present(contactAlertController, animated: true)
            UserDefaultSettings.selected = 3
            level1ImageView.mapImageView.image = UIImage(named: "level1")
            level2ImageView.mapImageView.image = UIImage(named: "level2")
            level3ImageView.mapImageView.image = UIImage(named: "selectedLevel3")
            level5ImageView.mapImageView.image = UIImage(named: "level5")
            level6ImageView.mapImageView.image = UIImage(named: "level6")
            level4ImageView.mapImageView.image = UIImage(named: "level4")



        } else {
            if balance > 1000 {
                successfulBuyAlert()
                level3ImageView.setAvailableLevel()
                var newLevels: [Int: Bool] = levels
                newLevels[3] = true
                UserDefaultSettings.levels = newLevels
            } else {
                notEnoughBalanceAlert(diff: 1000 - balance)
            }
        }
    }
    
    @objc
    func buyLevel4() {
        let balance = UserDefaultSettings.balance
        let levels = UserDefaultSettings.levels

        if levels[4] == true {
            let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 4!", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .cancel)
            contactAlertController.addAction(okAction2)
            present(contactAlertController, animated: true)
            UserDefaultSettings.selected = 4
            level1ImageView.mapImageView.image = UIImage(named: "level1")
            level2ImageView.mapImageView.image = UIImage(named: "level2")
            level3ImageView.mapImageView.image = UIImage(named: "level3")
            level5ImageView.mapImageView.image = UIImage(named: "level5")
            level6ImageView.mapImageView.image = UIImage(named: "level6")
            level4ImageView.mapImageView.image = UIImage(named: "selectedLevel4")
        } else {
            if balance > 2000 {
                successfulBuyAlert()
                level4ImageView.setAvailableLevel()
                var newLevels: [Int: Bool] = levels
                newLevels[4] = true
                UserDefaultSettings.levels = newLevels
            } else {
                notEnoughBalanceAlert(diff: 2000 - balance)
            }
        }
    }
    
    @objc
    func buyLevel5() {
        print("LEVEL 5")
        let balance = UserDefaultSettings.balance
        let levels = UserDefaultSettings.levels

        if levels[5] == true {
            let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 5!", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .cancel)
            contactAlertController.addAction(okAction2)
            present(contactAlertController, animated: true)
            UserDefaultSettings.selected = 3
            level1ImageView.mapImageView.image = UIImage(named: "level1")
            level2ImageView.mapImageView.image = UIImage(named: "level2")
            level3ImageView.mapImageView.image = UIImage(named: "level3")
            level4ImageView.mapImageView.image = UIImage(named: "level4")
            level6ImageView.mapImageView.image = UIImage(named: "level6")
            level5ImageView.mapImageView.image = UIImage(named: "selectedLevel5")
        } else {
            if balance > 5000 {
                successfulBuyAlert()
                level5ImageView.setAvailableLevel()
                var newLevels: [Int: Bool] = levels
                newLevels[5] = true
                UserDefaultSettings.levels = newLevels
            } else {
                notEnoughBalanceAlert(diff: 5000 - balance)
            }
        }
    }
    
    @objc
    func buyLevel6() {
        let balance = UserDefaultSettings.balance
        let levels = UserDefaultSettings.levels

        if levels[6] == true {
            let contactAlertController = UIAlertController(title: "Success!" , message: "Selected level 3!", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: .cancel)
            contactAlertController.addAction(okAction2)
            present(contactAlertController, animated: true)
            UserDefaultSettings.selected = 6
            level1ImageView.mapImageView.image = UIImage(named: "level1")
            level2ImageView.mapImageView.image = UIImage(named: "level2")
            level3ImageView.mapImageView.image = UIImage(named: "level3")
            level4ImageView.mapImageView.image = UIImage(named: "level4")
            level5ImageView.mapImageView.image = UIImage(named: "level5")
            level6ImageView.mapImageView.image = UIImage(named: "selectedLevel6")
        } else {
            if balance > 10000 {
                successfulBuyAlert()
                level6ImageView.setAvailableLevel()
                var newLevels: [Int: Bool] = levels
                newLevels[6] = true
                UserDefaultSettings.levels = newLevels
            } else {
                notEnoughBalanceAlert(diff: 10000 - balance)
            }
        }
    }
    
    func successfulBuyAlert() {
        let contactAlertController = UIAlertController(title: "Success!" , message: "", preferredStyle: .alert)
        let okAction2 = UIAlertAction(title: "OK", style: .cancel)
        contactAlertController.addAction(okAction2)
        present(contactAlertController, animated: true)
    }
    
    func notEnoughBalanceAlert(diff: Int) {
        let contactAlertController = UIAlertController(title: "Not enough points!" , message: "You need \(diff) more", preferredStyle: .alert)
        let okAction2 = UIAlertAction(title: "OK", style: .cancel)
        contactAlertController.addAction(okAction2)
        present(contactAlertController, animated: true)
    }
    
    func fetchLocalData() {
        
        let balance = UserDefaultSettings.balance
        print("BALANCE \(balance)")
        topUsersView.textLabel.text = "Points: \(balance)"
        topUsersView.updateLabel(value: balance)
        
        let levels = UserDefaultSettings.levels
        
        for level in levels {
            print("Level \(level.key)  -  \(level.value)")
            switch level.key {
            case 2:
                if !level.value {
                    level2ImageView.setUnavailableLevel(price: 500)
                } else {
                    level2ImageView.setAvailableLevel()
                }
            case 3:
                if !level.value {
                    level3ImageView.setUnavailableLevel(price: 1000)
                } else {
                    level3ImageView.setAvailableLevel()
                }
            case 4:
                if !level.value {
                    level4ImageView.setUnavailableLevel(price: 2000)
                } else {
                    level4ImageView.setAvailableLevel()
                }
            case 5:
                if !level.value {
                    level5ImageView.setUnavailableLevel(price: 5000)
                } else {
                    level5ImageView.setAvailableLevel()
                }
            case 6:
                if !level.value {
                    level6ImageView.setUnavailableLevel(price: 10000)
                } else {
                    level6ImageView.setAvailableLevel()
                }
                
            default:
                break
            }
        }
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.height.equalToSuperview().offset(400)
            make.width.equalToSuperview()
        }
        
        topImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        topUsersView.snp.makeConstraints { make in
            make.top.equalTo(topImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        let desiredWidth = self.view.frame.width * 0.4
        level1ImageView.snp.makeConstraints { make in
            make.top.equalTo(topUsersView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
        
        level2ImageView.snp.makeConstraints { make in
            make.top.equalTo(level1ImageView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
        
        level3ImageView.snp.makeConstraints { make in
            make.top.equalTo(level2ImageView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
        
        level4ImageView.snp.makeConstraints { make in
            make.top.equalTo(level3ImageView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
        level5ImageView.snp.makeConstraints { make in
            make.top.equalTo(level4ImageView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
        level6ImageView.snp.makeConstraints { make in
            make.top.equalTo(level5ImageView.snp.bottom).offset(20)
            make.height.equalTo(desiredWidth)
            make.width.equalTo(desiredWidth)
            make.centerX.equalToSuperview()
        }
    }
}
