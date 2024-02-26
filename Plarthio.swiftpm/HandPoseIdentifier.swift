import Vision

class HandPoseIdentifier {
    private let handPoseRequest = VNDetectHumanHandPoseRequest()
    let fistPalmDetectionModel = FistPalmHandPoseClassifier()
    let rockThreeDetectionModel = RockThreeHandPoseClassifier()

    init () {
        self.handPoseRequest.maximumHandCount = 1
    }
    
    func getHandPoseRequest() -> VNDetectHumanHandPoseRequest{
        return self.handPoseRequest
    }
}
