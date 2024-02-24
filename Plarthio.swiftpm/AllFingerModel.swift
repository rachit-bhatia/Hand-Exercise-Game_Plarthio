//
// AllFingerModel.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class AllFingerModelInput : MLFeatureProvider {
    
    /// wristx as double value
    var wristx: Double
    
    /// wristy as double value
    var wristy: Double
    
    /// thumbCMCx as double value
    var thumbCMCx: Double
    
    /// thumbCMCy as double value
    var thumbCMCy: Double
    
    /// thumbMPx as double value
    var thumbMPx: Double
    
    /// thumbMPy as double value
    var thumbMPy: Double
    
    /// thumbIPx as double value
    var thumbIPx: Double
    
    /// thumbIPy as double value
    var thumbIPy: Double
    
    /// thumbTipx as double value
    var thumbTipx: Double
    
    /// thumbTipy as double value
    var thumbTipy: Double
    
    /// indexMCPx as double value
    var indexMCPx: Double
    
    /// indexMCPy as double value
    var indexMCPy: Double
    
    /// indexPIPx as double value
    var indexPIPx: Double
    
    /// indexPIPy as double value
    var indexPIPy: Double
    
    /// indexDIPx as double value
    var indexDIPx: Double
    
    /// indexDIPy as double value
    var indexDIPy: Double
    
    /// indexTipx as double value
    var indexTipx: Double
    
    /// indexTipy as double value
    var indexTipy: Double
    
    /// middleMCPx as double value
    var middleMCPx: Double
    
    /// middleMCPy as double value
    var middleMCPy: Double
    
    /// middlePIPx as double value
    var middlePIPx: Double
    
    /// middlePIPy as double value
    var middlePIPy: Double
    
    /// middleDIPx as double value
    var middleDIPx: Double
    
    /// middleDIPy as double value
    var middleDIPy: Double
    
    /// middleTipx as double value
    var middleTipx: Double
    
    /// middleTipy as double value
    var middleTipy: Double
    
    /// ringMCPx as double value
    var ringMCPx: Double
    
    /// ringMCPy as double value
    var ringMCPy: Double
    
    /// ringPIPx as double value
    var ringPIPx: Double
    
    /// ringPIPy as double value
    var ringPIPy: Double
    
    /// ringDIPx as double value
    var ringDIPx: Double
    
    /// ringDIPy as double value
    var ringDIPy: Double
    
    /// ringTipx as double value
    var ringTipx: Double
    
    /// ringTipy as double value
    var ringTipy: Double
    
    /// littleMCPx as double value
    var littleMCPx: Double
    
    /// littleMCPy as double value
    var littleMCPy: Double
    
    /// littlePIPx as double value
    var littlePIPx: Double
    
    /// littlePIPy as double value
    var littlePIPy: Double
    
    /// littleDIPx as double value
    var littleDIPx: Double
    
    /// littleDIPy as double value
    var littleDIPy: Double
    
    /// littleTipx as double value
    var littleTipx: Double
    
    /// littleTipy as double value
    var littleTipy: Double
    
    var featureNames: Set<String> {
        get {
            return ["wristx", "wristy", "thumbCMCx", "thumbCMCy", "thumbMPx", "thumbMPy", "thumbIPx", "thumbIPy", "thumbTipx", "thumbTipy", "indexMCPx", "indexMCPy", "indexPIPx", "indexPIPy", "indexDIPx", "indexDIPy", "indexTipx", "indexTipy", "middleMCPx", "middleMCPy", "middlePIPx", "middlePIPy", "middleDIPx", "middleDIPy", "middleTipx", "middleTipy", "ringMCPx", "ringMCPy", "ringPIPx", "ringPIPy", "ringDIPx", "ringDIPy", "ringTipx", "ringTipy", "littleMCPx", "littleMCPy", "littlePIPx", "littlePIPy", "littleDIPx", "littleDIPy", "littleTipx", "littleTipy"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "wristx") {
            return MLFeatureValue(double: wristx)
        }
        if (featureName == "wristy") {
            return MLFeatureValue(double: wristy)
        }
        if (featureName == "thumbCMCx") {
            return MLFeatureValue(double: thumbCMCx)
        }
        if (featureName == "thumbCMCy") {
            return MLFeatureValue(double: thumbCMCy)
        }
        if (featureName == "thumbMPx") {
            return MLFeatureValue(double: thumbMPx)
        }
        if (featureName == "thumbMPy") {
            return MLFeatureValue(double: thumbMPy)
        }
        if (featureName == "thumbIPx") {
            return MLFeatureValue(double: thumbIPx)
        }
        if (featureName == "thumbIPy") {
            return MLFeatureValue(double: thumbIPy)
        }
        if (featureName == "thumbTipx") {
            return MLFeatureValue(double: thumbTipx)
        }
        if (featureName == "thumbTipy") {
            return MLFeatureValue(double: thumbTipy)
        }
        if (featureName == "indexMCPx") {
            return MLFeatureValue(double: indexMCPx)
        }
        if (featureName == "indexMCPy") {
            return MLFeatureValue(double: indexMCPy)
        }
        if (featureName == "indexPIPx") {
            return MLFeatureValue(double: indexPIPx)
        }
        if (featureName == "indexPIPy") {
            return MLFeatureValue(double: indexPIPy)
        }
        if (featureName == "indexDIPx") {
            return MLFeatureValue(double: indexDIPx)
        }
        if (featureName == "indexDIPy") {
            return MLFeatureValue(double: indexDIPy)
        }
        if (featureName == "indexTipx") {
            return MLFeatureValue(double: indexTipx)
        }
        if (featureName == "indexTipy") {
            return MLFeatureValue(double: indexTipy)
        }
        if (featureName == "middleMCPx") {
            return MLFeatureValue(double: middleMCPx)
        }
        if (featureName == "middleMCPy") {
            return MLFeatureValue(double: middleMCPy)
        }
        if (featureName == "middlePIPx") {
            return MLFeatureValue(double: middlePIPx)
        }
        if (featureName == "middlePIPy") {
            return MLFeatureValue(double: middlePIPy)
        }
        if (featureName == "middleDIPx") {
            return MLFeatureValue(double: middleDIPx)
        }
        if (featureName == "middleDIPy") {
            return MLFeatureValue(double: middleDIPy)
        }
        if (featureName == "middleTipx") {
            return MLFeatureValue(double: middleTipx)
        }
        if (featureName == "middleTipy") {
            return MLFeatureValue(double: middleTipy)
        }
        if (featureName == "ringMCPx") {
            return MLFeatureValue(double: ringMCPx)
        }
        if (featureName == "ringMCPy") {
            return MLFeatureValue(double: ringMCPy)
        }
        if (featureName == "ringPIPx") {
            return MLFeatureValue(double: ringPIPx)
        }
        if (featureName == "ringPIPy") {
            return MLFeatureValue(double: ringPIPy)
        }
        if (featureName == "ringDIPx") {
            return MLFeatureValue(double: ringDIPx)
        }
        if (featureName == "ringDIPy") {
            return MLFeatureValue(double: ringDIPy)
        }
        if (featureName == "ringTipx") {
            return MLFeatureValue(double: ringTipx)
        }
        if (featureName == "ringTipy") {
            return MLFeatureValue(double: ringTipy)
        }
        if (featureName == "littleMCPx") {
            return MLFeatureValue(double: littleMCPx)
        }
        if (featureName == "littleMCPy") {
            return MLFeatureValue(double: littleMCPy)
        }
        if (featureName == "littlePIPx") {
            return MLFeatureValue(double: littlePIPx)
        }
        if (featureName == "littlePIPy") {
            return MLFeatureValue(double: littlePIPy)
        }
        if (featureName == "littleDIPx") {
            return MLFeatureValue(double: littleDIPx)
        }
        if (featureName == "littleDIPy") {
            return MLFeatureValue(double: littleDIPy)
        }
        if (featureName == "littleTipx") {
            return MLFeatureValue(double: littleTipx)
        }
        if (featureName == "littleTipy") {
            return MLFeatureValue(double: littleTipy)
        }
        return nil
    }
    
    init(wristx: Double, wristy: Double, thumbCMCx: Double, thumbCMCy: Double, thumbMPx: Double, thumbMPy: Double, thumbIPx: Double, thumbIPy: Double, thumbTipx: Double, thumbTipy: Double, indexMCPx: Double, indexMCPy: Double, indexPIPx: Double, indexPIPy: Double, indexDIPx: Double, indexDIPy: Double, indexTipx: Double, indexTipy: Double, middleMCPx: Double, middleMCPy: Double, middlePIPx: Double, middlePIPy: Double, middleDIPx: Double, middleDIPy: Double, middleTipx: Double, middleTipy: Double, ringMCPx: Double, ringMCPy: Double, ringPIPx: Double, ringPIPy: Double, ringDIPx: Double, ringDIPy: Double, ringTipx: Double, ringTipy: Double, littleMCPx: Double, littleMCPy: Double, littlePIPx: Double, littlePIPy: Double, littleDIPx: Double, littleDIPy: Double, littleTipx: Double, littleTipy: Double) {
        self.wristx = wristx
        self.wristy = wristy
        self.thumbCMCx = thumbCMCx
        self.thumbCMCy = thumbCMCy
        self.thumbMPx = thumbMPx
        self.thumbMPy = thumbMPy
        self.thumbIPx = thumbIPx
        self.thumbIPy = thumbIPy
        self.thumbTipx = thumbTipx
        self.thumbTipy = thumbTipy
        self.indexMCPx = indexMCPx
        self.indexMCPy = indexMCPy
        self.indexPIPx = indexPIPx
        self.indexPIPy = indexPIPy
        self.indexDIPx = indexDIPx
        self.indexDIPy = indexDIPy
        self.indexTipx = indexTipx
        self.indexTipy = indexTipy
        self.middleMCPx = middleMCPx
        self.middleMCPy = middleMCPy
        self.middlePIPx = middlePIPx
        self.middlePIPy = middlePIPy
        self.middleDIPx = middleDIPx
        self.middleDIPy = middleDIPy
        self.middleTipx = middleTipx
        self.middleTipy = middleTipy
        self.ringMCPx = ringMCPx
        self.ringMCPy = ringMCPy
        self.ringPIPx = ringPIPx
        self.ringPIPy = ringPIPy
        self.ringDIPx = ringDIPx
        self.ringDIPy = ringDIPy
        self.ringTipx = ringTipx
        self.ringTipy = ringTipy
        self.littleMCPx = littleMCPx
        self.littleMCPy = littleMCPy
        self.littlePIPx = littlePIPx
        self.littlePIPy = littlePIPy
        self.littleDIPx = littleDIPx
        self.littleDIPy = littleDIPy
        self.littleTipx = littleTipx
        self.littleTipy = littleTipy
    }
    
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class AllFingerModelOutput : MLFeatureProvider {
    
    /// Source provided by CoreML
    private let provider : MLFeatureProvider
    
    /// result as integer value
    var result: Int64 {
        return self.provider.featureValue(for: "result")!.int64Value
    }
    
    /// resultProbability as dictionary of 64-bit integers to doubles
    var resultProbability: [Int64 : Double] {
        return self.provider.featureValue(for: "resultProbability")!.dictionaryValue as! [Int64 : Double]
    }
    
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    init(result: Int64, resultProbability: [Int64 : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["result" : MLFeatureValue(int64: result), "resultProbability" : MLFeatureValue(dictionary: resultProbability as [AnyHashable : NSNumber])])
    }
    
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class AllFingerModel {
    let model: MLModel
    
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let resPath = Bundle(for: self).url(forResource: "AllFingerModel", withExtension: "mlmodel")!
        return try! MLModel.compileModel(at: resPath)
    }
    
    /**
     Construct AllFingerModel instance with an existing MLModel object.
     
     Usually the application does not use this initializer unless it makes a subclass of AllFingerModel.
     Such application may want to use `MLModel(contentsOfURL:configuration:)` and `AllFingerModel.urlOfModelInThisBundle` to create a MLModel object to pass-in.
     
     - parameters:
     - model: MLModel object
     */
    init(model: MLModel) {
        self.model = model
    }
    
    /**
     Construct AllFingerModel instance by automatically loading the model from the app's bundle.
     */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }
    
    /**
     Construct a model with configuration
     
     - parameters:
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct AllFingerModel instance with explicit path to mlmodelc file
     - parameters:
     - modelURL: the file url of the model
     
     - throws: an NSError object that describes the problem
     */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }
    
    /**
     Construct a model with URL of the .mlmodelc directory and configuration
     
     - parameters:
     - modelURL: the file url of the model
     - configuration: the desired model configuration
     
     - throws: an NSError object that describes the problem
     */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }
    
    /**
     Construct AllFingerModel instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<AllFingerModel, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }
    
    /**
     Construct AllFingerModel instance asynchronously with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - configuration: the desired model configuration
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> AllFingerModel {
        return try await self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }
    
    /**
     Construct AllFingerModel instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
     */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<AllFingerModel, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(AllFingerModel(model: model)))
            }
        }
    }
    
    /**
     Construct AllFingerModel instance asynchronously with URL of the .mlmodelc directory with optional configuration.
     
     Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.
     
     - parameters:
     - modelURL: the URL to the model
     - configuration: the desired model configuration
     */
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> AllFingerModel {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return AllFingerModel(model: model)
    }
    
    /**
     Make a prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as AllFingerModelInput
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as AllFingerModelOutput
     */
    func prediction(input: AllFingerModelInput) throws -> AllFingerModelOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }
    
    /**
     Make a prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as AllFingerModelInput
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as AllFingerModelOutput
     */
    func prediction(input: AllFingerModelInput, options: MLPredictionOptions) throws -> AllFingerModelOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return AllFingerModelOutput(features: outFeatures)
    }
    
    /**
     Make an asynchronous prediction using the structured interface
     
     - parameters:
     - input: the input to the prediction as AllFingerModelInput
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as AllFingerModelOutput
     */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func prediction(input: AllFingerModelInput, options: MLPredictionOptions = MLPredictionOptions()) async throws -> AllFingerModelOutput {
        let outFeatures = try await model.prediction(from: input, options:options)
        return AllFingerModelOutput(features: outFeatures)
    }
    
    /**
     Make a prediction using the convenience interface
     
     - parameters:
     - wristx as double value
     - wristy as double value
     - thumbCMCx as double value
     - thumbCMCy as double value
     - thumbMPx as double value
     - thumbMPy as double value
     - thumbIPx as double value
     - thumbIPy as double value
     - thumbTipx as double value
     - thumbTipy as double value
     - indexMCPx as double value
     - indexMCPy as double value
     - indexPIPx as double value
     - indexPIPy as double value
     - indexDIPx as double value
     - indexDIPy as double value
     - indexTipx as double value
     - indexTipy as double value
     - middleMCPx as double value
     - middleMCPy as double value
     - middlePIPx as double value
     - middlePIPy as double value
     - middleDIPx as double value
     - middleDIPy as double value
     - middleTipx as double value
     - middleTipy as double value
     - ringMCPx as double value
     - ringMCPy as double value
     - ringPIPx as double value
     - ringPIPy as double value
     - ringDIPx as double value
     - ringDIPy as double value
     - ringTipx as double value
     - ringTipy as double value
     - littleMCPx as double value
     - littleMCPy as double value
     - littlePIPx as double value
     - littlePIPy as double value
     - littleDIPx as double value
     - littleDIPy as double value
     - littleTipx as double value
     - littleTipy as double value
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as AllFingerModelOutput
     */
    func prediction(wristx: Double, wristy: Double, thumbCMCx: Double, thumbCMCy: Double, thumbMPx: Double, thumbMPy: Double, thumbIPx: Double, thumbIPy: Double, thumbTipx: Double, thumbTipy: Double, indexMCPx: Double, indexMCPy: Double, indexPIPx: Double, indexPIPy: Double, indexDIPx: Double, indexDIPy: Double, indexTipx: Double, indexTipy: Double, middleMCPx: Double, middleMCPy: Double, middlePIPx: Double, middlePIPy: Double, middleDIPx: Double, middleDIPy: Double, middleTipx: Double, middleTipy: Double, ringMCPx: Double, ringMCPy: Double, ringPIPx: Double, ringPIPy: Double, ringDIPx: Double, ringDIPy: Double, ringTipx: Double, ringTipy: Double, littleMCPx: Double, littleMCPy: Double, littlePIPx: Double, littlePIPy: Double, littleDIPx: Double, littleDIPy: Double, littleTipx: Double, littleTipy: Double) throws -> AllFingerModelOutput {
        let input_ = AllFingerModelInput(wristx: wristx, wristy: wristy, thumbCMCx: thumbCMCx, thumbCMCy: thumbCMCy, thumbMPx: thumbMPx, thumbMPy: thumbMPy, thumbIPx: thumbIPx, thumbIPy: thumbIPy, thumbTipx: thumbTipx, thumbTipy: thumbTipy, indexMCPx: indexMCPx, indexMCPy: indexMCPy, indexPIPx: indexPIPx, indexPIPy: indexPIPy, indexDIPx: indexDIPx, indexDIPy: indexDIPy, indexTipx: indexTipx, indexTipy: indexTipy, middleMCPx: middleMCPx, middleMCPy: middleMCPy, middlePIPx: middlePIPx, middlePIPy: middlePIPy, middleDIPx: middleDIPx, middleDIPy: middleDIPy, middleTipx: middleTipx, middleTipy: middleTipy, ringMCPx: ringMCPx, ringMCPy: ringMCPy, ringPIPx: ringPIPx, ringPIPy: ringPIPy, ringDIPx: ringDIPx, ringDIPy: ringDIPy, ringTipx: ringTipx, ringTipy: ringTipy, littleMCPx: littleMCPx, littleMCPy: littleMCPy, littlePIPx: littlePIPx, littlePIPy: littlePIPy, littleDIPx: littleDIPx, littleDIPy: littleDIPy, littleTipx: littleTipx, littleTipy: littleTipy)
        return try self.prediction(input: input_)
    }
    
    /**
     Make a batch prediction using the structured interface
     
     - parameters:
     - inputs: the inputs to the prediction as [AllFingerModelInput]
     - options: prediction options 
     
     - throws: an NSError object that describes the problem
     
     - returns: the result of the prediction as [AllFingerModelOutput]
     */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [AllFingerModelInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [AllFingerModelOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [AllFingerModelOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  AllFingerModelOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
