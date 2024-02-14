import SwiftUI

class ColorCatchHandler {
    private var currentRotationAngle: Double = 0
    private var trayAngleScheduler: Timer?
    
    private let colorArray: [Color]
    private let coinFallDuration: Double
    @Binding private var currentCoinColor: Color
    
    init(icolorArray: [Color], icurrentCoinColor: Binding<Color>, icoinFallDuration: Double) {
        colorArray = icolorArray
        _currentCoinColor = icurrentCoinColor
        coinFallDuration = icoinFallDuration
    }
    
    //keeps record of the angle in rotation through a timer
    func recordRotationAngle(_ isClockwise: Bool) {
        //increment angle every 0.01 seconds
        self.trayAngleScheduler = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if isClockwise {
                self.currentRotationAngle += 1.2  //360 deg in 3s -> 1.2 deg in 0.01s
            } else {
                self.currentRotationAngle -= 1.2
            }
        }
        self.trayAngleScheduler?.fire()
    }
    
    //halt the time scheduler so it can be restarted for the opposite direction
    func stopRecordingRotationAngle() {
        self.trayAngleScheduler?.invalidate()
        self.trayAngleScheduler = nil
    }
    
    func getCurrentAngle() -> Double {
        return self.currentRotationAngle
    }
    
    func changeCoinColor() {
        let coinColorScheduler = Timer.scheduledTimer(withTimeInterval: coinFallDuration, repeats: true) { _ in

            self.currentCoinColor = self.colorArray.randomElement()!
            print("Coin Color: \(self.currentCoinColor)")
            print("Random Color: \(self.colorArray.randomElement()!)")
            print("")
        }
        coinColorScheduler.fire()
    }
}

