import SwiftUI


struct ColorCatchView: View {
    private let trayWidth: CGFloat = 100, trayHeight: CGFloat = 100
    private let rotationDuration: Double = 3
    private let fallDistance: CGFloat = 330
    
    static var detectedHandPose: String = ""
    
    @State private var showGameComponents = false
    @State private var instructionsPaneOffset: CGFloat = UIScreen.main.bounds.height 
    
    //color tray rotation
    @State private var isRotatingClockwise = true
    @State private var updatedRotationAngle: CGFloat = 0
    @State private var currentRotationAngle: CGFloat = 0
    @State private var trayAngleScheduler: Timer?
    
    //coin rotation
    @State private var coinScheduler: Timer?
    @State private var coinRotation: CGFloat = 0
    @State private var coinYOffset: CGFloat = 0
    @State private var currentCoinColor: Color
    @State private var coinOpacity: Double = 1
    private let coinFallDuration: Double = 3
    
    //color tray stored attributes
    private let colorArray = [Color.blue, Color.purple, Color.orange, Color.red]
    private let colorAngleDict: [Color:Double]
    
    //scorekeeper
    @State private var gameScore = 0
    @State private var scoreIndicatorColor = Color.black
    
    init () {
        self.currentCoinColor = colorArray.randomElement()!
        self.colorAngleDict = [colorArray[0]: 0.0,
                               colorArray[1]: 270.0,
                               colorArray[2]: 90.0,
                               colorArray[3]: 180.0]
    }


    var body: some View{
        ZStack {
          //  Color.gray
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        
                        //instructions button
                        Button(action: {
                            showGameComponents = false
                        }, label: {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .tint(Color.black)
                                .frame(width: 50, height: 50)
                                .padding(.all)
                                .padding(.top, 40)
                        })
                        
                        //restart button
                        Button(action: { restartGame() }, label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .resizable()
                                .tint(Color.black)
                                .frame(width: 50, height: 50)
                                .padding(.all)
                        })
                        .disabled(!showGameComponents)
                    }
                }
                Spacer()
            }
            
            
            VStack {
                Spacer()
                    .frame(height: 100)
                
                Rectangle()
                    .fill(Color.brown)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 150, height: 30)
                    .shadow(radius: 5, y: 5)
                    .offset(y:30)
                    .zIndex(2)
                    .rotation3DEffect(.degrees(30), axis: (x: 1, y:0, z:0))
                
                //coin
                Circle()
                    .fill(currentCoinColor) 
                    .stroke(Color.black, lineWidth: 3)
                    .frame(width: trayWidth-20, height: trayHeight-20)
                    .rotation3DEffect(.degrees(coinRotation), axis: (x: 0, y:1, z:0))
                    .opacity(coinOpacity)
                    .offset(y: coinYOffset)
                    .zIndex(1)
                       
                Spacer()
                    .frame(height: fallDistance - 100)
                
                //color tray
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width:350, height:350)
                    
                    VStack {
                        Circle()
                            .fill(self.colorArray[0])
                            .frame(width: trayWidth, height: trayHeight)
                        
                        HStack {
                            Circle()
                                .fill(self.colorArray[1])
                                .frame(width: trayWidth, height: trayHeight)
                            
                            Spacer()
                                .frame(width:120)
                            
                            Circle()
                                .fill(self.colorArray[2])
                                .frame(width: trayWidth, height: trayHeight)
                        }
                        
                        Circle()
                            .fill(self.colorArray[3])
                            .frame(width: trayWidth, height: trayHeight)
                    }
                }
                .rotationEffect(.degrees(self.updatedRotationAngle))
                .onChange(of: ColorCatchView.detectedHandPose, initial: false) {
                    
                    //run action only if hand pose and current rotation direction do not correspond 
                    if (ColorCatchView.detectedHandPose == "rock" && !isRotatingClockwise) || 
                        (ColorCatchView.detectedHandPose == "three2_sign" && isRotatingClockwise) {
                        
                        changeTrayRotationDirection()
                    }
                }
                
                Spacer()
                    .frame(height: 50)
                
                Text("Score: \(self.gameScore)")
                    .font(.system(size: 25))
                    .frame(width: 250)
                    .padding(.vertical, 10)
                    .background(self.scoreIndicatorColor.opacity(0.7))
                    .cornerRadius(20)
                    .animation(.linear(duration: 0), value: self.gameScore)
                
                Spacer()
                
                
                Button(action: {
                    changeTrayRotationDirection()
                }) 
                { Text(isRotatingClockwise ? "Rotate Counterclockwise" : "Rotate Clockwise")
                        .font(.system(size: 25))
                        .frame(width: 300)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.5, green: 0.3, blue: 0))
                        .cornerRadius(10)
                }
                 .disabled(!showGameComponents)
                
                Spacer()
            }
            
            
            if !showGameComponents {
                ZStack{
                    Image("colorCatchInstructions")
                        .resizable()
                        .frame(width: 670, height: 1000)
                    
                    VStack {
                        Spacer()
                            .frame(height: 700)
                        Button(action: {
                            withAnimation(.linear(duration: 0.4)) {
                                instructionsPaneOffset = UIScreen.main.bounds.height 
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                showGameComponents = true
                                restartGame() 
                            }
                        }, label: {
                            Text("Let's go!")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.white)
                                .frame(width: 150)
                                .padding(.all, 10)
                                .background(Color(red: 0.65, green: 0.35, blue: 0))
                                .cornerRadius(10)
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                                .foregroundColor(.clear)
                        )
                    }
                }
                .offset(y: instructionsPaneOffset)
                .onAppear{
                    withAnimation(.linear(duration: 0.4)) {
                        instructionsPaneOffset = 0
                    }
                }
            }
            
        }
    }
    
    func initiateCoinScheduling() {
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            self.coinRotation = 360
        }
        
        withAnimation(.linear(duration: coinFallDuration).repeatForever(autoreverses: false)) {
            self.coinYOffset = fallDistance
        }
        
        self.coinScheduler = Timer.scheduledTimer(withTimeInterval: coinFallDuration, repeats: true) { _ in
            let isCorrectColorCaught = self.checkIfScored(self.currentCoinColor)
            
            //change score based on color catch
            if isCorrectColorCaught {
                self.gameScore += 1
                withAnimation(.linear(duration: 0.2)) {
                    self.scoreIndicatorColor = Color(red: 0, green: 0.5, blue: 0)
                }
            } else {
                self.gameScore -= 1
                withAnimation(.linear(duration: 0.2)) {
                    self.scoreIndicatorColor = Color(red: 1, green: 0, blue: 0)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                withAnimation(.easeIn(duration: 0.2)) {
                    self.scoreIndicatorColor = Color.black
                }
            }
            
            withAnimation(.easeIn(duration: 0.3)) {
                self.currentCoinColor = self.colorArray.randomElement()!
            }
            
        }
    }
    
    func changeTrayRotationDirection() {
        self.stopRecordingRotationAngle()
        withAnimation(.linear(duration: 0)) {
            self.updatedRotationAngle = self.currentRotationAngle
        }
        
        let fullAngle: CGFloat
        if self.isRotatingClockwise {
            fullAngle = self.updatedRotationAngle - 360
        } else {
            fullAngle = self.updatedRotationAngle + 360
        }
        
        withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
            self.updatedRotationAngle = fullAngle
        }
        self.isRotatingClockwise.toggle()
        self.recordRotationAngle(self.isRotatingClockwise)
    }
    
    //keeps a record of the angle in rotation through a timer
    func recordRotationAngle(_ isClockwise: Bool) {
        //increment angle every 0.01 seconds
        trayAngleScheduler = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if isClockwise {
                currentRotationAngle += 1.2  //360 deg in 3s -> 1.2 deg in 0.01s
            } else {
                currentRotationAngle -= 1.2
            }
        }
        trayAngleScheduler?.fire()
    } 
    
    
    func stopRecordingRotationAngle() {
        self.trayAngleScheduler?.invalidate()
        self.trayAngleScheduler = nil
    }
    
    
    //check if correct color is caught in the tray
    func checkIfScored(_ currentCoinColor: Color) -> Bool {
        var factor = Int(self.currentRotationAngle/360)
        if self.currentRotationAngle < 0 && factor == 0 {
            factor = -1  //convert angles between -360 and 0 to positive
        }
        
        //convert angle to be in the range 0-360
        let currentNormalisedAngle: CGFloat = self.currentRotationAngle - Double(factor*360)
        
        var currentCoinColorPosition = self.colorAngleDict[currentCoinColor]! + currentNormalisedAngle
        if currentCoinColorPosition > 360 {
            currentCoinColorPosition -= 360
        }
        
        //check if coin is caught in the -40 to 40 degree range
        if (currentCoinColorPosition >= 0 && currentCoinColorPosition <= 40) || (currentCoinColorPosition >= 320 && currentCoinColorPosition <= 360) {
            return true
        } else {
            return false
        }
    }
    
    func restartGame() {
        withAnimation(.linear(duration: 0)) {
            coinRotation = 0
            coinYOffset = 0
            updatedRotationAngle = 0
            gameScore = 0
        }
        
        scoreIndicatorColor = Color.black
        isRotatingClockwise = true
        coinScheduler?.invalidate()
        coinScheduler = nil
        currentRotationAngle = 0
        initiateCoinScheduling()
        stopRecordingRotationAngle()
        recordRotationAngle(isRotatingClockwise)
        withAnimation(.linear(duration: rotationDuration).repeatForever(autoreverses: false)) {
            updatedRotationAngle = 360
        }
    }
}


struct ColorCatchView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCatchView()
    }
} 
