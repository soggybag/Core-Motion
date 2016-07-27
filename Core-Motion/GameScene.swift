//
//  GameScene.swift
//  Core-Motion
//
//  Created by mitchell hudson on 7/26/16.
//  Copyright (c) 2016 mitchell hudson. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let motionUpdateInterval = 0.2
    let forceMultiplier: CGFloat = 20
    
    let motionManager = CMMotionManager()
    var acceleration = CGVector()
    
    var box: SKSpriteNode!
    
    
    
    func setupCoreMotion() {
        motionManager.accelerometerUpdateInterval = motionUpdateInterval
        let queue = NSOperationQueue()
        motionManager.startAccelerometerUpdatesToQueue(queue) { (accelerometerData, error) in
            guard let accelerometerData = accelerometerData else {
                return
            }
            
            let accelX = accelerometerData.acceleration.x
            let accelY = accelerometerData.acceleration.y
            let accelZ = accelerometerData.acceleration.z
            
            self.acceleration = CGVector(dx: accelX, dy: accelY)
        }
    }
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Physics World 
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Set up edges 
        physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        
        // Make a box
        let boxSize = CGSize(width: 30, height: 30)
        box = SKSpriteNode(color: UIColor.redColor(), size: boxSize)
        addChild(box)
        box.position.x = view.frame.width / 2
        box.position.y = view.frame.height / 2
        
        box.physicsBody = SKPhysicsBody(rectangleOfSize: boxSize)
        
        // Setup core motion 
        setupCoreMotion()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let vector = CGVector(dx: acceleration.dx * forceMultiplier, dy: acceleration.dy * forceMultiplier)
        box.physicsBody?.applyForce(vector)
    }
}
