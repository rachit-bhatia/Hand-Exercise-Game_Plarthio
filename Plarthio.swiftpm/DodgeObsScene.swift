import SpriteKit
import SwiftUI

class DodgeObsScene: SKScene {
    private var gameFloor: SKSpriteNode!
    private var moverNode: SKShapeNode!
    private var screenSize: CGSize!
    private var gameSpeed: CGFloat = 5
    
    override init(size initScreenSize: CGSize) {
        super.init(size: initScreenSize)
        self.screenSize = initScreenSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.size = screenSize
        self.createGameFloor()
        self.createMover()
        self.createLandObstacle()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        self.setGameFloorInMotion()
    }
 
    
    private func createGameFloor() {
        //placing 3 nodes side by side
        for i in 0...2 {
            self.gameFloor = SKSpriteNode(imageNamed: "brownFloor")
            gameFloor.name = "game_floor"
            gameFloor.size = CGSize(width: (self.scene?.size.width)!, height: 300)
            gameFloor.anchorPoint = CGPoint(x: 0, y: 1)
            gameFloor.position = CGPoint(x: CGFloat(i) * (gameFloor.size.width), y: ((self.scene?.size.height)!/4))
            
            gameFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (gameFloor.frame.size.width), height: 1))
            gameFloor.physicsBody?.isDynamic = false
            
            self.addChild(gameFloor)
        }
    }
    
    private func setGameFloorInMotion() {
        self.enumerateChildNodes(withName: "game_floor", using: ({ (floorNode, error) in
            floorNode.position.x -= self.gameSpeed
            if floorNode.position.x < -((self.scene?.size.width)!) {
                floorNode.position.x += (self.scene?.size.width)! * 2  //reposition to after the next 2 nodes
            }
        }))
    }
    
    private func createMover() {
        self.moverNode = SKShapeNode(rectOf: CGSize(width: 80, height: 250), cornerRadius: 30)
        moverNode.fillColor = .purple
        moverNode.strokeColor = .black
        moverNode.lineWidth = 5
        
        let xPos = 2*(moverNode.frame.size.width)
        let yPos = (gameFloor.position.y) + (moverNode.frame.size.height)/2   //on top of floor
        moverNode.position = CGPoint(x: xPos, y: yPos)
        
        let moverTexture = SKView().texture(from: moverNode)
        moverNode.physicsBody = SKPhysicsBody(texture: moverTexture!, size: moverTexture!.size())
        moverNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(moverNode)
    } 
    
    private func createLandObstacle() {
        let treeColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)
        let oriTreeImage = UIImage(systemName: "tree.fill")?.withTintColor(treeColor)
        let oriTreeImageMap = oriTreeImage?.pngData() 
        let treeImage = UIImage(data: oriTreeImageMap!)  //creating new image from its bitmap to allow coloured UIImage
        let treeNodeTexture = SKTexture(image: treeImage!)
        let treeNode = SKSpriteNode(texture: treeNodeTexture)
        
        treeNode.size = CGSize(width: 120, height: 120)
        treeNode.position = CGPoint(x: 0, y: treeNode.size.height/2)
        
//        let borderPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: -treeNode.size.width / 2, y: -treeNode.size.height / 2), size: treeNode.size))
        treeNode.physicsBody = SKPhysicsBody(texture: treeNodeTexture, size: treeNode.size)
        treeNode.physicsBody?.usesPreciseCollisionDetection = true

        
        gameFloor.addChild(treeNode)
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
