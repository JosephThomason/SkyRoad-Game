import Foundation
import UIKit

class GameController: UIViewController {
    private lazy var gameView = GameView(frame: .zero)
    var level = 1
    weak var coordinator: GameCoordinator?
    private lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pauseButton"), for: .normal)
        return button
    }()

    override func loadView() {
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        level = UserDefaultSettings.selected
        pauseButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        gameView.gameViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc
    func pauseGame() {
        
    }
    
    
}

extension GameController {
    func configureEnemy(enemyImageView: UIImageView) -> Int {
        let number = Int.random(in: 1...10)
        if (number > 0) && (number <= 4) {
            var enemyNum = 0
            if level >= 3 {
                enemyNum = Int.random(in: 0...2)
            } else {
                enemyNum = Int.random(in: 0...1)
            }
            let enemy = GameManager.shared.get1HitEnemy(number: enemyNum, level: level)
            enemyImageView.image = UIImage(named: enemy) ?? UIImage()
            return number
        } else if (number > 4) && (number <= 7) {
            var enemyNum = 0
            if level >= 3 {
                enemyNum = Int.random(in: 0...2)
            } else {
                enemyNum = Int.random(in: 0...1)
            }
            let enemy = GameManager.shared.get2HitEnemy(number: enemyNum, level: level)
            enemyImageView.image = UIImage(named: enemy) ?? UIImage()
            return number
        } else {
            var enemyNum = 0
            if level >= 3 {
                enemyNum = Int.random(in: 0...2)
            } else {
                enemyNum = 0
            }            
            let enemy = GameManager.shared.get3HitEnemy(number: enemyNum, level: level)
            enemyImageView.image = UIImage(named: enemy) ?? UIImage()
            return number
        }
    }

    func increaseScore(scoreLabel: UILabel) { scoreLabel.text = "\(GameManager.shared.increaseScore())" }

    func checkGame() {
        if GameManager.shared.getCurHealth() <= 0 {
            gameView.gameOver()
//            GameManager.shared.restartGame()
        }
    }
}
