import AVFoundation
import CoreImage
import Vision

class CameraFeedHandler: NSObject, ObservableObject {
    @Published var captureFrame: CGImage?
    private var accessGiven: Bool = false
    private let captureSession = AVCaptureSession()
    private let captureQueue = DispatchQueue(label: "avCaptureQueue")
    private let evalContext = CIContext()
    
    private var frameCount = 0
    private let handPoseDetectionInterval = 5  //detect hand poses after every 5 frames
    
    private let handPoseIdentifier = HandPoseIdentifier()
    private var handPoseRequest: VNDetectHumanHandPoseRequest?
    private var handPoseDetectionModel: AllFingerModel?
    
    public override init () {
        super.init()
        self.isAccessGiven()
        self.runCaptureQueue()
        
        self.handPoseRequest = handPoseIdentifier.getHandPoseRequest()
        self.handPoseDetectionModel = handPoseIdentifier.getModel()
    }
    
    //check for access to device camera
    private func isAccessGiven () {
        //        print ("Entering isAccessGiven()")
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            self.accessGiven = true
        }
        else if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (userChoice: Bool) in 
                self.accessGiven = userChoice
                self.runCaptureQueue()
            })
        } 
        else {
            self.accessGiven = false
        }
    }
    
    
    private func runCaptureQueue() {
        //        print ("before capture queue")
        self.captureQueue.sync { [unowned self] in 
            self.initialiseCaptureSession()
            self.captureSession.startRunning()}
        //        print ("inside capture queue")
    }
    
    
    private func initialiseCaptureSession() {
        let outputStream = AVCaptureVideoDataOutput()
        
        if self.accessGiven {
            //setting iPad Pro front camera as capture device
            if let cameraDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) {
                do {
                    let inputStream = try AVCaptureDeviceInput(device: cameraDevice) 
                    if captureSession.canAddInput(inputStream) { //check if inputStream isn't already added to a session
                        captureSession.addInput(inputStream)
                    }
                } catch {
                    return
                }
                
                outputStream.setSampleBufferDelegate(self, queue: DispatchQueue(label: "bufferQueue"))
                captureSession.addOutput(outputStream)
                
                //forced unwrapping
                let rotationAngle: CGFloat = 90 //portrait orientation
                if outputStream.connection(with: .video)!.isVideoRotationAngleSupported(rotationAngle) {
                    outputStream.connection(with: .video)!.videoRotationAngle = rotationAngle 
                }
            }
        } 
    }
}


extension CameraFeedHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput (_ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
        //        print ("Entering captureOutput()")
        if let capturedCGImage = getSampleBufferImage(initSampleBuffer: sampleBuffer) {    
            DispatchQueue.main.async { [unowned self] in
                self.captureFrame = capturedCGImage
            }
        }
        
        //make observations for detecting hand poses
        let handPoseRequestHandler = VNImageRequestHandler( 
            cmSampleBuffer: sampleBuffer, 
            orientation: .upMirrored, 
            options: [:] 
        )
        
        frameCount += 1
        
        if frameCount % handPoseDetectionInterval == 0 {
            do { 
                try handPoseRequestHandler.perform([handPoseRequest!]) 
                
                if let obtainedResults = handPoseRequest!.results {
                    if !obtainedResults.isEmpty {
                        
                        let handPoseObservation = obtainedResults[0]
                        
                        let fingers = try handPoseObservation.recognizedPoints(.all)
                        
                        if let handPoseKeypointsMultiArray = try? handPoseObservation.keypointsMultiArray() {
                            
                            let handPosePrediction = try handPoseDetectionModel!.prediction(wristx:fingers[.wrist]?.x ?? 0,
                                                                                            wristy: fingers[.wrist]?.y ?? 0,
                                                                                            thumbCMCx: fingers[.thumbCMC]?.x ?? 0,
                                                                                            thumbCMCy: fingers[.thumbCMC]?.y ?? 0,
                                                                                            thumbMPx: fingers[.thumbMP]?.x ?? 0,
                                                                                            thumbMPy: fingers[.thumbMP]?.y ?? 0,
                                                                                            thumbIPx: fingers[.thumbIP]?.x ?? 0,
                                                                                            thumbIPy: fingers[.thumbIP]?.y ?? 0,
                                                                                            thumbTipx: fingers[.thumbTip]?.x ?? 0,
                                                                                            thumbTipy: fingers[.thumbTip]?.y ?? 0,
                                                                                            indexMCPx: fingers[.indexMCP]?.x ?? 0,
                                                                                            indexMCPy: fingers[.indexMCP]?.y ?? 0,
                                                                                            indexPIPx: fingers[.indexPIP]?.x ?? 0,
                                                                                            indexPIPy: fingers[.indexPIP]?.y ?? 0,
                                                                                            indexDIPx: fingers[.indexDIP]?.x ?? 0,
                                                                                            indexDIPy: fingers[.indexDIP]?.y ?? 0,
                                                                                            indexTipx: fingers[.indexTip]?.x ?? 0,
                                                                                            indexTipy: fingers[.indexTip]?.y ?? 0,
                                                                                            middleMCPx: fingers[.middleMCP]?.x ?? 0,
                                                                                            middleMCPy: fingers[.middleMCP]?.y ?? 0,
                                                                                            middlePIPx: fingers[.middlePIP]?.x ?? 0,
                                                                                            middlePIPy: fingers[.middlePIP]?.y ?? 0,
                                                                                            middleDIPx: fingers[.middleDIP]?.x ?? 0,
                                                                                            middleDIPy: fingers[.middleDIP]?.y ?? 0,
                                                                                            middleTipx: fingers[.middleTip]?.x ?? 0,
                                                                                            middleTipy: fingers[.middleTip]?.y ?? 0,
                                                                                            ringMCPx: fingers[.ringMCP]?.x ?? 0,
                                                                                            ringMCPy: fingers[.ringMCP]?.y ?? 0,
                                                                                            ringPIPx: fingers[.ringPIP]?.x ?? 0,
                                                                                            ringPIPy: fingers[.ringPIP]?.y ?? 0,
                                                                                            ringDIPx: fingers[.ringDIP]?.x ?? 0,
                                                                                            ringDIPy: fingers[.ringDIP]?.y ?? 0,
                                                                                            ringTipx: fingers[.ringTip]?.x ?? 0,
                                                                                            ringTipy: fingers[.ringTip]?.y ?? 0,
                                                                                            littleMCPx: fingers[.littleMCP]?.x ?? 0,
                                                                                            littleMCPy: fingers[.littleMCP]?.y ?? 0,
                                                                                            littlePIPx: fingers[.littlePIP]?.x ?? 0,
                                                                                            littlePIPy: fingers[.littlePIP]?.y ?? 0,
                                                                                            littleDIPx: fingers[.littleDIP]?.x ?? 0,
                                                                                            littleDIPy: fingers[.littleDIP]?.y ?? 0,
                                                                                            littleTipx: fingers[.littleTip]?.x ?? 0,
                                                                                            littleTipy: fingers[.littleTip]?.y ?? 0)
                            
                            let result = handPosePrediction.result
                            if result == 1 {
                                print ("👍")
                            } else if result == 2 {
                                print ("🖐")
                            } else if result == 3 {
                                print ("👌")
                            } else if result == 5 {
                                print ("👇")
                            } else if result == 6 {
                                print ("👊")
                            } else if result == 8 {
                                print ("🤟")
                            }
                        }
                    }
                }
                
            } catch { 
                print("Hand Pose Detection Failed: \(error)") 
            } 
        }
    }
    
    //convert image from sample buffer into CGImage
    private func getSampleBufferImage(initSampleBuffer: CMSampleBuffer) -> CGImage? {
        if let imageBuffer = CMSampleBufferGetImageBuffer(initSampleBuffer) {
            let capturedCIImage = CIImage(cvPixelBuffer: imageBuffer)
            if let capturedCGImage = evalContext.createCGImage(capturedCIImage, from: capturedCIImage.extent) {
                return capturedCGImage
            } 
        }
        return nil 
    }
} 

