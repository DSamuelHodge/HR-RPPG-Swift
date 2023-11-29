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

Sure, here is the documentation for the provided code:

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
