# PDFViewer

## PDFViewer powered by PDFKit and swiftUI

# Installation
The preferred way of installing is via the [Swift Package Manager](https://swift.org/package-manager/).

>Xcode 11 integrates with libSwiftPM to provide support for iOS, watchOS, and tvOS platforms.

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/rajubd49/PDFViewer.git`) and click **Next**.
3. For **Rules**, select **Branch** (with branch set to `1.4.2` ).
4. Click **Finish**.

## Excample code
```Swift
import SwiftUI
import PDFViewer

struct ContentView: View {
    
    @State private var showPDF = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: PDFViewer(pdfName: "sample"), isActive: $showPDF) {
                Button("Show PDF"){
                    self.showPDF.toggle()
                }
            }
            .navigationBarTitle("PDKKit SwiftUI Demo", displayMode: .inline)
        }
    }
}
```
