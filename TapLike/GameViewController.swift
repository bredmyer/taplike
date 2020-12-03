//
//  GameViewController.swift
//  TapLike
//
//  Created by Brennon Redmyer on 11/27/20.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
    {
    // MARK: - Function Overrides
    override func viewDidLoad()
        {
        super.viewDidLoad()
        view = SKView(frame: view.bounds)
        if let view = self.view as! SKView?
            {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            // Scene properties
            view.showsPhysics = false
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
            }
        }
    }
