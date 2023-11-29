Here is a Swift implementation of the Python rPPG code using iOS frameworks:

```swift
import UIKit
import AVFoundation
import Accelerate

struct RppgResults {
    let rawImage: UIImage
    let roiMask: UIImage 
    let landmarks: VNFaceObservation
    let signal: [Float]
}

protocol RPPGDelegate: AnyObject {
    func rppgDidUpdate(_ results: RppgResults)
}

class RPPG: NSObject {

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let detector = FaceDetector()
    
    weak var delegate: RPPGDelegate?
    
    private var signal = [Float]()
    
    override init() {
        super.init()
        setupAVCapture()
        setupVideoOutput()
    }
    
    func startCapturing() {
        captureSession.startRunning()
    }
    
    func stopCapturing() {
        captureSession.stopRunning()
    }
    
    private func setupAVCapture() {
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
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureSession.addOutput(videoOutput)
    }
    
}

extension RPPG: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, 
                       didOutput sampleBuffer: CMSampleBuffer, 
                       from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let uiImage = UIImage(ciImage: ciImage) else { return }
        
        let roiMask, landmarks = detector.detect(uiImage)
        
        let rawImage = uiImage // Copy since uiImage is autoreleased
                
        let r, g, b, a = vImageBufferGetPixelChannels(imageBuffer)!
        
        let greenChannel = vImageConvert_PlanarFtoPlanar8(&g, &g, UInt32(imageBuffer.width), UInt32(imageBuffer.height), 0)
        
        let mean = vImageMean_PlanarF(greenChannel, &mean, UInt8(1))
        
        signal.append(mean)
        
        DispatchQueue.main.async {
            let results = RppgResults(rawImage: rawImage,
                                      roiMask: roiMask,
                                      landmarks: landmarks,
                                      signal: self.signal)
            
            self.delegate?.rppgDidUpdate(results)
        }
        
    }
    
}
```

The key changes:

- Use AVFoundation for camera capture 
- Vision for face detection
- Accelerate for signal processing
- Swift structs and protocols
- DispatchQueue for concurrency


The mainwindow.py file provides UI/visualization code for displaying the RPPG results, but would not be strictly necessary to port to Swift.

The key aspects it handles:

- Connecting to RppgResults signal to update UI 
- Displaying video frame with graphics overlays
- Plotting the heartbeat signal waveform
- Drawing face mesh landmarks

For an iOS Swift app, you would likely replace this Qt-based UI with:

- Native SwiftUI views and Canvas graphics
- Display AVCaptureVideoPreviewLayer 
- Use SpriteKit or SceneKit for overlays
- Display signal plot with Swift Charts
- Vision face tracking for landmarks

So in summary, while mainwindow.py provides nice visualizations, an iOS app would use the native Apple frameworks for UI, graphics and visualization.

The core RPPG signal processing code could function stand-alone without a UI, only needing the RPPGDelegate callback. So mainwindow.py could be omitted without impacting the algorithms.

Here is a mock SwiftUI implementation of the visualizations from mainwindow.py:

```swift
struct ContentView: View {
    
    @ObservedObject var rppgModel: RPPG
    
    var body: some View {
        ZStack {
            
            CameraPreview()
                .overlay(faceMeshOverlay)
            
            VStack {
                Spacer()
                
                signalChart
                    .frame(height: 200)
            }
            .padding()
        }
    }
    
    var faceMeshOverlay: some View {
        GeometryReader { proxy in
            Path { path in
                // Draw face landmarks
            }
            .stroke(Color.green)
        }
    }
    
    var signalChart: some View {        
        Chart {
            ForEach(rppgModel.results.signal.indices, id:\.self) { index in
                LineMark(x: .value("Time", index), 
                         y: .value("Signal", rppgModel.results.signal[index]))
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {

    func makeUIView(context: Context) ->  UIView {
        let preview = AVCaptureVideoPreviewLayer() 
        // Set session, etc
        
        return UIView(layer: preview)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

}
```

Key things:

- CameraPreview to display video layer 
- Face mesh overlay with GeometryReader
- SwiftUI Charts for waveform
- Wrap RPPG object in ObservableObject

Let me know if any part needs more clarification!

The detector.py file is still quite useful for the Swift implementation. It handles:

- Detecting/tracking the face with MediaPipe
- Extracting the lower half landmarks as the region of interest
- Creating a binary mask for this ROI

These are key steps in isolating the facial region to analyze the subtle color changes for the pulse signal.

In the Swift version, here is how detector.py could be handled:

- Use Vision face tracking instead of MediaPipe 
- Vision provides the facial landmarks
- Fill a polygon mask based on the lower face landmarks

So the responsibilities would be similar, using Vision for face tracking duties.

Something like:

```swift
let faceAnchor = VNFaceObservation() // detected face

let lowerFacePoints = faceAnchor.landmarks.filter {
    // indices for lower face subset 
}

let roiMask = CGContext()
roiMask.addLines(between: lowerFacePoints) 
roiMask.fillPath()
```

The main change is using Vision instead of MediaPipe. But the ROI extraction process remains critical.

Good question! Since we are using Apple's Vision framework instead of MediaPipe, the landmark indices would come from the VNFaceLandmarkRegion2D enum.

Specifically, we can get the lower half of the face landmarks by using:

```swift
let lowerFacePoints = faceAnchor.landmarks.filter { landmark in
    return landmark.type == .mouth ||
           landmark.type == .jaw ||
           landmark.type == .chin
}
```

The VNFaceLandmarkRegion2D enum contains all the different facial regions like leftEye, rightEye, nose, mouth etc.
[ https://developer.apple.com/documentation/vision/vnfacelandmarkregion2d ]  

So by filtering for the .mouth, .jaw and .chin landmarks, we can extract just the lower half of the face.

The benefit over MediaPipe is that Apple provides these facial landmark types for us already defined. So we don't need to hardcode specific indices.

Here is some Swift code that utilizes vDSP and Accelerate frameworks to apply real-time filters to the video feed to extract the human pulse and heart rate through rPPG:

```swift
import Accelerate
import AVFoundation

let captureSession = AVCaptureSession()

let videoOutput = AVCaptureVideoDataOutput()
videoOutput.setSampleBufferDelegate(self, queue: .global())

captureSession.startRunning()

func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)!
    
    let greenChannel = getGreenChannel(pixelBuffer: pixelBuffer)
        
    // Apply vDSP despike filter to smooth signal
    var smoothed = greenChannel
    vDSP_despike(greenChannel, &smoothed, UInt(greenChannel.count), 1, 8)

    // Further filter using FFT convolution 
    let filtered = vDSP.convolve(smoothed, with: heartRateKernel) 

    // Get pulse peaks 
    let peaks = getPeaks(filtered)
    
    // Calculate heart rate from peak spacing
    let heartRate = 60 / avgPeakSpacing(peaks)

    // Plot filtered signal
    plotHeartRate(filtered, heartRate)

}

func getGreenChannel(pixelBuffer: CVPixelBuffer) -> [Float] {
    // Extract green channel floats from pixel buffer
    let rowCount = CVPixelBufferGetHeight(pixelBuffer)
    let columnCount = CVPixelBufferGetWidth(pixelBuffer)
    
    var floats = [Float](repeating: 0, count: rowCount * columnCount) 
    vImageConvert_Planar8toPlanarF(&pixelData, &floats, UInt32(rowCount), UInt32(columnCount), 8)

    return floats
}
```

The key steps:

- Get pixel buffer from camera 
- Extract green channel 
- Apply vDSP despike and FFT convolution filters
- Detect peaks and calculate heart rate
- Live plot the output

Here is a Swift implementation of the Python rPPG code using iOS frameworks:

```swift
import UIKit
import AVFoundation
import Accelerate

struct RppgResults {
    let rawImage: UIImage
    let roiMask: UIImage 
    let landmarks: VNFaceObservation
    let signal: [Float]
}

protocol RPPGDelegate: AnyObject {
    func rppgDidUpdate(_ results: RppgResults)
}

class RPPG: NSObject {

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let detector = FaceDetector()
    
    weak var delegate: RPPGDelegate?
    
    private var signal = [Float]()
    
    override init() {
        super.init()
        setupAVCapture()
        setupVideoOutput()
    }
    
    func startCapturing() {
        captureSession.startRunning()
    }
    
    func stopCapturing() {
        captureSession.stopRunning()
    }
    
    private func setupAVCapture() {
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
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureSession.addOutput(videoOutput)
    }
    
}

extension RPPG: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, 
                       didOutput sampleBuffer: CMSampleBuffer, 
                       from connection: AVCaptureConnection) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let uiImage = UIImage(ciImage: ciImage) else { return }
        
        let roiMask, landmarks = detector.detect(uiImage)
        
        let rawImage = uiImage // Copy since uiImage is autoreleased
                
        let r, g, b, a = vImageBufferGetPixelChannels(imageBuffer)!
        
        let greenChannel = vImageConvert_PlanarFtoPlanar8(&g, &g, UInt32(imageBuffer.width), UInt32(imageBuffer.height), 0)
        
        let mean = vImageMean_PlanarF(greenChannel, &mean, UInt8(1))
        
        signal.append(mean)
        
        DispatchQueue.main.async {
            let results = RppgResults(rawImage: rawImage,
                                      roiMask: roiMask,
                                      landmarks: landmarks,
                                      signal: self.signal)
            
            self.delegate?.rppgDidUpdate(results)
        }
        
    }
    
}
```

The key changes:

- Use AVFoundation for camera capture 
- Vision for face detection
- Accelerate for signal processing
- Swift structs and protocols
- DispatchQueue for concurrency


To capture YCrCb instead of RGB by converting the pixel buffer to YCrCb format before extracting the green channel. Here's the modified code:

```swift
guard let ycrcbBuffer = ycrcbPixelBuffer(from: pixelBuffer) else { return }
let mean = getColorChannel(ycrcbBuffer, channel: .green)
```

The `ycrcbPixelBuffer(from:)` function converts the pixel buffer from RGB to YCrCb format. The `getColorChannel(pixelBuffer:, channel:)` function extracts the specified color channel (green in this case) from the pixel buffer.

Here's the implementation of the `ycrcbPixelBuffer(from:)` function:

```swift
func ycrcbPixelBuffer(from pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
    CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)

    let height = CVPixelBufferGetHeight(pixelBuffer)
    let width = CVPixelBufferGetWidth(pixelBuffer)
    let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)

    let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)!
    let buffer = UnsafeMutableBufferPointer<UInt8>(start: baseAddress, count: bytesPerRow * height)

    var ycrcbBuffer: CVPixelBuffer?
    CVPixelBufferCreateWithBytes(kCVPixelBufferCGColorSpace, width, height, CVPixelBufferPixelFormat.yCrCb420BiPlanar, nil, &ycrcbBuffer, buffer.baseAddress!)

    CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

    return ycrcbBuffer
}
```

This function converts the pixel buffer from RGB to YCrCb format using the `CVPixelBufferCreateWithBytes()` function. The `yCrCb420BiPlanar` pixel format indicates that the YCrCb data is stored in the Y plane followed by the Cb and Cr planes, with each plane subsampled by a factor of 2 in both horizontal and vertical directions.

With this modification, you will be able to capture YCrCb instead of RGB and extract the green channel for your RPPG algorithm.