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
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var popupTime = 0.85
    
    private var slots = [WhackSlot]()
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 1024/2, y: 768/2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        
        for i in 0..<4 {
            let jRange = 4 + (i.isMultiple(of: 2) ? 1 : 0)
            for j in 0..<jRange {
                let x0 = (i.isMultiple(of: 2) ? 100 : 180)
                createSlot(at: CGPoint(x: x0 + 170*j, y: 410 - i*90))
            }
        }
        
        createEnemy()
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        let rand = Int.random(in: 0...12)
        switch rand {
        case 5...:
            slots[1].show(hideTime: popupTime)
        case 9...:
            slots[2].show(hideTime: popupTime)
        case 11...:
            slots[3].show(hideTime: popupTime)
        case 12:
            slots[4].show(hideTime: popupTime)
        default:
            break
        }
        
        popupTime *= 0.99
        let minDelay = popupTime / 2
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
