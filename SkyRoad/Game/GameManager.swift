import Foundation
import UIKit

protocol GameManagerProtocol {
    func getRandXPosition(screenBounds: CGRect) -> CGFloat
    func getRandEnemy() -> String
    func getCurScore() -> Int
    func getCurHealth() -> Int
    func increaseScore() -> Int
    func decreaseHealth()
    func restartGame()
}

class GameManager: GameManagerProtocol {
    static var shared = GameManager()
    private var enemy1Array: [String] = []
    private var enemy2Array: [String] = []
    private var enemy3Array: [String] = []
    private var level3enemy1Array: [String] = []
    private var level3enemy2Array: [String] = []
    private var level3enemy3Array: [String] = []

    private var playersScore = 0
    private var playersHealth = 3

    init() {
        enemy1Array = ["enemy11", "enemy12"]
        enemy2Array = ["enemy21", "enemy22"]
        enemy3Array = ["enemy3"]
        level3enemy1Array = ["enemy11", "enemy12", "enemy13"]
        level3enemy2Array = ["enemy21", "enemy22", "enemy23"]
        level3enemy3Array = ["enemy3", "enemy32", "enemy33"]


    }
    func getRandXPosition(screenBounds: CGRect) -> CGFloat { CGFloat.random(in: 40..<screenBounds.width - 50) }

    func getRandEnemy() -> String {
        let index = Int.random(in: 0..<enemy1Array.count)
        return enemy1Array[index]
    }
    
    func get1HitEnemy(number: Int, level: Int) -> String {
        if level >= 3 {
            return level3enemy1Array[number]
        } else {
            return enemy1Array[number]
        }
    }
    
    func get2HitEnemy(number: Int, level: Int) -> String {
        if level >= 3 {
            return level3enemy2Array[number]
        } else {
            return enemy2Array[number]
        }
    }
    
    func get3HitEnemy(number: Int, level: Int) -> String {
        if level >= 3 {
            return level3enemy3Array[number]
        } else {
            return enemy3Array[number]
        }
    }

    func increaseScore() -> Int {
        playersScore += 1
        return getCurScore()
    }

    func decreaseHealth() { playersHealth -= 1 }

    func restartGame() {
        playersScore = 0
        playersHealth = 3
    }

    func getCurScore() -> Int { playersScore }

    func getCurHealth() -> Int { playersHealth }
}
