import AVFoundation
import CoreImage
import Vision

class CameraFeedHandler: NSObject, ObservableObject {
    @Published var captureFrame: CGImage?
    let captureSession = AVCaptureSession()
    private var accessGiven: Bool = false
    private let captureQueue = DispatchQueue(label: "avCaptureQueue")
    private let evalContext = CIContext()
    
    private var frameCount = 0
    private let handPoseDetectionInterval = 5  //detect hand poses after every 5 frames
    
    private let handPoseIdentifier = HandPoseIdentifier()
    private var handPoseRequest: VNDetectHumanHandPoseRequest?
    private var fistPalmDetectionModel: FistPalmHandPoseClassifier?
    private var rockThreeDetectionModel: RockThreeHandPoseClassifier?
    
    
    public override init () {
        super.init()
        self.isAccessGiven()
        self.runCaptureQueue()
        
        self.handPoseRequest = handPoseIdentifier.getHandPoseRequest()
        self.fistPalmDetectionModel = handPoseIdentifier.fistPalmDetectionModel
        self.rockThreeDetectionModel = handPoseIdentifier.rockThreeDetectionModel
    }
    
    
    //check for access to device camera
    private func isAccessGiven () {
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
    
    
     func runCaptureQueue() {
        self.captureQueue.sync { [unowned self] in 
            self.initialiseCaptureSession()
            self.captureSession.startRunning()}
    }
    
    func stopCaptureSession() {
        print("stopped")
        self.captureSession.stopRunning()
        captureSession.inputs.forEach{captureSession.removeInput($0)}
        captureSession.outputs.forEach{captureSession.removeOutput($0)}
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
        if captureSession.isRunning {
            if let capturedCGImage = getSampleBufferImage(initSampleBuffer: sampleBuffer) {        
                DispatchQueue.main.async { [unowned self] in
                    self.captureFrame = capturedCGImage
                }
                
            } else {
                return
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
                            
                            if let handPoseKeypointsMultiArray = try? handPoseObservation.keypointsMultiArray() {
                                
                                //detections for fist/palm pose
                                let fpPrediction = try fistPalmDetectionModel!.prediction(poses: handPoseKeypointsMultiArray)
                                let fpConfidenceScore = fpPrediction.labelProbabilities[fpPrediction.label]!
                                
                                //detections for rock/three pose
                                let rtPrediction = try rockThreeDetectionModel!.prediction(poses: handPoseKeypointsMultiArray)
                                let rtConfidenceScore = rtPrediction.labelProbabilities[rtPrediction.label]!
                                
                                DispatchQueue.main.async {
                                    if fpConfidenceScore > 0.9 {
                                        DodgeObsScene.detectedHandPose = fpPrediction.label
                                    } 
                                    
                                    if rtConfidenceScore > 0.9 {
                                        ColorCatchView.detectedHandPose = rtPrediction.label
                                    }
                                }
                            }
                        }
                    }
                    
                } catch { 
                    print("Hand Pose Detection Failed: \(error)") 
              } 
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

