//
//  GameScene.swift
//  Project14
//
//  Created by Vladimir on 03.03.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var scoreLabel: SKLabelNode!
    private var score: Int = 0 {
        didSet {
            score = max(score, 0)
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var numRounds = 0
    private var popupTime = 0.9
    private var slots = [WhackSlot]()
    private var gameIsOver = false
    
    override func didMove(to view: SKView) {
        setUpBackground()
        setUpScoreLabel()
        setUpSlots()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.createEnemy()
        }
    }
    
    private func startGame() {
        gameIsOver = false
        score = 0
        numRounds = 0
        popupTime = 0.9
        removeAllChildren()
        setUpBackground()
        setUpScoreLabel()
        setUpSlots()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    private func setUpBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 1024/2, y: 768/2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    private func setUpScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
    }
    
    private func setUpSlots() {
        for i in 0..<4 {
            let jRange = 4 + (i.isMultiple(of: 2) ? 1 : 0)
            let x0 = (i.isMultiple(of: 2) ? 100 : 180)
            for j in 0..<jRange {
                createSlot(at: CGPoint(x: x0 + 170*j, y: 410 - i*90))
            }
        }
    }
    
    private func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    private func createEnemy() {
        numRounds += 1
        
        if numRounds >= 10 {
            gameOver()
            return
        }
        
        slots.shuffle()
        let hideTime = popupTime*3.5
        let rand = Int.random(in: 0...12)
        let numberOfSlots: Int
        switch rand {
        case ..<5:
            numberOfSlots = 1
        case 5...:
            numberOfSlots = 2
        case 9...:
            numberOfSlots = 3
        case 11...:
            numberOfSlots = 4
        case 12:
            numberOfSlots = 5
        default:
            numberOfSlots = 1
        }
        
        slots[0..<numberOfSlots].forEach { $0.show(hideTime: hideTime)}
        
        popupTime *= 0.99
        let minDelay = popupTime / 2
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    private func gameOver() {
        for slot in slots {
            slot.hide()
        }
        
        let gameOverLabel = SKSpriteNode(imageNamed: "gameOver")
        gameOverLabel.position = CGPoint(x: 1024/2, y: 768/2)
        gameOverLabel.zPosition = 1
        gameOverLabel.name = "gameOver"
        addChild(gameOverLabel)
        scoreLabel.position = CGPoint(x: 1024/2, y: 768/2 - 100)
        scoreLabel.horizontalAlignmentMode = .center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.gameIsOver = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameIsOver {
            startGame()
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = nodes(at: location)
            for node in nodes {
                guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
                if node.name == "charEnemy" || node.name == "charFriend" {
                    guard whackSlot.isVisible, !whackSlot.isHit else { continue }
                    whackSlot.hit()
                }
                if node.name == "charEnemy" {
                    score += 1
                    node.setScale(0.85)
                    run(.playSoundFileNamed("whack", waitForCompletion: false))
                }
                if node.name == "charFriend" {
                    score -= 5
                    run(.playSoundFileNamed("whackBad", waitForCompletion: false))
                }
            }
        }
    }
}
