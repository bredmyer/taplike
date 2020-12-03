//
//  GameScene.swift
//  TapLike
//
//  Created by Brennon Redmyer on 11/27/20.
//

import SpriteKit

class Player: SKSpriteNode
    {
    // Node variables
    let type: Int
    
    // Animation frames
    var walkAnimationFrames: [String]
    
    init()
        {
        var imageName = ""
        type = Int.random(in: 1...3)
        if type == 1
            {
            imageName = "bunny1_stand"
            walkAnimationFrames = ["bunny1_walk1", "bunny1_walk2"]
            }
        else
            {
            imageName = "bunny2_stand"
            walkAnimationFrames = ["bunny2_walk1", "bunny2_walk2"]
            }
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: CGSize(width: texture.size().width / 2, height: texture.size().height / 2))
        anchorPoint = CGPoint(x: 0.5, y: 0)
        }
    required init?(coder aDecoder: NSCoder)
        {
        fatalError("init(coder:) has not been implemented")
        }
    public func move()
        {
        var atlasName = ""
        if type == 1 { atlasName = "bunny1" }
        else { atlasName = "bunny2" }
        let textureAtlas = SKTextureAtlas(named: atlasName)
        let frames = walkAnimationFrames.map { textureAtlas.textureNamed($0) }
        let animate = SKAction.animate(with: frames, timePerFrame: 0.2)
        let animateForever = SKAction.repeatForever(animate)
        let squashDown = SKAction.scaleY(to: 0.9, duration: 0.1)
        let squashUp = SKAction.scaleY(to: 1, duration: 0.1)
        let squash = SKAction.sequence([squashDown, squashUp])
        let squashForever = SKAction.repeatForever(squash)
        self.run(animateForever)
        self.run(squashForever)
        }
    public func stand()
        {
        self.removeAllActions()
        let squashUp = SKAction.scale(to: 1, duration: 0.1)
        self.run(squashUp)
        var imageName = ""
        if type == 1
            {
            imageName = "bunny1_stand"
            walkAnimationFrames = ["bunny1_walk1", "bunny1_walk2"]
            }
        else
            {
            imageName = "bunny2_stand"
            walkAnimationFrames = ["bunny2_walk1", "bunny2_walk2"]
            }
        let texture = SKTexture(imageNamed: imageName)
        self.texture = texture
        }
}

class GameScene: SKScene
    {
    // Game variables
    var isMoving = false
    var distanceToNextEnemy = 0
    
    // Nodes
    let background = SKSpriteNode(imageNamed: "bg_layer1")
    var groundNode = SKNode()
    var player = Player()
    
    // MARK: - Method Overrides
    override func didMove(to view: SKView)
        {
        backgroundColor = .lightText
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        distanceToNextEnemy = Int(self.size.width * 2)
        // Add sky background layer
        addChild(background)
        // Create and add ground layer
        groundNode = createGroundNode()
        addChild(groundNode)
        // Create and add the main character
        let ground = SKSpriteNode(imageNamed: "grassMid")
        player.position = CGPoint(x: -self.size.width / 4, y: (-self.size.height / 2) + ground.size.height)
        addChild(player)
        }
    override func update(_ currentTime: TimeInterval)
        {
        if (isMoving && distanceToNextEnemy > 0)
            {
            moveGround()
            distanceToNextEnemy -= 2
            }
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let touchedNodes = nodes(at: location)
//        let frontTouchedNode = atPoint(location).name
        isMoving = true
        player.move()
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
        {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let touchedNodes = nodes(at: location)
//        let frontTouchedNode = atPoint(location).name
        isMoving = false
        player.stand()
        }
    // MARK: - Private Methods
    private func createGroundNode() -> SKNode
        {
        let groundNode = SKNode()
        for i in 0...8
            {
            let ground = SKSpriteNode(imageNamed: "grassMid")
            ground.name = "Ground"
            ground.position = CGPoint(x: (CGFloat(i) * ground.size.width) - (ground.size.width / 2) - self.frame.size.width / 2,
                                      y: (-self.frame.size.height / 2) + (ground.size.width / 2))
            groundNode.addChild(ground)
            }
        return groundNode
        }
    private func moveGround()
        {
        groundNode.position.x -= 2
        if groundNode.position.x < -self.size.width / 2
            {
            groundNode.position.x = 0
            }
        }
    }
