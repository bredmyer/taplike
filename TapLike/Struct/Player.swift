//
//  Player.swift
//  TapLike
//
//  Created by Brennon Redmyer on 12/3/20.
//

import SpriteKit

class Player: Entity
    {
    let type = Int.random(in: 1...3)   // Only used for randomly rolling a brown/purple texture
    var isMoving = false
    
    // MARK: - Required/Method Overrides
    init()
        {
        // Load animation frames based on arbitrary "type" determined at init
        var atlasName: String
        if type == 1
            {
            atlasName = "bunny1"
            }
        else
            {
            atlasName = "bunny2"
            }
        let textureAtlas = SKTextureAtlas(named: atlasName)
        let animations: [String: [String]]
            = [EntityState.stand.rawValue:        ["\(atlasName)_stand"],
               EntityState.walk.rawValue:         ["\(atlasName)_walk1", "\(atlasName)_walk2"],
               EntityState.ready.rawValue:        ["\(atlasName)_ready"],
               EntityState.jump.rawValue:         ["\(atlasName)_jump"],
               EntityState.attack_hit.rawValue:   ["\(atlasName)_attack"],
               EntityState.attack_miss.rawValue:  ["\(atlasName)_hurt"],
               EntityState.hurt.rawValue:         ["\(atlasName)_hurt"]]
        let framerates: [String: TimeInterval]
            = [EntityState.stand.rawValue:        0.2,
               EntityState.walk.rawValue:         0.1,
               EntityState.ready.rawValue:        0.05,
               EntityState.jump.rawValue:         0.1,
               EntityState.attack_hit.rawValue:   0.1,
               EntityState.attack_miss.rawValue:  0.5]
        super.init(textureAtlas: textureAtlas, animations: animations, framerates: framerates)
        let sequenceFX: [String: [SKAction]]
            = ["stand":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.9, duration: self.framerates?["stand"] ?? 0),                                                              SKAction.scale(to: 1, duration: self.framerates?["stand"] ?? 0)]))],
               "walk":            [SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1, duration: self.framerates?["walk"] ?? 0),
                                                                             SKAction.scaleY(to: 0.9, duration: self.framerates?["walk"] ?? 0)]))],
               "ready":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.95, duration: self.framerates?["ready"] ?? 0),                                                                  SKAction.scale(to: 1, duration: self.framerates?["ready"] ?? 0)]))],
               "attack_hit":      [SKAction.scale(to: 0.75, duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.scale(to: 1.25, duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.scale(to: 1,    duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.run({
                                     self.removeAllActions()
                                     self.state = .stand
                                   })],
               "attack_miss":     [SKAction.scaleY(to: 0.8, duration: self.framerates?["attack_miss"] ?? 0),
                                   SKAction.scale(to: 1, duration:    self.framerates?["attack_hit"] ?? 0),
                                   SKAction.run({
                                     self.removeAllActions()
                                     self.state = .stand
                                   })]]
        self.sequenceFX = sequenceFX
        
        // Assign stats
        maxHealth = 10
        health = maxHealth
        attack = 2
        defense = 1

        state = .stand
        }
    required init?(coder aDecoder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    override public func update(_ currentTime: TimeInterval)
        {
        super.update(currentTime)
        // Charging
        if state == .ready
            {
            // Add charge
            chargeUp(duration: chargeDuration)
            print(charge)
            }
        }
    // MARK: - Public Methods
    public func chargeUp(duration: TimeInterval)
        {
        let increment = chargeMax / (duration * 60)
        if charge < chargeMax
            {
            charge += increment
            }
        else
            {
            charge = chargeMax
            }
        }
    public func attack()
        {
        // Deal damage based on charge
        let damage = charge > 95 ?
            ceil(Double(attack ?? 0) * (charge / 100)) :
            floor(Double(attack ?? 0) * (charge / 100))
        print(damage)
        }
    }
