//
//  GameScene.swift
//  Project11
//
//  Created by Vladimir on 24.12.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var scoreLabel: SKLabelNode!
    private var editLabel: SKLabelNode!
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var isInEditingMode = false {
        didSet {
            if isInEditingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    private let minY = 300.0
    
    override func didMove(to view: SKView)  {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        scoreLabel.horizontalAlignmentMode = .right
        addChild(scoreLabel)
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        let fog = SKSpriteNode(color: .init(white: 1, alpha: 0.5), size: CGSize(width: frame.width, height: minY))
        fog.position = CGPoint(x: frame.midX, y: minY/2)
        fog.zPosition = -0.9
        addChild(fog)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        createSlots()
        createBouncers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if nodes(at: location).contains(editLabel) {
                isInEditingMode.toggle()
            } else {
                if isInEditingMode {
                    createBox(at: location)
                } else {
                    createBall(at: location)
                }
            }
        }
    }
    
    private func createBox(at location: CGPoint) {
        let size = CGSize(width: Int.random(in: 32...128), height: 16)
        let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
        let box = SKSpriteNode(color: color, size: size)
        box.zRotation = CGFloat.random(in: 0...(2*CGFloat.pi))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
    }
    
    private func createBall(at location: CGPoint) {
        guard location.y > minY else { return }
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.position = location
        ball.physicsBody?.restitution = 1
        addChild(ball)
        ball.name = "ball"
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
    }
    
    private func removeBall(_ ball: SKNode) {
        ball.removeFromParent()
    }
    
    private func createBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.position = position
        bouncer.physicsBody?.isDynamic = false
        bouncer.physicsBody?.restitution = 1
        addChild(bouncer)
    }
    
    private func createBouncers() {
        var x_pos = 0
        let step = 1024/4
        while x_pos <= 1024 {
            createBouncer(at: CGPoint(x: x_pos, y: 0))
            x_pos += step
        }
    }
    
    private func createSlot(at position: CGPoint, isGood: Bool) {
        let slot: SKSpriteNode
        let glow: SKSpriteNode
        if isGood {
            slot = SKSpriteNode(imageNamed: "slotBaseGood")
            slot.name = "good"
            glow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slot = SKSpriteNode(imageNamed: "slotBaseBad")
            slot.name = "bad"
            glow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        slot.position = position
        addChild(slot)
        slot.physicsBody = SKPhysicsBody(rectangleOf: slot.size)
        slot.physicsBody?.isDynamic = false
        glow.position = position
        let action = SKAction.rotate(byAngle: .pi, duration: 10)
        let spin = SKAction.repeatForever(action)
        glow.run(spin)
        addChild(glow)
        glow.zPosition = -0.5
    }
    
    private func createSlots() {
        let xs = [ 128, 128 + 256, 128 + 256*2, 128 + 256*3]
        let positions = xs.map({CGPoint(x: Double($0), y: 0)})
        let areGood = [true, false, true, false]
        for i in 0..<4 {
            createSlot(at: positions[i], isGood: areGood[i])
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            didCollide(ball: nodeA, other: nodeB)
        } else if nodeB.name == "ball" {
            didCollide(ball: nodeB, other: nodeA)
        }
    }
    
    private func didCollide(ball: SKNode, other node: SKNode) {
        if node.name == "good" {
            removeBall(ball)
            score += 1
        } else if node.name == "bad" {
            removeBall(ball)
            score -= 1
        }
    }
}
