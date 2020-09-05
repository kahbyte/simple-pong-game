//
//  GameScene.swift
//  Multiplayer Pong
//
//  Created by Kauê Sales on 28/08/20.
//  Copyright © 2020 Kauê Sales. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: Initial Configuration 🔧
    
    //SCENE EDITOR NODES
    var ball = SKSpriteNode()
    var player = SKSpriteNode()
    var opponent = SKSpriteNode()
    
    //SCENE EDITOR LABELS
    var playerScore = SKLabelNode()
    var opponentScore = SKLabelNode()
    
    //Just avoiding magic numbers
    var score = (playerScore: 0, opponentScore: 0) //Tuple that will be used for printing, keeping and updating score
    var force = 8 //Will be used for the 45º ball impulse
    var maxScore = 10 //self explained... right? 🧐
    
    
    override func didMove(to view: SKView) {
        //Using the Scene Editor nodes programmatically 💪🏾
        ball = self.childNode(withName: "ball") as! SKSpriteNode //So we can control the ball. Duh.
        
        player = self.childNode(withName: "playerPaddle") as! SKSpriteNode
        player.position.x = (-self.frame.width / 2) + 70 // sets paddle position programmatically. Helps with different sizes 📏
        
        opponent = self.childNode(withName: "opponentPaddle") as! SKSpriteNode
        opponent.position.x = (self.frame.width / 2) - 70 // sets paddle position programmatically. Helps with different sizes 📏
        
        playerScore = self.childNode(withName: "playerScore") as! SKLabelNode //You know, so we can update the score and stuff
        opponentScore = self.childNode(withName: "opponentScore") as! SKLabelNode
        
        //From now on, I'm basically saying that the frame of the device is the ball final frontier 🚀🌌
        let border = SKPhysicsBody(edgeLoopFrom: self.frame) //Yaass ball, the frame exists! 💅🏽
        
        border.friction = 0 //Touching the wall won't slow you down
        border.restitution = 1 //The force that you apply on the wall, will be back as strong, so you won't lose momentum 🏃🏽
        self.physicsBody = border //After configuring the border, I say that the physics of the scene will use these settings
        
        startGame() //Automatically starts the game. LET'S GOOOOOOO 🎮
    }
    
    //MARK: Game Controls
    
    //FOR TAP MOVEMENT. Slower for balancing purposes
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { //For every touch 👆🏽
            let location  = touch.location(in: self) // It'll capture it's location 🗺
            movePaddle(touchLocation: location)
        }
    }
    
    //FOR DRAG MOVEMENT. WORKS EXACTLY THE SAME AS TAP, EXCEPT YOU'RE DRAGGING. DUH.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { //For every touch 👆🏽
            let location  = touch.location(in: self) // It'll capture it's location 🗺
            movePaddle(touchLocation: location)
        }
    }
    
    //It will do stuff every frame.
    override func update(_ currentTime: TimeInterval) {
        if ball.position.x <= player.position.x{
            addScore(playerWhoScored: opponent)
        }
        else if ball.position.x >= opponent.position.x{
            addScore(playerWhoScored: player)
        }
    }
}


/*Too much functions will be created just for the game to work. It's too much information. Let's keep the game function in this extension of the class, ok? #CleanCode 💪🏾*/
//MARK: Game Functions 🎮
extension GameScene {
    /*Sets the initial values to the labels and then launches the ball randomly for the first time*/
    func startGame() {
        //Using the tuple to set or reset to initial values. Pretty cool, right?
        score.playerScore = 0
        score.opponentScore = 0
        
        updateScoreLabels()
        
        ball.physicsBody?.applyImpulse(CGVector(dx: randomMultiplier() * force, dy: randomMultiplier() * force))
    }
    
    /*The score labels only accepts Strings, so here we are casting the score tuple's values and updating the labels*/
    func updateScoreLabels() {
        playerScore.text = String(score.playerScore)
        opponentScore.text = String(score.opponentScore)
    }
    
    /*It will generate a random number and then if this number is even or odd it will return 1 or -1 respectively.
     the returned value is used when we want to randomly send the ball up or down and left or right, multiplying this value with the force that's already been set.*/
    func randomMultiplier() -> Int {
        let random = Int.random(in: 0...9)
        
        return (random % 2 == 0 ? 1 : -1)
    }
    
    /*This function will receive what player scored a point, then it will add 1 point to the correct variable of the tuple, update the score label and finally it will launch the ball again to the enemy side*/
    func addScore(playerWhoScored: SKSpriteNode) {
        var impulse: CGVector! //it will be used to prepare the impulse after a player scored
        
        resetBall()
        
        if playerWhoScored == player {
            score.playerScore += 1
            impulse = CGVector(dx: force, dy: randomMultiplier() * force) //it will prepare the impulse to the right and random up or down
        }
        
        else if playerWhoScored == opponent {
            score.opponentScore += 1
            impulse = CGVector(dx: -force, dy: randomMultiplier() * force) //it will prepare the impulse to the left and random up or down
        }
        
        updateScoreLabels()
        
        print(score)
        
        if score.playerScore == maxScore || score.opponentScore == maxScore {
            endGame()
        } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            self.ball.physicsBody?.applyImpulse(impulse)
            })
        }
    }
    
    /*Moves the  paddles accordingly to the touch location. Different delays for tapping and draging for balancing purposes.
     You can read ternary if as "(condition) ?(if) TRUE :(else) FALSE"  */
    func movePaddle(touchLocation: CGPoint) {
        if touchLocation.x < 0 { // if the location was in the left side of the screen
            player.run(SKAction.moveTo(y: touchLocation.y, duration: 0.1)) // the left paddle will move ⬅️
        }
            
        else if touchLocation.x > 0 { //if it was in the right side of the screen
            opponent.run(SKAction.moveTo(y: touchLocation.y, duration: 0.1)) // the right paddle will move ➡️. The delay is for cool effects 👌🏽
        }
    }
    
    /*Resets the ball to the initial location and removes all it's velocity so it doesn't stack*/
    func resetBall(){
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    /*The game is over. The ball no longer moves.*/
    func endGame() {
        resetBall()
    }
}

