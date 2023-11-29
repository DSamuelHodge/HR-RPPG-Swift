# HR-RPPG-Swift
Implementation for extracting heart rate from remote photoplethysmography (RPPG) signals using Swift code.

This repository provides a comprehensive implementation for extracting heart rate from remote photoplethysmography (RPPG) signals using Swift code. It utilizes the latest advancements in signal processing and machine learning techniques to accurately estimate heart rate from facial videos captured by smartphones. The code is designed to be efficient and lightweight, making it suitable for real-time applications.

### Key Features:
**Non-invasive heart rate monitoring**: Continuously monitor heart rate without any physical contact using facial videos.
**Real-time heart rate estimation**: Estimate heart rate in real-time, providing immediate feedback on cardiovascular activity.
**Efficient and lightweight**: Optimized code for efficient processing and low memory footprint, suitable for mobile devices.
**Cross-platform compatibility**: Compatible with various iOS devices and operating systems.

### Applications:
**Fitness tracking:** Integrate heart rate monitoring into fitness apps for personalized workout tracking and performance analysis.
**Telemedicine:** Enable remote patient monitoring and cardiovascular health assessment for telehealth applications.
**Wearable devices:** Develop heart rate-based features for wearable devices, such as smartwatches and fitness bands.

### Technical Details:
**Signal processing:** Employ advanced signal processing techniques to extract pulse rate and pulse volume information from RPPG signals.
**Machine learning**: Utilize machine learning models to accurately estimate heart rate from extracted pulse rate and pulse volume features.
**Swift code**: Implement the entire pipeline in Swift, a powerful and versatile programming language for iOS development.

### Contribution Guidelines:
The repository welcomes contributions from developers interested in enhancing the heart rate extraction algorithm and expanding its applications. 

#### Contributions may include:
**Improved signal processing techniques**: Enhance the accuracy and robustness of pulse rate and pulse volume extraction.
**Advanced machine learning models**: Develop and incorporate more sophisticated machine learning models for improved heart rate estimation.
**Integration with existing frameworks**: Integrate the code with popular iOS frameworks for seamless integration into existing applications.


## RPPG

The RPPG class is a lightweight framework for remote photoplethysmography (rPPG) using the front-facing camera. It provides a simple interface for capturing video frames, detecting faces, and extracting heart rate information from the facial region.

### Overview

The RPPG class encapsulates the necessary components for rPPG-based heart rate monitoring:

- **AVCaptureSession:** Manages the capture of video frames from the front-facing camera.

- **FaceDetector:** Detects faces in the captured video frames and provides information about their location and features.

- **rPPG Pipeline:** Extracts rPPG signals from the detected facial region and estimates heart rate based on the extracted signals.

### Usage

To use the RPPG class, follow these steps:

1. Create an instance of the RPPG class.

2. Set the `delegate` property to an object that conforms to the RPPGDelegate protocol.

3. Call the `startCapturing()` method to start capturing video frames.

4. The `delegate` object will receive updates about the detected face and the estimated heart rate through the `rppgDidUpdate(_:)` method.

### Properties

- `signal`: An array of floats representing the raw rPPG signal.

- `delegate`: An optional RPPGDelegate object that receives updates about the detected face and the estimated heart rate.

### Methods

- `startCapturing()`: Starts capturing video frames and processing them for rPPG.

- `stopCapturing()`: Stops capturing video frames.

### Delegate Protocol

The `RPPGDelegate` protocol defines a method that is called when the RPPG class has new results to report:

- `rppgDidUpdate(_:)`: Receives an RppgResults object containing the raw image, ROI mask, detected face, filtered signal, and estimated heart rate.

### RppgResults

The `RppgResults` struct encapsulates the results of the rPPG processing:

- `rawImage`: The raw RGB image captured from the front-facing camera.

- `roiMask`: A mask representing the region of interest (ROI) around the detected face.

- `face`: The detected face observation, providing information about its location and features.

- `signal`: An array of floats representing the filtered rPPG signal.

- `heartRate`: The estimated heart rate based on the filtered rPPG signal.


## RppgView

The `RppgView` struct is the main view of the Rppg app. It displays the video preview, ROI mask overlay, facial landmarks, waveform plot, heart rate, frequency spectrum, and UI controls.

### Properties

- `rppgModel`: An `RPPGModel` object that stores the rPPG data.
- `videoCapture`: A `CaptureSession` object that manages the capture of video frames.

### Body

The body of the `RppgView` struct is a `ZStack` that contains the following elements:

- `AVFoundationView`: Displays the video preview from the front-facing camera.
- `Image`: Displays the ROI mask overlay, which is a mask highlighting the region of interest (ROI) around the detected face.
- `ForEach`: Displays the facial landmarks, which are points representing the location of key facial features.
- `WaveformView`: Displays the waveform plot, which is a graph of the PPG signal over time.
- `Text`: Displays the heart rate, which is calculated from the PPG signal.
- `FrequencySpectrumView`: Displays the frequency spectrum, which is a visualization of the frequency components of the PPG signal.
- `HStack`: Contains the "Start" and "Stop" buttons to control the video capture.

### Methods

- `onAppear()`: Starts the video capture when the view appears.
- `onDisappear()`: Stops the video capture when the view disappears.

## WaveformView

The `WaveformView` struct displays the waveform plot of the PPG signal.

### Properties

- `signal`: An array of doubles representing the PPG signal.

### Body

The body of the `WaveformView` struct is a `ZStack` that contains a `Path` object that draws the line graph of the PPG signal.

## FrequencySpectrumView

The `FrequencySpectrumView` struct is a placeholder for the future implementation of the frequency spectrum visualization.

### Body

The body of the `FrequencySpectrumView` struct displays a placeholder text "Frequency Spectrum".

## CaptureSession

The `CaptureSession` class manages the capture of video frames from the front-facing camera and extracts the rPPG data from the captured frames.

### Properties

- `delegate`: An `RppgView` object that receives updates about the extracted rPPG data.
- `captureSession`: An `AVCaptureSession` object that manages the video capture pipeline.
- `videoOutput`: An `AVCaptureVideoDataOutput` object that receives video frames from the capture session.
- `isRunning`: A boolean property indicating whether the capture session is running.

### Methods

- `startRunning()`: Starts the video capture.
- `stopRunning()`: Stops the video capture.

### init()

The initializer of the `CaptureSession` class configures the capture session.

### captureOutput(_:didOutput:from:)

The `captureOutput()` method is called when a new video frame is captured. It extracts the image buffer from the sample buffer, converts it to a `UIImage`, and then extracts the face and ROI mask from the image. It then updates the `rPPGModel` with the extracted data, calculates the heart rate from the PPG signal, and updates the UI on the main thread.
