//import AVFoundation
//import CoreImage
//import Vision
//
//class CameraFeedHandler: NSObject, ObservableObject {
//    @Published var captureFrame: CGImage?
//    private var accessGiven: Bool = false
//    private let captureSession = AVCaptureSession()
//    private let captureQueue = DispatchQueue(label: "avCaptureQueue")
//    private let evalContext = CIContext()
//    
//    private var frameCount = 0
//    private let handPoseDetectionInterval = 5  //detect hand poses after every 5 frames
//    
//    private let handPoseIdentifier = HandPoseIdentifier()
//    private var handPoseRequest: VNDetectHumanHandPoseRequest?
//    private var handPoseDetectionModel: FistPalmHandPoseClassifier?
//    
//    public override init () {
//        super.init()
//        self.isAccessGiven()
//        self.runCaptureQueue()
//        
//        self.handPoseRequest = handPoseIdentifier.getHandPoseRequest()
//        self.handPoseDetectionModel = handPoseIdentifier.getModel()
//    }
//    
//    //check for access to device camera
//    private func isAccessGiven () {
////        print ("Entering isAccessGiven()")
//        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
//            self.accessGiven = true
//        }
//        else if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (userChoice: Bool) in 
//                self.accessGiven = userChoice
//                self.runCaptureQueue()
//            })
//        } 
//        else {
//            self.accessGiven = false
//        }
//    }
//    
//    
//    private func runCaptureQueue() {
////        print ("before capture queue")
//        self.captureQueue.sync { [unowned self] in 
//            self.initialiseCaptureSession()
//            self.captureSession.startRunning()}
////        print ("inside capture queue")
//    }
//    
//    
//    private func initialiseCaptureSession() {
//        let outputStream = AVCaptureVideoDataOutput()
//         
//        if self.accessGiven {
//            //setting iPad Pro front camera as capture device
//            if let cameraDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) {
//                do {
//                    let inputStream = try AVCaptureDeviceInput(device: cameraDevice) 
//                    if captureSession.canAddInput(inputStream) { //check if inputStream isn't already added to a session
//                        captureSession.addInput(inputStream)
//                    }
//                } catch {
//                    return
//                }
//
//                outputStream.setSampleBufferDelegate(self, queue: DispatchQueue(label: "bufferQueue"))
//                captureSession.addOutput(outputStream)
//                
//                //forced unwrapping
//                let rotationAngle: CGFloat = 90 //portrait orientation
//                if outputStream.connection(with: .video)!.isVideoRotationAngleSupported(rotationAngle) {
//                    outputStream.connection(with: .video)!.videoRotationAngle = rotationAngle 
//                }
//            }
//        } 
//    }
//}
//
//
//extension CameraFeedHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
//    
//    func captureOutput (_ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
////        print ("Entering captureOutput()")
//        if let capturedCGImage = getSampleBufferImage(initSampleBuffer: sampleBuffer) {    
//            DispatchQueue.main.async { [unowned self] in
//                self.captureFrame = capturedCGImage
//            }
//        }
//        
//        //make observations for detecting hand poses
//        let handPoseRequestHandler = VNImageRequestHandler( 
//                                        cmSampleBuffer: sampleBuffer, 
//                                        orientation: .upMirrored, 
//                                        options: [:] 
//                                     )
//        
//        frameCount += 1
//        
//        if frameCount % handPoseDetectionInterval == 0 {
//            do { 
//                try handPoseRequestHandler.perform([handPoseRequest!]) 
//                
//                if let obtainedResults = handPoseRequest!.results {
//                    if !obtainedResults.isEmpty {
//                        
//                        let handPoseObservation = obtainedResults[0]
//                        
//                        if let handPoseKeypointsMultiArray = try? handPoseObservation.keypointsMultiArray() {
//                            let handPosePrediction = try handPoseDetectionModel!.prediction(poses: handPoseKeypointsMultiArray)
//                            let confidenceScore = handPosePrediction.labelProbabilities[handPosePrediction.label]!
//                            
//                            if confidenceScore > 0.9 {
//                                
//                                DispatchQueue.main.async {
//                                    ColorCatchView.detectedHandPose = handPosePrediction.label
//                                    DodgeObsScene.detectedHandPose = handPosePrediction.label
//                                    print("Detect1: \(ColorCatchView.detectedHandPose)")
//                                }
//                            } else {
//                                print("Hand pose not detected")
//                            }
//                        }
//                    }
//                }
//                
//            } catch { 
//                print("Hand Pose Detection Failed: \(error)") 
//          } 
//        }
//    }
//    
//    //convert image from sample buffer into CGImage
//    private func getSampleBufferImage(initSampleBuffer: CMSampleBuffer) -> CGImage? {
//        if let imageBuffer = CMSampleBufferGetImageBuffer(initSampleBuffer) {
//            let capturedCIImage = CIImage(cvPixelBuffer: imageBuffer)
//            if let capturedCGImage = evalContext.createCGImage(capturedCIImage, from: capturedCIImage.extent) {
//                return capturedCGImage
//            } 
//        }
//        return nil 
//    }
//} 
//
