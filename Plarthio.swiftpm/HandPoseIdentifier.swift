import Vision

class HandPoseIdentifier {
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
//    private let handPoseDetectionModel = HandPoseDetectionModel()

    init () {
        self.handPoseRequest.maximumHandCount = 1
    }
    
    func getHandPoseRequest() -> VNDetectHumanHandPoseRequest{
        return self.handPoseRequest
    }
    
//    func getModel() -> HandPoseDetectionModel(){
//        return self.handPoseDetectionModel
//    }
}
