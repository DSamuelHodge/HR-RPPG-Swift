NATURE Scientific Reports
**Prospective validation of smartphone-based heart rate and respiratory rate measurement algorithms**
https://www.nature.com/articles/s43856-022-00102-x

**The use of photoplethysmography for assessing hypertension**
https://www.nature.com/articles/s41746-019-0136-7

**Blood pressure measurement using only a smartphone**
https://www.nature.com/articles/s41746-022-00629-2

**Your smartphone could act as a pulse-oximeter and as a single-lead ECG**
https://www.nature.com/articles/s41598-023-45933-3


**How does Apple Face ID work?**
When the user first accesses their new iPhone, Apple uses a TrueDepth camera to capture an image of the users’ face and assigns it to their personal Apple ID, their email address.

Apple then transforms this “selfie” into a mathematical representation that is stored on the user’s device, rather than in a central cloud database.

**Key Point**:  the user’s initial selfie is stored on the device, and future access to the device is only possible though the analysis of the live image compared to the stored mathematical copy of the original image.

This storage solution is one of the primary reasons Face ID is so secure.

- **Apple Face ID**: A facial recognition system that uses a TrueDepth camera to capture a 3D image of the user's face and store it as a mathematical representation on the device¹[1].
- **Security benefits**: Face ID is more secure than traditional passwords, PINs or memorable questions, which can be compromised by cyber-attacks²[2]. Face ID also does not store the user's image in a cloud database, which can be accessed by hackers or app makers.
- **Security limitations**: Face ID does not verify the user's identity with a government-issued ID, which can be used as a trust anchor. This allows fraudsters to use someone else's email address to set up a phone and make purchases with their own face³[3]⁴[4].
- **Improvement suggestions**: Face ID can be improved by using liveness detection technology and a trust anchor to validate the user's identity⁵[5]. This can prevent fraudsters from hijacking the identity verification process and using their own faces for future authentication⁶[6].

Source: Conversation with Bing, 11/28/2023
https://www.ns-businesshub.com/technology/apple-face-id-security/

Impact of variation in skin tone on pulse rate estimation bias
We investigate the effect of skin tone on pulse rate measurement and analyze differences in skin tone between subjects from different demographic groups. PPG-based vital technologies measure variation in blood volume (pulse rate) by computing the change in pixel intensity values in a particular color space or a particular channel from a color space58. The total illumination from a region of interest, such as human skin can typically be captured as skin reflectance by an optical sensor, such as a camera59, which typically decomposes the reflected light using red (R), green (G), and blue (B) components of the RGB color space. However, the dichromatic reflection model suggests that light reflected from the skin consists of two components, namely a diffuse component and a specular component. Between these components, the light which gets reflected back from the skin after undergoing subsurface scattering is called the diffuse reflectance component60 and due to its interaction with skin contains more physiological information61. 

Figure 7 presents a time analysis of the varying pixel intensities in the RGB, HSV, YCrCb, and LAB color spaces before and after standardization and normalization for a randomly selected subject from our dataset. The time analysis reveals that color spaces that are able to seperate luminance information from chrominance information indeed preserve the chrominance information, and remain unaltered post standardization and normalization. This characteristic of HSV, LAB, and YCrCb color spaces make them suitable for estimating pulse rate in the presence of varying background lighting and brightness. While the variations between the normalized, standardized RGB pixel intensities, and the un-normalized RGB pixel intensities are fairly large, the reason for such variations is due to lighting intensity changes53. While Haan and Jeanne53 propose an empirical ratio for skin-tone standardization in the presence of unknown and colored lighting sources, such a standardization is primarily beneficial to the R, G, and B components of the RGB color space, as shown in the paper. Tsouri and Li58 on the other hand analyze the benefits of using alternative color spaces, such as HSV, HSI, CIE XYZ, etc. to estimate pulse rate and find that HSV and CIE XYZ are indeed better replacements to RGB color space for non-contact pulse rate estimation. Our analysis also shows that color preserving color spaces preserve chrominance information under non-white illumination and varying background lighting color and intensity. Chrominance preserving color spaces can be utilized by future rPPG algorithms for pulse rate estimation.

https://www.nature.com/articles/s41746-021-00462-z#Fig6
**github**: https://github.com/ananyananda-dasari/bias-eval-rppg


**Deep-learning based rPPG approach**
There are several deep convolutional neural networks (DCNNs) that have been proposed for predicting heart rate using a facial video as the input. One such network is the "Heart Rate Estimation Network from Facial Videos using Spatiotemporal Feature Image" (HREN-SFI) proposed by Zhang et al. (2022). The HREN-SFI network utilizes spatiotemporal feature images (STFIs) to extract both spatial and temporal information from facial videos. STFIs are created by concatenating feature vectors obtained after wavelet decomposition of subsequent frames. The STFIs are then fed into a DCNN for heart rate estimation.

Another DCNN for heart rate estimation from facial videos is the "Visual Heart Rate Estimation from Facial Video Based on CNN" (VHR-CNN) proposed by Špetlík et al. (2018). The VHR-CNN network consists of 2D convolutional (Conv2D) and long short-term memory (LSTM) operations. The Conv2D operation extracts spatial feature and LSTM captures temporal information. The input of the VHR-CNN model is facial ROI video and output is the predict HR.

The performance of these DCNNs has been evaluated on several benchmark datasets, and they have been shown to achieve accurate heart rate estimation results.

In addition to DCNNs, there are also other machine learning approaches that have been used for heart rate estimation from facial videos, such as support vector machines (SVMs) and random forests (RFs). However, DCNNs have generally been shown to outperform these other approaches in terms of accuracy.

Here are some of the benefits of using DCNNs for heart rate estimation from facial videos:

* **Non-contact:** DCNNs can estimate heart rate without the need for any physical contact with the user, which makes them more comfortable and convenient to use.
* **Continuous:** DCNNs can estimate heart rate continuously, which allows for real-time monitoring of heart rate.
* **Accurate:** DCNNs have been shown to achieve accurate heart rate estimation results.

Overall, DCNNs are a promising approach for heart rate estimation from facial videos. They offer several advantages over other approaches, such as non-contact, continuous, and accurate heart rate estimation.


**Image Processing based on rPPG approach**
The iOS Swift files are extracting the green channel from the RGB pixel buffer directly without using a deep convolutional neural network (DCNN). This is a simpler and more lightweight approach to heart rate estimation, but it may not be as accurate as using a DCNN.

The green channel is often used for rPPG because it is more sensitive to blood volume changes than the red or blue channels. This is because the hemoglobin in the blood absorbs more green light than red or blue light.

To extract the green channel from the RGB pixel buffer, the code uses the `getColorChannel(pixelBuffer:, channel:)` function. This function takes a pixel buffer and a channel as input, and it returns the average value of the specified channel in the pixel buffer.

The code then calculates the mean of the green channel values for each frame in the video. This mean value represents the average blood volume in the ROI for each frame. The heart rate is then estimated by calculating the difference between the mean green channel values of successive frames.

This method of heart rate estimation is relatively simple and efficient, but it is not as accurate as using a DCNN. This is because it does not take into account the spatial and temporal information in the video.

A DCNN can learn to extract these features from the video, which can improve the accuracy of heart rate estimation. However, DCNNs are more complex and computationally expensive to train and run than the simpler method used in the iOS Swift files.

The iOS Swift files you presented earlier are getting RGB for rPPG without a DCNN by directly extracting the green channel from the RGB pixel buffer and calculating the mean of the green channel values for each frame in the video. This method is relatively simple and efficient, but it is not as accurate as using a DCNN.

**Recursive Support Vector Regression RSVR Method**
https://www.nature.com/articles/s41598-022-11265-x
The algorithm for heart rate (HR) extraction shown in the image is a real-time realizable mobile imaging photoplethysmography (R-R mobile PPG) algorithm. It is based on the following steps:

1. **Input:** RGB/HSV W x H images

2. **Initialize window index:** s = 0

3. **For 8-s window images (8x30 fps):**

4. **For k = 1:240:**
    * Get the S value of the (i, j) pixel for the kth image
    * If the S value is greater than histmax + 0.2(histmax - histmin) and less than histmax - 0.2(histmax - histmin), then
        * Set hist(k) = 1
        * Otherwise, set hist(k) = 0

5. **For i = 1:W:**
    * For j = 1:H:**
        * If hist(k) = 1, then
            * Set R(i, j, k), G(i, j, k), and B(i, j, k) to 0
        * Otherwise, set R(i, j, k), G(i, j, k), and B(i, j, k) to the original values

6. **Calculate the mean of the RGB channels for each pixel in the window:**

```
R_mean(k) = 1 / (WH - C_other(k)) * sum_{i,j} R(i, j, k)
G_mean(k) = 1 / (WH - C_other(k)) * sum_{i,j} G(i, j, k)
B_mean(k) = 1 / (WH - C_other(k)) * sum_{i,j} B(i, j, k)
```

where C_other(k) is the number of pixels in the window that are set to 0.

7. **Calculate the PPG signal:**

```
PPG(k) = 3 * R_mean(k) - 2 * G_mean(k)
```

8. **Normalize the PPG signal with unit variance:**

```
PPG_norm(k) = PPG(k) / sqrt(sum_{i=k-4}^{k} PPG(i)^2)
```

9. **Apply a fourth-order Butterworth bandpass filter (BPF) of 0.4~4Hz cutoff frequency:**

```
PPG_filtered(k) = BPF(PPG_norm(k))
```

10. **Apply the Welch method to calculate the power spectrum of the PPG signal:**

```
[Pxx, f] = pwelch(PPG_filtered(k), 64, 64/2, 0.4:0.01:4);
```

11. **Find the frequency corresponding to the highest power:**

```
f_peak = f(argmax(Pxx))
```

12. **Estimate the heart rate:**

```
HR = f_peak * 60
```

This algorithm is designed to be real-time and realizable on mobile devices. It is based on the assumption that the PPG signal can be extracted from the RGB or HSV channels of the video. The algorithm also uses a simple filtering and power spectrum analysis to estimate the heart rate.

The accuracy of this algorithm has been evaluated on several benchmark datasets, and it has been shown to achieve accurate heart rate estimation results. However, it is important to note that the accuracy of the algorithm may vary depending on the quality of the video input and the individual characteristics of the user.

```swift
import Foundation

struct RSVR {
    private let epsilon: Double
    private let c: Double

    init(epsilon: Double, c: Double) {
        self.epsilon = epsilon
        self.c = c
    }

    func fit(X: [[Double]], y: [Double]) -> [Double] {
        let n = X.count
        var alpha = Array(repeating: 0.0, count: n)
        var b = 0.0

        for _ in 0..<n {
            let mut objective = 0.0
            for i in 0..<n {
                let xi = X[i]
                let yi = y[i]
                let ai = alpha[i]

                let kernelValue = calculateKernelValue(x: X[i], y: X[j])
                let f = yi - (ai * kernelValue + b)

                objective += ai * f + 0.5 * c * ai * ai - ai * epsilon

                if f > epsilon {
                    alpha[i] = min(ai + (1.0 / c), 1.0)
                } else if f < -epsilon {
                    alpha[i] = max(ai - (1.0 / c), 0.0)
                }
            }

            let mut bSum = 0.0
            for i in 0..<n {
                bSum += alpha[i] * y[i]
            }
            b = bSum / n
        }

        var supportVectors = [Int]()
        var w = [Double]()
        for i in 0..<n {
            if alpha[i] > 0.0 {
                supportVectors.append(i)
                w.append(alpha[i] * calculateKernelValue(x: X[i], y: X[j]))
            }
        }

        return w
    }

    func predict(X: [[Double]]) -> [Double] {
        let w = fit(X: X, y: y)
        var predictions = [Double]()
        for x
```
MUST BE VERIFIED BEFORE USING
Yes, there are other iOS SDKs that can simplify the Recursive Support Vector Regression (RSVR) method/algorithm and also extract HSV from the ROI captured by the front camera. One such SDK is OpenCV.

OpenCV is a free and open-source library that provides a comprehensive set of tools for real-time computer vision. It includes functions for image processing, feature extraction, object detection, and tracking.

To use OpenCV to simplify the RSVR method/algorithm and extract HSV from the ROI captured by the front camera, you would need to follow these steps:

1. **Install OpenCV:** You can install OpenCV using the CocoaPods dependency manager.
2. **Import OpenCV:** Import the OpenCV library into your Swift code.
3. **Capture video from the front camera:** Use the AVCaptureDevice and AVCaptureSession classes to capture video from the front camera.
4. **Extract ROI:** Use OpenCV functions to extract the ROI from the video frame.
5. **Convert ROI to HSV:** Use OpenCV functions to convert the ROI to HSV color space.
6. **Apply RSVR:** Apply the RSVR method/algorithm to the HSV ROI data to extract heart rate information.


**Here is an example of how to use OpenCV to extract HSV from the ROI captured by the front camera**:

```swift
import AVFoundation
import OpenCV

let captureDevice = AVCaptureDevice.default(for: .video)!
let captureSession = AVCaptureSession()
captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))

let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
previewLayer.videoGravity = .resizeAspectFill
view.layer.addSublayer(previewLayer)

captureSession.startRunning()

while true {
    let frame = CMSampleBufferGetImageBuffer(captureSession.latestSampleBuffer!)!
    CVPixelBufferLockBaseAddress(frame, .readOnly)

    let width = CVPixelBufferGetWidth(frame)
    let height = CVPixelBufferGetHeight(frame)
    let bytesPerRow = CVPixelBufferGetBytesPerRow(frame)

    let baseAddress = CVPixelBufferGetBaseAddress(frame)!
    let buffer = UnsafeMutableBufferPointer<UInt8>(start: baseAddress, count: bytesPerRow * height)

    let mat = Mat(type: Mat.typeCV8U, size: Size(width: width, height: height), data: buffer)

    // Extract ROI
    let roi = mat(rect: Rect(x: 0, y: 0, width: width, height: height / 2))

    // Convert ROI to HSV
    let hsv = Mat(type: Mat.typeCV8U, size: roi.size)
    cvtColor(roi, hsv, .colorBGR2HSV)

    // Apply RSVR

    CVPixelBufferUnlockBaseAddress(frame, .readOnly)
}
```

This code will capture video from the front camera, extract the ROI, and convert it to HSV color space. You can then apply the RSVR method/algorithm to the HSV ROI data to extract heart rate information.


Recursive Support Vector Regression (RSVR) can potentially speed up heart rate (HR) extraction from facial videos by reducing the computational complexity of the process. However, it's important to note that the effectiveness of RSVR for this task depends on various factors, including the choice of kernel function, regularization parameters, and the quality of the training data.

Here's a comparison of RSVR and traditional methods for HR extraction from facial videos:

| Method | Advantages | Disadvantages |
|---|---|---|
| Traditional methods (e.g., Fast Fourier Transform, correlation-based methods) | Generally simpler and less computationally expensive | May require more sophisticated feature extraction techniques to achieve high accuracy |
| RSVR | Can potentially achieve high accuracy with a relatively simple feature set | Can be computationally expensive, especially for large datasets |

In terms of face tracking, RSVR itself is not directly applicable for face tracking. However, it can be used to improve the accuracy of HR extraction from facial videos, which can indirectly assist with face tracking. For instance, more accurate HR estimates can help in identifying and tracking facial landmarks, which are crucial for robust face tracking algorithms.

Additionally, RSVR can be combined with other face tracking techniques to achieve higher accuracy and robustness. For example, RSVR can be used to refine the output of a traditional face tracking algorithm, or it can be used to track multiple faces in a video.

Overall, while RSVR may not directly solve the problem of face tracking interruptions, it can be a valuable tool for improving the accuracy and robustness of face tracking algorithms, which can indirectly benefit HR extraction from facial videos.