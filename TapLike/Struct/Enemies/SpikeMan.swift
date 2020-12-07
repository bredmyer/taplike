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
            = [EntityState.stand.rawValue:        ["\(atlasName)_stand"]]
        let framerates: [String: TimeInterval]
            = [EntityState.stand.rawValue:        0.1]
        super.init(textureAtlas: textureAtlas, animations: animations, framerates: framerates)
        let sequenceFX: [String: [SKAction]]
            = ["stand":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.95,   duration: self.framerates?["stand"] ?? 0),                                                                 SKAction.scale(to: 1,      duration: self.framerates?["stand"] ?? 0)]))]]
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
