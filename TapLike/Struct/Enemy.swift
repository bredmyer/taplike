//
//  Enemy.swift
//  TapLike
//
//  Created by Brennon Redmyer on 12/3/20.
//

import SpriteKit

enum EnemyState
    {
    case STAND, JUMP, HURT
    }

enum EnemyType: Int
    {
    case SPIKEBALL = 1, SPIKEMAN, FLYMAN, WINGMAN
    }
    
protocol EnemyDelegate: AnyObject
    {
    func enemy(_ enemy: Enemy, didTakeDamage damage: Int)
    }

class Enemy: SKSpriteNode
    {
    let type: EnemyType
    var state: EnemyState
    var health: Int = 1
    var maxDamage: Int = 1
    
    var standAnimationFrames:   [String]
    
    var standAnimationSpeed:    TimeInterval
    // MARK: - Required/Method Overrides
    init()
        {
        // Determine animation textures based on arbitrary "type" (1:brown, 2:purple)
        var imageName: String
        type = .SPIKEBALL
        imageName = "spikeBall1"
        standAnimationFrames = [imageName, "spikeBall2"]
        standAnimationSpeed = 0.2
        state = .STAND
        // Invoke superclass initializer with standing image texture
        // (the image itself is huge, so scale it down at this step as well)
        let texture = SKTexture(imageNamed: imageName)
        let textureSize = CGSize(width: texture.size().width / 2, height: texture.size().height / 2)
        super.init(texture: texture, color: .clear, size: textureSize)
        // Finally, set anchor point at the center of the feet
        anchorPoint = CGPoint(x: 0.5, y: 0)
        }
    required init?(coder aDecoder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    // MARK: - Public Methods
    public func update(_ currentTime: TimeInterval)
        {
        // Update logic for this node
        }
    public func damage(_ amount: Int)
        {
        health -= amount
        if health <= 0
            {
            die()
            }
        }
    public func die()
        {
        self.removeFromParent()
        }
    public func stand()
        {
        // Stop any current actions running on this node
        self.removeAllActions()
        // If this node is squashing/stretching, reset scale
        self.setScale(1)
        // Load animation frames based on arbitrary "type" determined at init
        let atlasName = "spikeBall"
        let textureAtlas = SKTextureAtlas(named: atlasName)
        let frames = standAnimationFrames.map { textureAtlas.textureNamed($0) }
        guard let texture = frames.first else
            {
            fatalError("Texture atlas needs at least one image")
            }
        self.texture = texture
        // Set up animation actions
        let animate = SKAction.animate(with: frames, timePerFrame: standAnimationSpeed / 2)
        let animateForever = SKAction.repeatForever(animate)
        let squashUp = SKAction.scale(to: 1, duration: standAnimationSpeed)
        let squashDown = SKAction.scaleY(to: 0.75, duration: standAnimationSpeed)
        let squash = SKAction.sequence([squashDown, squashUp])
        let squashForever = SKAction.repeatForever(squash)
        // Run animation actions
        self.run(animateForever)
        self.run(squashForever)
        state = .STAND
        }
    }
