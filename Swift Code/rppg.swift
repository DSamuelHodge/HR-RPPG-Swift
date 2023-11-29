import UIKit
import AVFoundation
import Accelerate
import Vision
import Foundation

struct RPPGModel {
    var signal: [Double] = []
    var timeIndex: [Int] = []
    var heartRate: Double = 0
    var fps: Double = 0
    var face: VNFaceObservation?

    func calculateMovingWindowSignal() {
        let windowSize = 3

        var movingWindowSignal = [Double]()

        for start in 0..<signal.count - windowSize + 1 {
            let windowData = signal[start..<start+windowSize]
            let windowMean = windowData.reduce(0, +) / Double(windowData.count)
            movingWindowSignal.append(windowMean)
        }

        // Use the moving window signal for further processing or analysis
    }
}

struct RppgResults {
  let rawImage: UIImage
  let roiMask: UIImage
  let face: VNFaceObservation  
  let signal: [Float]
  let heartRate: Double
}

protocol RPPGDelegate: AnyObject {
  func rppgDidUpdate(_ results: RppgResults)  
}

final class RPPG: NSObject {

  private let captureSession = AVCaptureSession()
  
  private lazy var faceDetector = {
    let detector = FaceDetector()
    detector.delegate = self
    return detector
  }()
  
  private let videoOutput = AVCaptureVideoDataOutput()
  
  private(set) var signal = [Float]()
  
  var delegate: RPPGDelegate?
  
  override init() {
    super.init()
    setupSession()
    setupVideoOutput()    
  }

  private func setupSession() {
    
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                               for: .video, 
                                               position: .front) else {
      fatalError("No front camera found")
    }
    
    do {
      let input = try AVCaptureDeviceInput(device: device)
      captureSession.addInput(input)
    } catch {
      print(error) 
    }
    
  }
  
  private func setupVideoOutput() {
    
    videoOutput.alwaysDiscardsLateVideoFrames = true    
    videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]    
    videoOutput.setSampleBufferDelegate(self, queue: .global())
    captureSession.addOutput(videoOutput)    
    
  }
  
  func startCapturing() {
    captureSession.startRunning() 
  }
  
  func stopCapturing() {
    captureSession.stopRunning()
  }
  
}

// MARK: - Video Data Output

extension RPPG: AVCaptureVideoDataOutputSampleBufferDelegate {

  func captureOutput(_ output: AVCaptureOutput, 
                     didOutput sampleBuffer: CMSampleBuffer, 
                     from connection: AVCaptureConnection) {
    
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    let pixelBuffer = imageBuffer
    
    faceDetector.detect(pixelBuffer)
    
  }
  
}

// MARK: - Face Detection Result Handler

extension RPPG: FaceDetectorDelegate {

  func didDetect(faces: [VNFaceObservation]) {
    
    guard let face = faces.first else { return }
    
    let lowerFacePoints = face.landmarks(matching: .mouth
                                                .union(.jaw)
                                                .union(.chin))
  
    let roiMask = getROIMask(from: lowerFacePoints, pixelBuffer: pixelBuffer)
    
    guard let rgbBuffer = rgbPixelBuffer(from: pixelBuffer) else { return }
    
    let mean = getColorChannel(rgbBuffer, channel: .green)
    
    signal.append(mean)
    
    let filteredSignal = filter(signal)  
    
    let heartRate = analyzeHeartRate(filteredSignal)
    
    let results = RppgResults(rawImage: rgbBuffer, 
                              roiMask: roiMask,
                              face: face,
                              signal: filteredSignal,
                              heartRate: heartRate)
    
    delegate?.rppgDidUpdate(results)
    
  }
  
}