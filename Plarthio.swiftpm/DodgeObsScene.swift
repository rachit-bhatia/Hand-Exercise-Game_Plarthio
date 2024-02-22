import SpriteKit
import SwiftUI

class DodgeObsScene: SKScene, SKPhysicsContactDelegate {
    private var gameFloor: SKSpriteNode!
    private var moverNode: SKShapeNode!
    private var signboardNode: SKSpriteNode!
    private var airBalloonNode: SKSpriteNode!
    private var scoreCounter: SKLabelNode!
    private var screenSize: CGSize!
    private var endGameBackground: SKShapeNode!
    private var restartButton: SKShapeNode!
    
    private var gameSpeed: CGFloat = 10
    private var speedIncrementPoint: Int = 100
    private var playerScore: Int = 0
    private var scoreIncrementInterval: Double = 0.5
    private var storedCurrentScoreTime: Double = 0
    private var storedCurrentSpawnTime: Double = 0
    private var obstacleInterval: Double = 1
    
    private let floorCategoryMask: UInt32 = 0b0001
    private let moverCategoryMask: UInt32 = 0b0010
    private let signboardCategoryMask: UInt32 = 0b0011
    private let airBalloonCategoryMask: UInt32 = 0b0100
    
    
    override init(size initScreenSize: CGSize) {
        super.init(size: initScreenSize)
        self.screenSize = initScreenSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.backgroundColor = .lightGray
        self.physicsWorld.contactDelegate = self
        self.size = screenSize
        
        self.createGameFloor()
        self.createMover()
        self.createScoreCounter()
        self.showEndGameMessage() 
        
        addActionButtons()
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
            
            //increase speed every after every +100 score 
            if (speedIncrementPoint - playerScore) <= 0 && scoreIncrementInterval > 0 {
                gameSpeed += 2
                scoreIncrementInterval -= 0.1
                speedIncrementPoint += 100
            }
            
            //increment score every 0.5 seconds
            if (currentTime - storedCurrentScoreTime) >= scoreIncrementInterval {
                scoreCounter.text = "Score: \(playerScore)"
                playerScore += 1
                storedCurrentScoreTime = currentTime
            }
            
            if (currentTime - storedCurrentSpawnTime) >= obstacleInterval {
                obstacleInterval = (Double.random(in: 2.5...3.6) * 10).rounded(.down) / 10 //randomising interval between obstacles
                
                if (Int.random(in: 1...10) < 6) {
                    createLandObstacle()
                } 
                else {
                    createAirObstacle()
                }
                
                storedCurrentSpawnTime = currentTime
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let tappedLocation = touch.location(in: self)
            let tappedNode = atPoint(tappedLocation)
            if tappedNode.name == "restart" {
                restartGame()
            } else if tappedNode.name == "jump" {
                jumpMover()
            } else if tappedNode.name == "duck" {
                contractMover()
            }
        }
    }
    
    func didBegin(_ physicalContact: SKPhysicsContact) {
        if (physicalContact.bodyA.categoryBitMask == signboardCategoryMask) || (physicalContact.bodyB.categoryBitMask == signboardCategoryMask) || (physicalContact.bodyA.categoryBitMask == airBalloonCategoryMask) || (physicalContact.bodyB.categoryBitMask == airBalloonCategoryMask) {
            gameSpeed = 0
            
            for obstacleNode in self.children {
                if obstacleNode.name == "signboard" || obstacleNode.name == "air_balloon" {
                    obstacleNode.removeAllActions()
                }
            } 
        }
    }
    
    func restartGame() {
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
        storedCurrentSpawnTime = 0
        scoreIncrementInterval = 0.5
        speedIncrementPoint = 100
        gameSpeed = 10
        
        //TODO: remove this line:
        addActionButtons()
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
        self.moverNode = SKShapeNode(rectOf: CGSize(width: 80, height: 350), cornerRadius: 30)
        moverNode.fillColor = .purple
        moverNode.strokeColor = .black
        moverNode.lineWidth = 5
        
        let xPos = 2*(moverNode.frame.size.width)
        let yPos = (gameFloor.position.y) + (moverNode.frame.size.height)/2   //on top of floor
        moverNode.position = CGPoint(x: xPos, y: yPos)
        
        let moverTexture = SKView().texture(from: moverNode)
        moverNode.physicsBody = SKPhysicsBody(texture: moverTexture!, size: moverTexture!.size())
        moverNode.physicsBody?.usesPreciseCollisionDetection = true 
        moverNode.physicsBody?.allowsRotation = false
        
        moverNode.physicsBody?.categoryBitMask = moverCategoryMask
        moverNode.physicsBody?.collisionBitMask = floorCategoryMask
        moverNode.physicsBody?.contactTestBitMask = signboardCategoryMask | airBalloonCategoryMask
        
        self.addChild(moverNode)
    } 
    
    
    private func createLandObstacle() {
        
        DispatchQueue.global().async { [self] in 
            let signboardImage = UIImage(named: "signboard")
            let signboardNodeTexture = SKTexture(image: signboardImage!)
            self.signboardNode = SKSpriteNode(texture: signboardNodeTexture)
            signboardNode.name = "signboard"
            
            signboardNode.size = CGSize(width: 150, height: 170)
            let initialX = gameFloor.size.width + (2 * signboardNode.size.width)
            let yPos = gameFloor.size.height + 60
            let offScreenDistance = -initialX - (2 * signboardNode.size.width)
            let offScreenDuration = -offScreenDistance / (gameSpeed * 60)  //multiply speed*60 because 60FPS
            
            signboardNode.position = CGPoint(x: initialX, y: yPos)
            signboardNode.zPosition = moverNode.zPosition + 1
            
            signboardNode.physicsBody = SKPhysicsBody(texture: signboardNodeTexture, size: signboardNode.size)
            signboardNode.physicsBody?.usesPreciseCollisionDetection = true
            signboardNode.physicsBody?.affectedByGravity = false
            signboardNode.physicsBody?.allowsRotation = false 
            
            signboardNode.physicsBody?.categoryBitMask = signboardCategoryMask
            signboardNode.physicsBody?.collisionBitMask = floorCategoryMask
            signboardNode.physicsBody?.contactTestBitMask = moverCategoryMask
            
            addAndMoveObstacle(distance: offScreenDistance, duration: offScreenDuration, obstacleNode: signboardNode)
        }
    }
    
    
    private func createAirObstacle() {
        
        DispatchQueue.global().async { [self] in 
            let airBalloonImage = UIImage(named: "hotAirBalloon")
            let airBalloonTexture = SKTexture(image: airBalloonImage!)
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
            airBalloonNode.physicsBody?.affectedByGravity = false
            airBalloonNode.physicsBody?.allowsRotation = false 
            
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
        moverNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1300))
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
        endGameBackground.position = CGPoint(x: (self.scene?.size.width)!/2, y: (self.scene?.size.height)!/2)
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
        restartButton.position = CGPoint(x: endGameBackground.position.x, y: endGameBackground.position.y - 100)
        restartButton.zPosition = .greatestFiniteMagnitude
        
        restartButton.addChild(restartButtonText)
        endGameBackground?.addChild(endGameMessage)
        self.addChild(self.endGameBackground)
        self.addChild(self.restartButton)
    }
    
    
    
    private func addActionButtons() {
        let jumpText = SKLabelNode(fontNamed: "")
        jumpText.fontSize = 30
        jumpText.text = "Jump"
        jumpText.fontColor = .white
        jumpText.position = CGPoint(x: 100, y: 50)
        jumpText.zPosition = .greatestFiniteMagnitude
        
        let jumpButtonSize = CGSize(width: jumpText.frame.width + 50, height: jumpText.frame.height + 30)
        let jumpButton = SKShapeNode(rectOf: jumpButtonSize, cornerRadius: 5)
        jumpButton.name = "jump"
        jumpButton.fillColor = .orange
        jumpButton.lineWidth = 3
        jumpButton.position = CGPoint(x: jumpText.position.x, y: jumpText.position.y + 10)
        jumpButton.zPosition = .greatestFiniteMagnitude - 1
        
        
        let duckText = SKLabelNode(fontNamed: "")
        duckText.fontSize = 30
        duckText.text = "Duck"
        duckText.fontColor = .white
        duckText.position = CGPoint(x: 300, y: 50)
        duckText.zPosition = .greatestFiniteMagnitude
        
        let duckButtonSize = CGSize(width: duckText.frame.width + 50, height: duckText.frame.height + 30)
        let duckButton = SKShapeNode(rectOf: duckButtonSize, cornerRadius: 5)
        duckButton.name = "duck"
        duckButton.fillColor = .blue
        duckButton.lineWidth = 3
        duckButton.position = CGPoint(x: duckText.position.x, y: duckText.position.y + 10)
        duckButton.zPosition = .greatestFiniteMagnitude - 1
        
        self.addChild(jumpButton)
        self.addChild(jumpText)
        self.addChild(duckButton)
        self.addChild(duckText)
    }
}




struct DodgeObsView: View {
    
    var body: some View {
        GeometryReader { geometry in

            ZStack {
                SpriteView(scene: DodgeObsScene(size: geometry.size))
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
