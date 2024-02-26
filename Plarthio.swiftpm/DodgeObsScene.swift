import SpriteKit
import SwiftUI

class DodgeObsScene: SKScene, SKPhysicsContactDelegate {
    private var gameFloor: SKSpriteNode!
    private var moverNode: SKSpriteNode!
    private var signboardNode: SKSpriteNode!
    private var airBalloonNode: SKSpriteNode!
    private var scoreCounter: SKLabelNode!
    private var screenSize: CGSize!
    private var endGameBackground: SKShapeNode!
    private var restartButton: SKShapeNode!
    private var contractActionButton: SKShapeNode!
    private var jumpActionButton: SKShapeNode!
    private var instructionPaneNode: SKSpriteNode!
    
    private var moverRunImages = ["moverRun1", "moverRun2"]
    private var moverImageIndex = 1 
    private var storedMoverImageTime: Double = 0
    private var gameSpeed: CGFloat = 10
    private var speedIncrementPoint: Int = 50
    private var playerScore: Int = 0
    private var scoreIncrementInterval: Double = 0.5
    private var storedCurrentScoreTime: Double = 0
    private var storedCurrentObstacleTime: Double = 0
    private var obstacleInterval: Double = 1
    private var actionInProgress: Bool = false
    private var hasCrashed: Bool = false
    
    private let floorCategoryMask: UInt32 = 0b0001
    private let moverCategoryMask: UInt32 = 0b0010
    private let signboardCategoryMask: UInt32 = 0b0011
    private let airBalloonCategoryMask: UInt32 = 0b0100
    
    static var detectedHandPose: String = ""
    
    
    override init(size initScreenSize: CGSize) {
        super.init(size: initScreenSize)
        self.screenSize = initScreenSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        self.physicsWorld.contactDelegate = self
        self.size = screenSize
        
        self.createGameFloor()
        self.createMover()
        self.createScoreCounter()
        self.showEndGameMessage() 
        self.addShowInstructionsButton()
        self.showInstructions()
        
        self.jumpActionButton = addActionButtons(buttonText: "Jump", buttonPosition: CGPoint(x: 100, y: 60))
        self.contractActionButton = addActionButtons(buttonText: "Contract", buttonPosition: CGPoint(x: self.frame.width-110, y: 60))
    }

    override func update(_ currentTime: CFTimeInterval) {
        self.setGameFloorInMotion()
        
        if gameSpeed > 0 {
            endGameBackground.position.y = (self.scene?.size.height)! * 3
            restartButton.position.y = (self.scene?.size.height)! * 3
            
            //showing end game message on the scene only when gameSpeed<=0 
            DispatchQueue.main.async {
                self.endGameBackground.position.y = (self.scene?.size.height)! / 2
                self.restartButton.position.y = self.endGameBackground.position.y - 100
            }
            
            if (currentTime - storedMoverImageTime) >= 0.1 {
                moverImageIndex = (moverImageIndex + 1) % moverRunImages.count
                moverNode.texture = SKTexture(imageNamed: moverRunImages[moverImageIndex])
                storedMoverImageTime = currentTime
            }
            
            //perform action based on detected hand pose
            if DodgeObsScene.detectedHandPose == "open_palm" {
                jumpMover()
            } else if DodgeObsScene.detectedHandPose == "closed_fist" {
                contractMover()
            }
            DodgeObsScene.detectedHandPose = ""
            
            //increase speed every after every +50 score 
            if (speedIncrementPoint - playerScore) <= 0 && scoreIncrementInterval > 0 {
                gameSpeed += 2
                scoreIncrementInterval -= 0.1
                speedIncrementPoint += 50
            }
            
            //increment score every 0.5 seconds
            if (currentTime - storedCurrentScoreTime) >= scoreIncrementInterval {
                scoreCounter.text = "Score: \(playerScore)"
                playerScore += 1
                storedCurrentScoreTime = currentTime
            }
            
            //randomly create obstacles
            if (currentTime - storedCurrentObstacleTime) >= obstacleInterval {
                obstacleInterval = (Double.random(in: 2.5...3.6) * 10).rounded(.down) / 10 //randomising interval between obstacles
                
                if (Int.random(in: 1...10) < 6) {
                    createLandObstacle()
                } 
                else {
                    createAirObstacle()
                }
                
                storedCurrentObstacleTime = currentTime
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let tappedLocation = touch.location(in: self)
            let tappedNode = atPoint(tappedLocation)
            if tappedNode.name == "restart" {
                restartGame()
                hasCrashed = false
            } else if tappedNode.name == "insButton" && instructionPaneNode?.parent == nil {
                showInstructions()
            }
            
            if gameSpeed > 0 {
                if tappedNode.name == jumpActionButton.name {
                    jumpMover()
                } else if tappedNode.name == contractActionButton.name {
                    contractMover()
                }
            }
            
            let allTappedNodes = nodes(at: tappedLocation)
            for tapNode in allTappedNodes {
                if tapNode.name == "insDismiss" {
                    dismissInstructions()
                }
            }
        }
    }
    
    func didBegin(_ physicalContact: SKPhysicsContact) {
        if (physicalContact.bodyA.categoryBitMask == signboardCategoryMask) || (physicalContact.bodyB.categoryBitMask == signboardCategoryMask) || (physicalContact.bodyA.categoryBitMask == airBalloonCategoryMask) || (physicalContact.bodyB.categoryBitMask == airBalloonCategoryMask) {
            gameSpeed = 0
            hasCrashed = true
            for obstacleNode in self.children {
                if obstacleNode.name == "signboard" || obstacleNode.name == "air_balloon" {
                    obstacleNode.removeAllActions()
                }
            } 
        }
    }
    
    private func restartGame() {
        gameFloor.removeAllChildren()
        moverNode.removeAllActions()
        moverNode.removeFromParent()
        
        for childNode in self.children {
            if (childNode.name == "signboard") || (childNode.name == "air_balloon") {
                childNode.removeFromParent()
            }
        }
        createMover()
        
        storedCurrentScoreTime = 0
        playerScore = 0
        scoreCounter.text = "Score: 0"
        storedCurrentObstacleTime = 0
        scoreIncrementInterval = 0.5
        speedIncrementPoint = 100
        actionInProgress = false
        gameSpeed = 10
    }
    
    
    private func showInstructions() {
        self.instructionPaneNode = SKSpriteNode(imageNamed: "dodgeObsInstructions") 
        instructionPaneNode.size = CGSize(width: 630, height: 850)
        instructionPaneNode.position = CGPoint(x: self.frame.width/2, y: -self.frame.height/2)
        instructionPaneNode.zPosition = .greatestFiniteMagnitude
        
        let goButtonText = SKLabelNode(fontNamed: "")
        goButtonText.fontSize = 30
        goButtonText.text = "Let's go!"
        goButtonText.fontColor = .white
        goButtonText.position = CGPoint(x: 0, y: -instructionPaneNode.size.height/2 + 70)
        
        let goButtonSize = CGSize(width: goButtonText.frame.width + 60, height: goButtonText.frame.height + 20)
        let goButton = SKShapeNode(rectOf: goButtonSize, cornerRadius: 10)
        goButton.name = "insDismiss"
        goButton.fillColor = UIColor(red: 0.65, green: 0.35, blue: 0, alpha: 1)
        goButton.lineWidth = 2
        goButton.position = CGPoint(x: goButtonText.position.x, y: goButtonText.position.y + 10)

        self.addChild(instructionPaneNode)
        instructionPaneNode.addChild(goButton)
        instructionPaneNode.addChild(goButtonText)
        
        let appearAction = SKAction.moveBy(x: 0, y: self.frame.size.height, duration: 0.3)
        instructionPaneNode.run(appearAction)
        
        //handle stoppinh of game by setting gameSpeed to 0 
        gameSpeed = 0 
        
        for obstacleNode in self.children {
            if obstacleNode.name == "signboard" || obstacleNode.name == "air_balloon" {
                obstacleNode.removeAllActions()
            }
        } 
        
        if !hasCrashed {
            endGameBackground.position.y = (self.scene?.size.height)! * 3
            restartButton.position.y = (self.scene?.size.height)! * 3
        } else {
            hasCrashed = false
        }
    }
    
    private func addShowInstructionsButton() {
        let imageConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        let insButtonImage = UIImage(systemName: "questionmark.circle.fill", withConfiguration: imageConfig)
        let insButtonTexture = SKTexture(image: insButtonImage!)
        let insButtonNode = SKSpriteNode(texture: insButtonTexture)
        
        insButtonNode.size = CGSize(width: 50, height: 50)
        insButtonNode.position = CGPoint(x: self.frame.width - 50, y: self.frame.height - 80)
        insButtonNode.name = "insButton"
        
        self.addChild(insButtonNode)
    }
    
    private func dismissInstructions() {
        let disappearAction = SKAction.moveBy(x: 0, y: -self.frame.height, duration: 0.3)
        let disappearSequence = SKAction.sequence([disappearAction, SKAction.removeFromParent()])
        
        instructionPaneNode.run(disappearSequence)
        
        //restart game when user views instructions to give a fresh start
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.restartGame()
        }
    }
    
    private func createGameFloor() {
        //placing 3 nodes side by side
        for i in 0...2 {
            self.gameFloor = SKSpriteNode(imageNamed: "brownFloor")
            gameFloor.name = "game_floor"
            gameFloor.size = CGSize(width: self.frame.size.width, height: 300)
            gameFloor.anchorPoint = CGPoint(x: 0, y: 1)
            gameFloor.position = CGPoint(x: CGFloat(i) * (gameFloor.size.width), y: ((self.scene?.size.height)!/4))
            
            gameFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (gameFloor.frame.size.width), height: 1))
            gameFloor.physicsBody?.isDynamic = false
            gameFloor.physicsBody?.restitution = 0
            gameFloor.physicsBody?.categoryBitMask = floorCategoryMask
            
            self.addChild(gameFloor)
        }
    }
    
    private func setGameFloorInMotion() {
        self.enumerateChildNodes(withName: "game_floor", using: ({ (floorNode, error) in
            floorNode.position.x -= self.gameSpeed
            if floorNode.position.x < -self.frame.size.width {
                floorNode.position.x += self.frame.size.width * 2  //reposition to after the next 2 nodes
            }
        }))
    }
    
    private func createMover() {
        let moverTexture = SKTexture(imageNamed: moverRunImages[0])
        self.moverNode = SKSpriteNode(texture: moverTexture)
        
        moverNode.size = CGSize(width: 80, height: 350)
        
        let xPos = 2*(moverNode.frame.size.width)
        let yPos = (gameFloor.position.y) + (moverNode.frame.size.height)/2   //on top of floor
        moverNode.position = CGPoint(x: xPos, y: yPos)
        
        moverNode.physicsBody = SKPhysicsBody(texture: moverTexture, size: moverTexture.size())
        moverNode.physicsBody?.usesPreciseCollisionDetection = true 
        moverNode.physicsBody?.allowsRotation = false
        
        moverNode.physicsBody?.categoryBitMask = moverCategoryMask
        moverNode.physicsBody?.collisionBitMask = floorCategoryMask
        moverNode.physicsBody?.contactTestBitMask = signboardCategoryMask | airBalloonCategoryMask
        
        self.addChild(moverNode)
    } 
    
    
    private func createLandObstacle() {
        
        DispatchQueue.global().async { [self] in 
            let signboardNodeTexture = SKTexture(imageNamed: "signboard")
            self.signboardNode = SKSpriteNode(texture: signboardNodeTexture)
            signboardNode.name = "signboard"
            
            signboardNode.size = CGSize(width: 150, height: 170)
            let initialX = gameFloor.size.width + (2 * signboardNode.size.width)
            let yPos = gameFloor.size.height + signboardNode.size.height/2
            let offScreenDistance = -initialX - (2 * signboardNode.size.width)
            let offScreenDuration = -offScreenDistance / (gameSpeed * 60)  //multiply speed*60 because 60FPS
            
            signboardNode.position = CGPoint(x: initialX, y: yPos)
            signboardNode.zPosition = moverNode.zPosition + 1
            
            signboardNode.physicsBody = SKPhysicsBody(texture: signboardNodeTexture, size: signboardNode.size)
            signboardNode.physicsBody?.usesPreciseCollisionDetection = true
            signboardNode.physicsBody?.isDynamic = false
            
            signboardNode.physicsBody?.categoryBitMask = signboardCategoryMask
            signboardNode.physicsBody?.collisionBitMask = floorCategoryMask
            signboardNode.physicsBody?.contactTestBitMask = moverCategoryMask
            
            addAndMoveObstacle(distance: offScreenDistance, duration: offScreenDuration, obstacleNode: signboardNode)
        }
    }
    
    
    private func createAirObstacle() {
        
        DispatchQueue.global().async { [self] in 
            let airBalloonTexture = SKTexture(imageNamed: "hotAirBalloon")
            self.airBalloonNode = SKSpriteNode(texture: airBalloonTexture)
            airBalloonNode.name = "air_balloon"
            
            airBalloonNode.size = CGSize(width: 200, height: 250)
            let initialX = gameFloor.size.width + (2 * airBalloonNode.size.width) + 100
            let yPos = gameFloor.size.height + (airBalloonNode.size.height * 1.5)
            let offScreenDistance = -initialX - (2 * airBalloonNode.size.width)
            let offScreenDuration = -offScreenDistance / (gameSpeed * 60) 
            
            airBalloonNode.position = CGPoint(x: initialX, y: yPos)
            airBalloonNode.zPosition = moverNode.zPosition + 1
            
            airBalloonNode.physicsBody = SKPhysicsBody(texture: airBalloonTexture, size: airBalloonNode.size)
            airBalloonNode.physicsBody?.usesPreciseCollisionDetection = true
            airBalloonNode.physicsBody?.isDynamic = false
            
            
            airBalloonNode.physicsBody?.categoryBitMask = airBalloonCategoryMask
            airBalloonNode.physicsBody?.collisionBitMask = floorCategoryMask
            airBalloonNode.physicsBody?.contactTestBitMask = moverCategoryMask
            
            addAndMoveObstacle(distance: offScreenDistance, duration: offScreenDuration, obstacleNode: airBalloonNode)
        }
    }
    
    //add obstacle node to scene and enable its movement
    private func addAndMoveObstacle(distance: CGFloat, duration: TimeInterval, obstacleNode: SKSpriteNode) {
        DispatchQueue.main.async { [self] in
            self.addChild(obstacleNode)
            
            let movingAction = SKAction.moveBy(x: distance, y: 0, duration: duration)
            let movingSequence = SKAction.sequence([movingAction, SKAction.removeFromParent()])
            
            obstacleNode.run(movingSequence)
        }
    }
    
    private func createScoreCounter() {
        self.scoreCounter = SKLabelNode(fontNamed: "Arial")
        scoreCounter.fontSize = 30
        scoreCounter.text = "Score: \(playerScore)"
        scoreCounter.fontColor = .black
        scoreCounter.zPosition = .greatestFiniteMagnitude
        
        let scorePosition = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)! - 50) 
        scoreCounter.position = scorePosition
        
        self.addChild(scoreCounter)
    }
    
    private func jumpMover() {
        if !actionInProgress {
            actionInProgress = true
            moverNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1200))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                self.actionInProgress = false
            }
        }
    }
    
    private func contractMover() {
        let contractActionSequence = SKAction.sequence([SKAction.scaleY(to: 0.5, duration: 0.5),
                                                        SKAction.scaleY(to: 1, duration: 1)])
        moverNode.run(contractActionSequence)
    }
    
    private func showEndGameMessage() {
        //end game message
        let endGameMessage = SKLabelNode()
        endGameMessage.fontSize = 45
        endGameMessage.text = "Mover crashed"
        endGameMessage.fontColor = .white
        endGameMessage.position = CGPoint(x: 0, y: -15)
        endGameMessage.zPosition = .greatestFiniteMagnitude - 1
        
        let endGameBackgroundSize = CGSize(width: endGameMessage.frame.width + 50, height: endGameMessage.frame.height + 50)
        self.endGameBackground = SKShapeNode(rectOf: endGameBackgroundSize, cornerRadius: 5)
        endGameBackground.fillColor = .darkGray
        endGameBackground.lineWidth = 0
        endGameBackground.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)! * 3)
        endGameBackground.zPosition = .greatestFiniteMagnitude
    
        //restart button
        let restartButtonText = SKLabelNode(fontNamed: "Arial")
        restartButtonText.fontSize = 30
        restartButtonText.text = "Tap to restart"
        restartButtonText.fontColor = .white
        restartButtonText.position = CGPoint(x: 0, y: -10)
        restartButtonText.zPosition = .greatestFiniteMagnitude - 1
        
        let restartButtonSize = CGSize(width: restartButtonText.frame.width + 40, height: restartButtonText.frame.height + 30)
        self.restartButton = SKShapeNode(rectOf: restartButtonSize, cornerRadius: 10)
        restartButton.name = "restart"
        restartButton.fillColor = .darkGray
        restartButton.strokeColor = .black
        restartButton.lineWidth = 4
        restartButton.position = CGPoint(x: endGameBackground.position.x, y: (self.scene?.size.height)! * 3)
        restartButton.zPosition = .greatestFiniteMagnitude
        
        restartButton.addChild(restartButtonText)
        endGameBackground?.addChild(endGameMessage)
        self.addChild(self.endGameBackground)
        self.addChild(self.restartButton)
    }
    
    
    
    private func addActionButtons(buttonText: String, buttonPosition: CGPoint) -> SKShapeNode {
        let actionText = SKLabelNode(fontNamed: "")
        actionText.fontSize = 26
        actionText.text = buttonText
        actionText.fontColor = .white
        actionText.position = buttonPosition
        actionText.zPosition = .greatestFiniteMagnitude

        let actionButtonSize = CGSize(width: actionText.frame.width + 50, height: actionText.frame.height + 20)
        let actionButton = SKShapeNode(rectOf: actionButtonSize, cornerRadius: 10)
        actionButton.name = buttonText
        actionButton.fillColor = UIColor(red: 0.7, green: 0.4, blue: 0, alpha: 1)
        actionButton.lineWidth = 0
        actionButton.position = CGPoint(x: actionText.position.x, y: actionText.position.y + 10)
        actionButton.zPosition = .greatestFiniteMagnitude - 1
        
        self.addChild(actionButton)
        self.addChild(actionText)

        return actionButton
    }
}




struct DodgeObsView: View {
    
    var body: some View {
        GeometryReader { geometry in

            ZStack {
                SpriteView(scene: DodgeObsScene(size: geometry.size), options: [.allowsTransparency])
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea(edges: .all)
            }
        }
    }
}


struct DodgeObsView_Previews: PreviewProvider {
    static var previews: some View {
        DodgeObsView()
    }
} 
