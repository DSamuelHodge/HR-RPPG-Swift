Here's a step-by-step guide:

**1. Create a new Xcode project**

Open Xcode and select "Create a new Xcode project". Choose "App" as the project template and give your project a name like "RPPGApp". Select the appropriate team and click "Next".

**2. Import the Swift files**

Drag and drop the `rppg_SwiftUI.swift` and `rPPG.swift` files into the project navigator. Xcode will automatically add them to your project.

**3. Create the Main View**

Open the `ContentView.swift` file and replace the existing code with the following:

```swift
import SwiftUI

struct ContentView: View {
    @StateObject private var model = RPPGModel()

    var body: some View {
        FaceAnalysisView(model: model)
    }
}
```

This code will create a new `ContentView` that displays the `FaceAnalysisView`. The `@StateObject` property will keep track of the `RPPGModel` instance, which is responsible for processing the video data and detecting faces.

**4. Run the app**

Connect your iPhone or iPad to your Mac and click the "Run" button in Xcode. The app will launch on your device and start capturing video from the front camera. You should see the face landmarks and heart rate displayed on the screen.

**5. Add additional features**

You can now add additional features to your app, such as saving the results to a file or displaying a graph of the heart rate over time.

Save the results to a file:

```swift
func saveResults(results: RppgResults) {
    let encoder = JSONEncoder()
    let data = try! encoder.encode(results)

    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent("results.json")

    try! data.write(to: fileURL)
}
```

To use this function, call it from the `didDetect` method in the `RPPGDelegate` protocol:

```swift
func didDetect(faces: [VNFaceObservation]) {
    // ...

    let results = RppgResults(rawImage: rgbBuffer,
                               roiMask: roiMask,
                               face: face,
                               signal: filteredSignal,
                               heartRate: heartRate)

    saveResults(results: results)
}
```

This will save the results of each face detection to a file called `results.json` in the Documents directory.
