import Vision

class HandPoseIdentifier {
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    private let handPoseDetectionModel = FistPalmHandPoseClassifier()

    init () {
        self.handPoseRequest.maximumHandCount = 1
    }
    
    func getHandPoseRequest() -> VNDetectHumanHandPoseRequest{
        return self.handPoseRequest
    }
    
    func getModel() -> FistPalmHandPoseClassifier {
        return self.handPoseDetectionModel
    }
}
