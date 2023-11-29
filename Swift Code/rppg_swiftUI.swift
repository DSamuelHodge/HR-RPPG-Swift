import SwiftUI
import AVFoundation
import Vision
import Foundation

struct RppgView: View {
    @State private var rppgModel = RPPGModel()

    private var videoCapture: CaptureSession!

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Video preview
                AVFoundationView(session: videoCapture)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                // ROI mask overlay
                if let roiMask = rppgModel.face?.roiMask {
                    Image(uiImage: roiMask)
                        .resizable()
                        .scaledToFit()
                        .opacity(0.5)
                }

                // Facial landmarks
                if let face = rppgModel.face {
                    ForEach(face.landmarks?.allPoints ?? []) { point in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.red)
                            .position(x: point.x, y: point.y)
                    }
                }

                // Waveform plot
                WaveformView(signal: rppgModel.signal)
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.85)

                // Heart rate
                Text("\(rppgModel.heartRate) bpm")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.85)

                // Frequency spectrum
                FrequencySpectrumView(signal: rppgModel.signal)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)

                // UI controls
                HStack {
                    Button("Start") {
                        videoCapture.startRunning()
                    }
                    .disabled(videoCapture.isRunning)

                    Button("Stop") {
                        videoCapture.stopRunning()
                    }
                    .disabled(!videoCapture.isRunning)
                }
                .padding()
                .background(.black.opacity(0.5))
                .foregroundColor(.white)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.15)
            }
        }
        .onAppear {
            videoCapture = CaptureSession()
            videoCapture.delegate = self
            videoCapture.startRunning()
        }
        .onDisappear {
            videoCapture.stopRunning()
        }
    }
}

struct WaveformView: View {
    let signal: [Double]

    var body: some View {
        ZStack {
            // Line graph
            Path { path in
                for (index, value) in signal.enumerated() {
                    let x = Double(index) / Double(signal.count)
                    let y = value * 100
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue)
            .frame(width: 300, height: 100)
        }
    }
}

struct FrequencySpectrumView: View {
    let signal: [Double]

    var body: some View {
        // TODO: Implement frequency spectrum visualization
        Text("Frequency Spectrum")
    }
}

class CaptureSession: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: RppgView?

    private let captureSession = AVCaptureSession()

    private let videoOutput = AVCaptureVideoDataOutput()

    var isRunning: Bool {
        captureSession.isRunning
    }

    func startRunning() {
        captureSession.startRunning()
    }

    func stopRunning() {
        captureSession.stopRunning()
    }

    override init() {
        super.init()

        // Configure the capture session
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                        didOutput sampleBuffer: CMSampleBuffer,
                        from connection: AVCaptureConnection) {
        // Extract the image buffer from the sample buffer
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Convert the image buffer to a UIImage
        guard let uiImage = UIImage(imageBuffer: imageBuffer) else { return }

        // Extract the face and ROI mask from the image
        let faceDetector = FaceDetector()
        let face = faceDetector.detect(uiImage)?.first
        let roiMask = face?.roiMask

        // Update the rPPG model with the extracted data
        guard let rppgView = delegate else { return }
        rppgView.rppgModel.face = face
        rppgView.rppgModel.roiMask = roiMask

        // Extract the PPG signal from the ROI mask
        let signal = extractPPGSignal(roiMask: roiMask)

        // Update the rPPG model with the extracted signal
        rppgView.rppgModel.signal = signal

        // Calculate the heart rate from the PPG signal
        let heartRate = calculateHeartRate(signal: signal)

        // Update the rPPG model with the calculated heart rate
        rppgView.rppgModel.heartRate = heartRate

        // Update the UI on the main thread
        DispatchQueue.main.async {
            rppgView.objectWillChange.send()
        }
    }
}
        
