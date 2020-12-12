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
               EntityState.ready.rawValue:        ["\(atlasName)_stand"],
               EntityState.hurt.rawValue:         ["\(atlasName)_jump"],
               EntityState.attack_hit.rawValue:   ["\(atlasName)_jump"]]
        let framerates: [String: TimeInterval]
            = [EntityState.stand.rawValue:        0.1,
               EntityState.ready.rawValue:        0.05,
               EntityState.hurt.rawValue:         0.2,
               EntityState.attack_hit.rawValue:   0.1]
        super.init(textureAtlas: textureAtlas, animations: animations, framerates: framerates)
        let sequenceFX: [String: [SKAction]]
            = ["stand":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.95,   duration: self.framerates?["stand"] ?? 0),                                                                 SKAction.scale(to: 1,      duration: self.framerates?["stand"] ?? 0)]))],
               "ready":           [SKAction.repeatForever(SKAction.sequence([SKAction.scaleY(to: 0.85,  duration: self.framerates?["ready"] ?? 0),                                                                SKAction.scale(to: 1,      duration: self.framerates?["ready"] ?? 0)]))],
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
                                   }],
               "attack_hit":       [SKAction.scale(to: 0.75, duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.scale(to: 1.25, duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.scale(to: 1,    duration: self.framerates?["attack_hit"] ?? 0),
                                   SKAction.run({
                                     self.removeAllActions()
                                     self.state = .stand
                                   })]]
        self.sequenceFX = sequenceFX
        
        // Assign stats
        maxHealth = 2
        health = maxHealth
        attack = 1
        defense = 0
        
        chargeDuration = 2.0

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
        // Charging
        if state == .ready
            {
            // Add charge
            chargeUp(duration: chargeDuration)
            #if DEBUG
                print("Enemy is charging an attack... \(Int(charge))%")
            #endif
            if charge >= chargeMax
                {
                state = .attack_hit
                if let target = self.target
                    {
                    attack(target)
                    }
                charge = 0
                }
            }
        }
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
    public func attack(_ target: Entity)
        {
        // Deal damage based on charge
        let chargeRounded = min((charge / 100), 1)
        var damage = charge > 92 ?
            ceil(Double(attack ?? 0) * chargeRounded) :
            floor(Double(attack ?? 0) * chargeRounded)
        // Modify damage based on armor values
        // Every 3 points is 1 damage reduction
        if let defense = target.defense
            {
            if target.state == .stand
                {
                damage -= Double(defense / 3)
                }
            else
                {
                damage -= Double(defense / 2) / 3
                }
            }
        target.delegate?.entity(target, didTakeDamage: Int(ceil(damage)))
        #if DEBUG
            print("Enemy deals \(Int(ceil(damage))) damage")
        #endif
        }
    }
