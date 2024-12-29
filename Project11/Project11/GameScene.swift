//
//  GameScene.swift
//  Project11
//
//  Created by Vladimir on 24.12.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    override func didMove(to view: SKView)  {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBouncers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
            ball.position = location
            ball.physicsBody?.restitution = 1
            addChild(ball)
        }
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
}
