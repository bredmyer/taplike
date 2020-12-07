//
//  Entity.swift
//  TapLike
//
//  Base class for all interactable objects, primarily the player and enemies.
//  Handles entity state, texture atlases, animations, and special effects.
//
//  Created by Brennon Redmyer on 12/5/20.
//

import SpriteKit

enum EntityState: String
    {
    case stand, ready, walk, jump, attack_hit, attack_miss, hurt
    }
    
protocol EntityDelegate: AnyObject
    {
    func entity(_ entity: Entity, didTakeDamage damage: Int)
    }

class Entity: SKSpriteNode
    {
    // MARK: - Properties
    var delegate: EntityDelegate? = nil
    
    var textureAtlas: SKTextureAtlas?
    var animations: [String: [String]]?
    var framerates: [String: TimeInterval]?
    
    var sequenceFX: [String: [SKAction]]?   // Actions to run in order along with a specific animation
    var groupFX:    [String: [SKAction]]?   // Actions to run concurrently along with a specific animation
    
    var _state: EntityState
    var state: EntityState
        {
        get
            {
            return _state
            }
        set
            {
            _state = newValue
            setAnimation(for: _state)
            }
        }
    
    var health: Int?
    var maxHealth: Int?
    var attack: Int?
    var defense: Int?
    
    var charge: Double = 0
    var chargeMax: Double = 105
    var chargeDuration: TimeInterval = 1.0
    
    // MARK: - Required/Method Overrides
    init(textureAtlas: SKTextureAtlas, animations: [String: [String]], groupFX: [String: [SKAction]]? = nil, sequenceFX: [String: [SKAction]]? = nil, framerates: [String: TimeInterval])
        {
        // Make sure we have at least one animation
        guard let animation = animations.first else
            {
            fatalError("Entity node needs at least one animation defined")
            }
        let frames = animation.value.map { textureAtlas.textureNamed($0) }
        guard let texture = frames.first else
            {
            fatalError("Texture atlas needs at least one image")
            }
        // Make sure to set a proper texture after initialization!
        _state = .stand
        super.init(texture: texture, color: .clear, size: CGSize(width: texture.size().width / 2, height: texture.size().height / 2))
        self.texture = texture
        self.textureAtlas = textureAtlas
        self.animations = animations
        self.sequenceFX = sequenceFX
        self.groupFX = groupFX
        self.framerates = framerates
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
        // Update this node every frame
        }
    public func setAnimation(for state: EntityState)
        {
        // Stop any current actions running on this node
        self.removeAllActions()
        // If this node is squashing/stretching, reset scale
        self.setScale(1)
        
        let stateString = state.rawValue
        guard let animation = animations?[stateString] else
            {
            fatalError("Entity node needs at least one animation defined")
            }
        guard let textureAtlas = self.textureAtlas else
            {
            fatalError("Texture atlas for node not assigned")
            }
        let frames = animation.map { textureAtlas.textureNamed($0) }
        guard let framerate = framerates?[stateString] else
            {
            fatalError("No framerate set for state \(stateString)")
            }
            
        // Set up and run actions for changing animation frames
        let animate = SKAction.animate(with: frames, timePerFrame: framerate)
        let animateForever = SKAction.repeatForever(animate)
        run(animateForever)
        
        // Set up and run actions for special effects like squashing/stretching/shaking or changing color
        if let sequenceFX = sequenceFX?[stateString]
            {
            let sequence = SKAction.sequence(sequenceFX)
            run(sequence)
            }
        if let groupFX = groupFX?[stateString]
            {
            let group = SKAction.group(groupFX)
            run(group)
            }
        }
    }
