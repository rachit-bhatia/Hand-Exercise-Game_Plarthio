import SwiftUI

class ColorCatchHandler {
    private var currentRotationAngle: Double = 0
    private var trayAngleScheduler: Timer?
    
    private let colorArray: [Color]
    private let colorAngleDict: [Color:Double]
    
    init(initColorArray: [Color], initColorAngleDict: [Color:Double]) {
        self.colorArray = initColorArray
        self.colorAngleDict = initColorAngleDict
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
}

