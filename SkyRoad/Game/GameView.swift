import Foundation
import UIKit

class GameView: UIView {
    
    private var level = 1
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "gameBackground"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var playerImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "player"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.startTimers()
            self.setupGesture()
            button.isHidden = true
        }
        button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 23, weight: .medium)
            return outgoing
        }
        button.setTitle("Играть", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var restartButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        let action = UIAction { [weak self] _ in
            self?.restartGame()
            button.isHidden = true
        }
        button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 23, weight: .medium)
            return outgoing
        }
        button.setTitle("Переиграть", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 23, weight: .medium)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var nextLevelButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            self.secondLevelTimers()
            button.isHidden = true
            self.passedLevelLabel.isHidden = true
        }
        button.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 23, weight: .medium)
            return outgoing
        }
        button.isHidden = true
        button.setTitle("Перейти к следующему", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    private lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Игра завершена"
        label.contentMode = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.isHidden = true
        return label
    }()

    private lazy var passedLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Уровень пройден!"
        label.contentMode = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "homeButton"), for: .normal)
        return button
    }()
    
    lazy var playNowButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "playImage"), for: .normal)
        return button
    }()
    
    lazy var buyNitroButton: UIButton = {
       let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "buyViewGray"), for: .normal)
        return button
    }()
    
    private lazy var flameImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "flame"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var rePlayNowButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "playImage"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var gameOverImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "gameOver")
        image.sizeToFit()
        return image
    }()
    
    lazy var gameOverButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "gameOverButton"), for: .normal)
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(Colors.magenta, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 18)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    lazy var saveRecordButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "gameOverButton"), for: .normal)
        button.setTitle("Save record", for: .normal)
        button.setTitleColor(Colors.magenta, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name: "AbhayaLibre-ExtraBold", size: 16)
        button.titleLabel?.textColor = .white
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    var bullets: [UIImageView] = []
    
    lazy var recordBreakingView = RecordBreakingView()
    
    private lazy var countView = CountView()

    weak var gameViewController: GameController?
    private var playerAnimator: UIViewPropertyAnimator?
    private var enemyAnimator: UIViewPropertyAnimator?
    private var bossAnimator: UIViewPropertyAnimator?
    private var playerShotTimer: Timer?
    private var bossTimer: Timer?
    private var enemyTimer: Timer?
    private var collisionTimer: Timer?
    private var nitroTimer: Timer?
    private var finishTimer: Timer?
    private var lastTouch: CGPoint = .zero
    private var enemyPosition: [UIImageView: Int] = [:]
    private var gemPositions: [UIImageView] = []
    private var playerBullet: UIImageView?
    private var pointsCount = 0 {
        didSet {
            UserDefaultSettings.balance = pointsCount
            countView.priceTextLabel.text = "\(pointsCount)"
            if pointsCount >= 15 {
                print("KJKJK MAKE GREEn")
                buyNitroButton.setImage(UIImage(named: "buyViewGreen"), for: .normal)
            } else {
                buyNitroButton.setImage(UIImage(named: "buyViewGray"), for: .normal)
            }
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchLocalData()
        setupLayout()
        pauseButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        playNowButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        rePlayNowButton.addTarget(self, action: #selector(resumeGame), for: .touchUpInside)
        buyNitroButton.addTarget(self, action: #selector(buyNitro), for: .touchUpInside)
        print("KJKJK BALANCE \(pointsCount)")
        pointsCount = UserDefaultSettings.balance
        countView.priceTextLabel.text = "\(pointsCount)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameView {
    
    func fetchLocalData() {
        level = UserDefaultSettings.selected
        pointsCount = UserDefaultSettings.balance
    }
    
    func showMenu() {
        gameOverLabel.isHidden = false
        restartButton.isHidden = false
        enemyTimer?.invalidate()
        bossTimer?.invalidate()
        collisionTimer?.invalidate()
        playerShotTimer?.invalidate()
        for enemy in enemyPosition.keys {
            enemy.removeFromSuperview()
        }
    }
    
    @objc
    func pauseGame() {
        UserDefaultSettings.balance = pointsCount
        gameViewController?.coordinator?.navigate(with: .menu)
    }
    
    @objc
    func resumeGame() {
        buyNitroButton.isUserInteractionEnabled = true
        rePlayNowButton.isHidden = true
        enemyAnimator?.startAnimation()
        playerAnimator?.startAnimation()
        if level == 1 {
            startTimers()
        } else if level == 2 {
            secondLevelTimers()
        } else if level >= 3 {
            thirdLevelTimers()
        }
    }
    
    @objc
    func startGame() {
        buyNitroButton.isUserInteractionEnabled = true
        playNowButton.isHidden = true
        if level == 1 {
            startTimers()
        } else if level == 2 {
            secondLevelTimers()
        } else if level >= 3 {
            thirdLevelTimers()
        }
        setupGesture()
    }
    
    @objc
    func gameOver() {
        playerImageView.isUserInteractionEnabled = false
        enemyAnimator?.pauseAnimation()
        playerAnimator?.pauseAnimation()
        playerShotTimer?.invalidate()
        bossTimer?.invalidate()
        enemyTimer?.invalidate()
        collisionTimer?.invalidate()
        finishTimer?.invalidate()
        for bullet in bullets {
            bullet.isHidden = true
        }
        for enemy in enemyPosition {
            enemy.key.isHidden = true
        }
        addSubview(gameOverImageView)
        addSubview(saveRecordButton)
        addSubview(recordBreakingView)
        saveRecordButton.isHidden = false
        saveRecordButton.addTarget(self, action: #selector(saveRecord), for: .touchUpInside)
        recordBreakingView.setupConstraints()
        playerBullet?.isHidden = true
        
        gameOverImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        recordBreakingView.snp.makeConstraints { make in
            make.top.equalTo(gameOverImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(0.65)
            make.height.equalTo(120)
        }
        
        saveRecordButton.snp.makeConstraints { make in
            make.top.equalTo(recordBreakingView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        finishTimer?.invalidate()
        
    }
    
    @objc
    func saveRecord() {
        recordBreakingView.isHidden = true
        var name = recordBreakingView.customTextField.text ?? ""
        obtainRecord(name: name, record: countView.priceTextLabel.text ?? "0")
        recordBreakingView.removeFromSuperview()
        saveRecordButton.isHidden = true
        saveRecordButton.removeFromSuperview()
        addSubview(gameOverButton)
        gameOverButton.isHidden = false
        gameOverButton.addTarget(self, action: #selector(goBackToMenu), for: .touchUpInside)
        gameOverButton.snp.makeConstraints { make in
            make.top.equalTo(gameOverImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
   
    @objc
    func buyNitro() {
        if pointsCount >= 15 {
            pointsCount = pointsCount - 15
        }
        playerShotTimer?.invalidate()
        nitroTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(finishNitro), userInfo: nil, repeats: false)
        
        if level == 1 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(shotNitro), userInfo: nil, repeats: true)
        } else if level == 2 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(shotNitro), userInfo: nil, repeats: true)
        } else if level >= 3 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(shotNitro), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func finishNitro() {
        playerShotTimer?.invalidate()
        if level == 1 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        } else if level == 2 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        } else if level >= 3 {
            playerShotTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        }
        
    }
    
    func obtainRecord(name: String, record: String) {
        
        if let intRecord = Int(record) {
            if name.count > 0 {
                var curRecords = UserDefaultSettings.records
                curRecords.append(RecordObject(name: name, score: intRecord))
                var newRecords: [RecordObject] = curRecords.sorted { $0.score > $1.score }
                UserDefaultSettings.records = newRecords
            }
        }
    }
    
    @objc
    func goBackToMenu() {
        gameViewController?.coordinator?.navigate(with: .menu)
    }

    func restartGame() {
        if level == 1 {
            startTimers()
        } else if level == 2 {
            secondLevelTimers()
        } else if level >= 3 {
            thirdLevelTimers()
        }
        
        restartButton.isHidden = true
        gameOverLabel.isHidden = true
        nextLevelButton.isHidden = true
        passedLevelLabel.isHidden = true
        scoreLabel.text = "0"
    }

    func secondLevel() {
        nextLevelButton.isHidden = false
        passedLevelLabel.isHidden = false
        enemyTimer?.invalidate()
        bossTimer?.invalidate()
        collisionTimer?.invalidate()
        playerShotTimer?.invalidate()
        for enemy in enemyPosition.keys {
            enemy.removeFromSuperview()
        }
    }

    func startTimers() {
        playerShotTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//        bossTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(createBoss), userInfo: nil, repeats: false)
        collisionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleCollision), userInfo: nil, repeats: true)
        finishTimer = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(gameOver), userInfo: nil, repeats: true)
        
    }

    func secondLevelTimers() {
        playerShotTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//        bossTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(createBoss), userInfo: nil, repeats: false)
        collisionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleCollision), userInfo: nil, repeats: true)
        finishTimer = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(gameOver), userInfo: nil, repeats: true)
    }
    
    func thirdLevelTimers() {
        playerShotTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(shot), userInfo: nil, repeats: true)
        enemyTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
//        bossTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(createBoss), userInfo: nil, repeats: false)
        collisionTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(handleCollision), userInfo: nil, repeats: true)
        finishTimer = Timer.scheduledTimer(timeInterval: 50, target: self, selector: #selector(gameOver), userInfo: nil, repeats: true)
    }
}

extension GameView {
    @objc private func createBoss() {
        let boss = UIImageView(image: UIImage(named: "Boss"))
        boss.translatesAutoresizingMaskIntoConstraints = false
        boss.contentMode = .scaleAspectFill
        enemyPosition[boss] = 4
        addSubview(boss)
        NSLayoutConstraint.activate([
            boss.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: CGFloat.random(in: 60..<self.frame.width - 100)),
            boss.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -100)
        ])
        bossAnimator = UIViewPropertyAnimator(duration: 10, curve: .linear) {
            let moveTransform = CGAffineTransform(translationX: 0.0, y: self.frame.height + 50)
            boss.transform = moveTransform
        }
        bossAnimator?.addCompletion({ _ in
            if boss.layer.presentation()?.frame.minY ?? 0.0 >= self.frame.height {
                boss.removeFromSuperview()
                self.enemyPosition.removeValue(forKey: boss)
                self.showMenu()
                GameManager.shared.restartGame()
            } else {
                self.secondLevel()
                boss.removeFromSuperview()
                self.enemyPosition.removeValue(forKey: boss)
            }
        })
        bossAnimator?.startAnimation()
    }

    @objc private func createEnemy() {
        let enemy = UIImageView()
        let type = gameViewController?.configureEnemy(enemyImageView: enemy) ?? 1
        enemy.translatesAutoresizingMaskIntoConstraints = false
        enemy.contentMode = .scaleAspectFill

        let const = GameManager.shared.getRandXPosition(screenBounds: self.bounds)
        
   
        
        if (type > 0) && (type <= 4) {
            enemyPosition[enemy] = 1

            addSubview(enemy)
            NSLayoutConstraint.activate([
                enemy.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: const),
                enemy.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -100),
                enemy.heightAnchor.constraint(equalToConstant: 40),
                enemy.widthAnchor.constraint(equalToConstant: 20)
            ])
        } else if (type > 4) && (type <= 7) {
            enemyPosition[enemy] = 2

            addSubview(enemy)
            NSLayoutConstraint.activate([
                enemy.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: const),
                enemy.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -100),
                enemy.heightAnchor.constraint(equalToConstant: 60),
                enemy.widthAnchor.constraint(equalToConstant: 35)
            ])


        } else {
            enemyPosition[enemy] = 3

            addSubview(enemy)
            NSLayoutConstraint.activate([
                enemy.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: const),
                enemy.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -100),
                enemy.heightAnchor.constraint(equalToConstant: 100),
                enemy.widthAnchor.constraint(equalToConstant: 50)
            ])
        }

        enemyAnimator = UIViewPropertyAnimator(duration: 5, curve: .linear) {
            let moveTransform = CGAffineTransform(translationX: 0.0, y: self.frame.height + 70)
            enemy.transform = moveTransform
        }
        enemyAnimator?.addCompletion({ _ in
            enemy.removeFromSuperview()
            self.enemyPosition.removeValue(forKey: enemy)
            self.gameViewController?.checkGame()
        })
        enemyAnimator?.startAnimation()
    }
    
    
    @objc
    func finishGame() {
        finishTimer?.invalidate()
        enemyAnimator?.pauseAnimation()
        playerAnimator?.pauseAnimation()
        playerShotTimer?.invalidate()
        bossTimer?.invalidate()
        enemyTimer?.invalidate()
        collisionTimer?.invalidate()
        finishTimer?.invalidate()

    }

    @objc private func handleCollision() {
        for enemy in enemyPosition.keys {
            print("KJKJK \(enemy.layer.presentation()?.frame.minY) |||| \(self.frame.height)")
            if enemy.layer.presentation()?.frame.minY ?? 0.0 >= self.frame.height {
                print("KJKJK DECREASE")
                GameManager.shared.decreaseHealth()
                
                self.getBlinked(self.playerImageView)
                enemyPosition.removeValue(forKey: enemy)
            }
            if ((enemy.layer.presentation()?.frame.intersects(playerBullet?.layer.presentation()?.frame ?? .zero)) == true) {
                if var enemyHealth = enemyPosition[enemy] {
                    enemyHealth -= 1
                    enemyPosition[enemy] = enemyHealth
                    if enemyHealth <= 0 {
                        getDestroyed(enemy)
                        gameViewController?.increaseScore(scoreLabel: scoreLabel)
                    } else {
                        getBlinked(enemy)
                        playerBullet?.removeFromSuperview()
                    }
                }
            }
        }
        
        for gem in self.gemPositions {
            var index = 0
            if (gem.layer.presentation()?.frame.intersects(playerImageView.layer.presentation()?.frame ?? .zero) == true) {
                print("Killed")
                gemPositions.remove(at: index)
                gem.removeFromSuperview()
                pointsCount += 1
                break
            }
            index += 1
        }
        
    }
}

extension GameView {
    func setupLayout() {
        addSubview(backgroundImageView)
        addSubview(playerImageView)
        addSubview(pauseButton)
        addSubview(countView)
        addSubview(playNowButton)
        addSubview(rePlayNowButton)
        addSubview(flameImageView)
        addSubview(buyNitroButton)
        print("GAME LEVEL \(level)")
        
        if level == 1 {
            backgroundImageView.image = UIImage(named: "gameBackground")
        } else if level == 2 {
            backgroundImageView.image = UIImage(named: "level2Background")
        } else if level == 3 {
            backgroundImageView.image = UIImage(named: "level3Background")
        } else if level == 4 {
            backgroundImageView.image = UIImage(named: "level4Background")
        } else if level == 5 {
            backgroundImageView.image = UIImage(named: "level5Background")
        } else if level == 6 {
            backgroundImageView.image = UIImage(named: "level6Background")
            
        }
        countView.setupConstraints()
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        countView.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(10)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        playNowButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        rePlayNowButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        flameImageView.snp.makeConstraints { make in
            make.top.equalTo(countView.snp.bottom).offset(15)
            make.width.equalTo(80)
            make.height.equalTo(120)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        buyNitroButton.snp.makeConstraints { make in
            make.top.equalTo(flameImageView.snp.bottom).offset(-35)
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.centerX.equalTo(flameImageView.snp.centerX)
//            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        NSLayoutConstraint.activate([
            playerImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -100),
            playerImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            playerImageView.widthAnchor.constraint(equalToConstant: 50),
            playerImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

extension GameView {
    private func  setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc func shot() { getPlayerBullet() }
    
    @objc func shotNitro() { getPlayerBulletNitro() }


    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let curTouch = gesture.translation(in: self)
        if gesture.state == .began {
            lastTouch = playerImageView.center
        } else if gesture.state == .changed {
            let translation = CGAffineTransform(translationX: curTouch.x - lastTouch.x, y: curTouch.y - lastTouch.y)
            let transformedFrame = playerImageView.frame.applying(translation)

            if self.bounds.contains(transformedFrame) {
                playerImageView.transform = playerImageView.transform.concatenating(translation)
            }
            lastTouch = curTouch
        }
    }
}

extension GameView {
    func getBlinked(_ shipImageView: UIImageView) {
        UIView.animate(withDuration: 0.2, delay: .zero, options: .autoreverse) {
            shipImageView.alpha = 0.3
        } completion: { [weak shipImageView] _ in
            shipImageView?.alpha = 1
        }
    }

    func getDestroyed(_ shipView: UIImageView) {
        enemyPosition.removeValue(forKey: shipView)
        gemPositions.append(shipView)
        let currentCount = gemPositions.count
        let index = currentCount - 1
        UIView.animate(withDuration: 2.0) {
            shipView.frame = CGRect(x: shipView.frame.midX, y: shipView.frame.midY, width: 40, height: 60)
            shipView.image = UIImage(named: "gem")
            let moveTransform = CGAffineTransform(translationX: 0.0, y: (self.bounds.height + 50))
            shipView.transform = moveTransform
//            self.playerBullet?.removeFromSuperview()
//            self.enemyPosition.removeValue(forKey: shipView)
        } completion: { _ in
            if self.gemPositions.count == currentCount {
                self.gemPositions.remove(at: index)
                shipView.removeFromSuperview()
            }
        }
    }

    func getPlayerBullet() {
        let bullet = UIImageView(image: UIImage(named: "bullet"))
        bullet.frame = CGRect(x: playerImageView.frame.midX - 5, y: playerImageView.frame.midY - 50, width: 8, height: 8)
        bullet.contentMode = .scaleAspectFill
        playerBullet = bullet
        bullets.append(bullet)
        addSubview(bullet)
        if level == 1 {
            UIView.animate(withDuration: 0.5, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }
        } else if level == 2 {
            UIView.animate(withDuration: 0.3, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }

        } else if level >= 3 {
            UIView.animate(withDuration: 0.3, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }

            
        }
    }
    
    func getPlayerBulletNitro() {
        let bullet = UIImageView(image: UIImage(named: "bullet"))
        bullet.frame = CGRect(x: playerImageView.frame.midX - 10, y: playerImageView.frame.midY - 25, width: 8, height: 8)
        bullet.contentMode = .scaleAspectFill
        playerBullet = bullet
        addSubview(bullet)
        if level == 1 {
            UIView.animate(withDuration: 0.35, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }
        } else if level == 2 {
            UIView.animate(withDuration: 0.2, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }

        } else if level >= 3 {
            UIView.animate(withDuration: 0.2, delay: 0.08) {
                let moveTransform = CGAffineTransform(translationX: 0.0, y: -(self.bounds.height + 50))
                bullet.transform = moveTransform
            } completion: { _ in
                bullet.removeFromSuperview()
            }

            
        }
    }
}
