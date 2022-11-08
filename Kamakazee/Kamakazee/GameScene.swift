//
//  GameScene.swift
//  Kamakazee
//
//  Created by Ahmed Musa on 2/12/2016.
//  Copyright (c) 2016 Moses Apps. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var score = 0
    var health = 5
    var gameOver : Bool?
    let maxNumberOfShips = 10
    var currentNumberOfShips: Int?
    //added ()
    var timeBetweenShips: Double?
    var moverSpeed = 5.0
    let moveFactor = 1.05
    var now : NSDate?
    var nextTime : NSDate?
    var gameOverLabel : SKLabelNode?
    var healthLabel : SKLabelNode?
    
    //entry point into our scene
    override func didMoveToView(view: SKView) {
        initializeValues()
        self.backgroundColor = SKColor.blackColor()
        //changed the background color from grey (default) to black here
    }
    
    //sets the initial values for our variables
    func initializeValues() {
        self.removeAllChildren()
        
        score = 0
        health = 5
        gameOver = false
        currentNumberOfShips = 0
        timeBetweenShips = 1.0
        moverSpeed = 5.0
        nextTime = NSDate()
        now = NSDate()
        
        healthLabel = SKLabelNode(fontNamed: "System")
        healthLabel?.text = "Health: \(health)"
        healthLabel?.fontSize = 30
        healthLabel?.fontColor = SKColor.blueColor()
        healthLabel?.position = CGPoint(x:CGRectGetMinX(self.frame) + 80, y:(CGRectGetMinY(self.frame) + 100))
        
        self.addChild(healthLabel!)
        //! added
    }
    
    //called before each frame is rendered
    
    override func update(currentTime: CFTimeInterval) {
        
        healthLabel?.text = "Health: \(health)"
        if(health <= 3) {
            healthLabel?.fontColor = SKColor.redColor()
        }
        
        now = NSDate()
        if (currentNumberOfShips < maxNumberOfShips &&
            now?.timeIntervalSince1970 > nextTime?.timeIntervalSince1970 &&
            health > 0) {
            nextTime = now?.dateByAddingTimeInterval(NSTimeInterval(timeBetweenShips!))
            let newX = Int(arc4random()%1024)
            let newY = Int(self.frame.height+10)
            let p = CGPoint(x:newX,y:newY)
            let destination = CGPoint(x:newX, y:0)
            //all 4 var's changed to let
            
            createShip(p, destination: destination)
            
            moverSpeed = moverSpeed/moveFactor
            timeBetweenShips = timeBetweenShips!/moveFactor
        }
        checkIfShipsReachTheBottom()
        checkIfGameIsOver()
    }
    
/* creates a ship
 rotates it 90
 adds a mover so it goes downwards
 adds the ship to the scene
 */
    func createShip(p:CGPoint, destination:CGPoint) {
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.name = "Destroyable"
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = p
        
        let duration = NSTimeInterval(moverSpeed)
        let action = SKAction.moveTo(destination, duration: duration)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        let rotationAction = SKAction.rotateToAngle(CGFloat(3.142), duration: 0)
        sprite.runAction(SKAction.repeatAction(rotationAction, count: 0))
        
        currentNumberOfShips? += 1
        self.addChild(sprite)
    }
 
    //called when a touch begins
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            //as replaced with as!
            if let theName = self.nodeAtPoint(location).name {
                if theName == "Destroyable" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    currentNumberOfShips? -= 1
                    score += 1
                }
            }
            if (gameOver == true) {
                //gameOver? replaced with gameOver
                initializeValues()
            }
        }
        
    }

    //check if the game is over by looking at your health
    //shows game over screen if needed
    
    func checkIfGameIsOver() {
        if (health <= 0 && gameOver == false) {
            self.removeAllChildren()
            showGameOverScreen()
            gameOver =  true
        }
    }
    
    //check if an enemy ship reaches the bottom of our screen
    
    func checkIfShipsReachTheBottom() {
        for child in self.children {
            if(child.position.y == 0) {
                self.removeChildrenInArray([child])
                currentNumberOfShips? -= 1
                health -= 1
            }
        }
    }

    //displays the actual game over screen
    
    func showGameOverScreen() {
        gameOverLabel = SKLabelNode(fontNamed:"System")
        gameOverLabel?.text = "Game Over! Score: \(score)"
        gameOverLabel?.fontColor = SKColor.redColor()
        gameOverLabel?.fontSize = 65
        gameOverLabel?.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(gameOverLabel!)
    }
}




