//
//  SpikeBall.swift
//  TapLike
//
//  Created by Brennon Redmyer on 12/6/20.
//

import SpriteKit

class SpikeMan: Enemy
    {
    init()
        {
        let atlasName = "spikeMan"
        let textureAtlas = SKTextureAtlas(named: atlasName)
        let animations: [String: [String]]
            = [EntityState.stand.rawValue:        ["\(atlasName)_stand"],
               EntityState.hurt.rawValue:         ["\(atlasName)_jump"]]
        let framerates: [String: TimeInterval]
            = [EntityState.stand.rawValue:        0.1,
               EntityState.hurt.rawValue:         0.2]
        super.init(textureAtlas: textureAtlas, animations: animations, framerates: framerates)
        let sequenceFX: [String: [SKAction]]
            = ["stand":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.95,   duration: self.framerates?["stand"] ?? 0),                                                                 SKAction.scale(to: 1,      duration: self.framerates?["stand"] ?? 0)]))],
               "hurt":            [SKAction.scale(to: 1, duration: 0),
                                   SKAction.run {
                                     self.anchorPoint = CGPoint(x: 0.5, y: -0.15)
                                   },
                                   SKAction.rotate(toAngle: deg2rad(330), duration: 0),
                                   SKAction.wait(forDuration: self.framerates?["hurt"] ?? 0),
                                   SKAction.rotate(toAngle: deg2rad(0), duration: 0),
                                   SKAction.run{
                                     self.removeAllActions()
                                     self.anchorPoint = CGPoint(x: 0.5, y: 0)
                                     self.state = .stand
                                   }]]
        self.sequenceFX = sequenceFX
        
        // Assign stats
        maxHealth = 2
        health = maxHealth
        attack = 1
        defense = 0

        state = .stand
        }
    required init?(coder aDecoder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    // MARK: - Public Methods
    override public func update(_ currentTime: TimeInterval)
        {
        super.update(currentTime)
        }
        
    }
