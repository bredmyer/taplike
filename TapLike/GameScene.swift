//
//  GameScene.swift
//  TapLike
//
//  Created by Brennon Redmyer on 11/27/20.
//

import SpriteKit

class GameScene: SKScene
    {
    // Scene variables
    var distanceToNextEnemy = 0
    
    var currentEnemy: Enemy?
    var enemyCount = 0
    var enemyVisible = false
    var enemyWaitTime: Int = 0
    var enemies: [Enemy] = []
    
    // Nodes
    let background = SKSpriteNode(imageNamed: "bg_layer1")
    var groundNode = SKNode()
    var player = Player()
    
    // MARK: - Method Overrides
    override func didMove(to view: SKView)
        {
        // Set up camera
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint.zero
        addChild(cameraNode)
        camera = cameraNode
        
        // Enemy count and distance
        enemyCount = 3
        distanceToNextEnemy = Int(self.size.width)
        
        // Add sky background layer
        addChild(background)
        
        // Create and add ground layer
        groundNode = createGroundNode()
        addChild(groundNode)
        
        // Create and add the main character
        let ground = SKSpriteNode(imageNamed: "grassMid")
        player.position = CGPoint(x: -self.size.width / 4, y: (-self.size.height / 2) + ground.size.height)
        player.delegate = self
        addChild(player)
        }
    override func update(_ currentTime: TimeInterval)
        {
        // Movement:
        if player.isMoving
            {
            if distanceToNextEnemy > 0
                {
                // If we still have a distance to the next encounter, we're walking & need to mvoe the scene
                moveGround()
                moveObjects()
                distanceToNextEnemy -= 2
                }
            else
                {
                // We've reached the destination and can't proceed until we finish the encounter
                player.state = .stand
                player.isMoving = false
                }
            }
        else
            {
            // We are stopped... or charging an attack
            if player.state == .ready
                {
                if player.charge >= player.chargeMax
                    {
                    player.state = .attack_miss
                    }
                }
            // Enemy charge up every X seconds
            if distanceToNextEnemy == 0
                {
                if enemyVisible
                    {
                    if let enemy = currentEnemy
                        {
                        if enemy.state == .stand
                            {
                            if enemyWaitTime < 60
                                {
                                enemyWaitTime += 1
                                }
                            else
                                {
                                enemy.state = .ready
                                enemyWaitTime = 0
                                }
                            }
                        }
                    }
                }
            }
        
        // Spawn Enemy:
        if distanceToNextEnemy < Int(self.size.width / 2 - self.size.width / 4) && enemyVisible == false && enemyCount > 0
            {
            // Spawn an enemy just off screen
            let ground = SKSpriteNode(imageNamed: "grassMid")
            let spikeMan = SpikeMan()
            spikeMan.position = CGPoint(x: self.size.width / 2 + spikeMan.size.width / 2, y: (-self.size.height / 2) + ground.size.height)
            enemies.append(spikeMan)
            addChild(spikeMan)
            spikeMan.delegate = self
            currentEnemy = spikeMan
            spikeMan.target = player
            enemyVisible = true
            }
            
        // Update nodes:
        player.update(currentTime)
        for enemy in enemies
            {
            enemy.update(currentTime)
            }
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
        if distanceToNextEnemy > 0 && enemyCount > 0
            {
            // If we still have a distance to the next encounter, start walking
            player.state = .walk
            player.isMoving = true
            }
        else
            {
            // Otherwise, we need to wind up an attack
            if enemyCount > 0
                {
                if player.state == .stand
                    {
                    player.state = .ready
                    }
                }
            }
        }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
        {
        player.isMoving = false
        if distanceToNextEnemy > 0 && enemyCount > 0
            {
            // If we still have a distance to the next encounter, stop walking
            player.state = .stand
            }
        else
            {
            // Otherwise, if we're charging up an attack, release an attack
            if player.state == .ready && enemyCount > 0
                {
                // It's a success as long as we don't go past the max charge amount
                if player.charge <= player.chargeMax
                    {
                    player.state = .attack_hit
                    guard let enemy = currentEnemy else { return }
                    player.attack(enemy)
                    }
                }
            }
        player.charge = 0
        }
    // MARK: - Private Methods
    private func createGroundNode() -> SKNode
        {
        let groundNode = SKNode()
        for i in 0...10
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
    private func moveObjects()
        {
        for enemy in enemies
            {
            enemy.position.x -= 2
            }
        }
        
//    private func effectAttackBegin()
//        {
//        player.state = .ready
//        let zoom = SKAction.scale(to: 0.6, duration: player.chargeDuration)
//        let position = SKAction.move(to: CGPoint(x: player.position.x + player.size.width, y: -player.size.height * 1.5), duration: player.chargeDuration)
//        let color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: player.chargeDuration)
//        if let camera = camera
//            {
//            camera.removeAllActions()
//            camera.run(zoom)
//            camera.run(position)
//            player.run(color)
//            }
//        }
//    private func effectAttackSuccess()
//        {
//        player.state = .attack_hit
//        let zoom = SKAction.scale(to: 1, duration: 0.05)
//        let position = SKAction.move(to: CGPoint.zero, duration: 0.05)
//        let color = SKAction.colorize(with: .red, colorBlendFactor: 0, duration: 0.05)
//        if let camera = camera
//            {
//            camera.removeAllActions()
//            camera.run(zoom)
//            camera.run(position)
//            player.run(color)
//            }

//        if let enemy = enemies.first
//            {
//            enemy.damage(Int(damage))
//            }
//        }
//    private func effectAttackFail()
//        {
//        player.state = .attack_miss
//        let zoom = SKAction.scale(to: 1, duration: 0.05)
//        let position = SKAction.move(to: CGPoint.zero, duration: 0.05)
//        let color = SKAction.colorize(with: .red, colorBlendFactor: 0, duration: 0.05)
//        if let camera = camera
//            {
//            camera.removeAllActions()
//            camera.run(zoom)
//            camera.run(position)
//            player.run(color)
//            }
//        player.charge = 0
//        }
    }

// MARK: - EntityDelegate Methods
extension GameScene: EntityDelegate
{
    func entity(_ entity: Entity, didTakeDamage damage: Int)
        {
        if let enemy = entity as? Enemy
            {
            if enemy == currentEnemy
                {
                if damage > 0
                    {
                    if enemy.state != .ready
                        {
                        enemy.state = .hurt
                        }
                    // Take damage
                    if enemy.health != nil
                        {
                        enemy.health! -= damage
                        if enemy.health! <= 0
                            {
                            // Die
                            enemy.removeFromParent()
                            enemy.charge = 0
                            enemy.state = .hurt
                            enemyVisible = false
                            enemyCount -= 1
                            distanceToNextEnemy = Int(self.size.width)
                            }
                        }
                    }
                }
            return
            }
        if let player = entity as? Player
            {
            if player == self.player
                {
                if damage > 0
                    {
                    player.state = EntityState.hurt
                    }
                }
            return
            }
        }
    }
