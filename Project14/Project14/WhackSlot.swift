//
//  WhackSlot.swift
//  Project14
//
//  Created by Vladimir on 03.03.2025.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    private var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        addChild(cropNode)
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        if Int.random(in: 0..<2) == 0 {
            charNode.name = "charEnemy"
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
        } else {
            charNode.name = "charFriend"
            charNode.texture = SKTexture(imageNamed: "penguinGood")
        }
        
        charNode.setScale(1)
        charNode.run(.moveBy(x: 0, y: 80, duration: 0.1))
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime*3.5) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        charNode.run(.moveBy(x: 0, y: -80, duration: 0.1))
        isVisible = false
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.2)
        let action = SKAction.moveBy(x: 0, y: -80, duration: 0.4)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        charNode.run(.sequence([delay, action, notVisible]))
    }
}
