# PDFViewer

## PDFViewer powered by PDFKit and SwiftUI

# Installation
The preferred way of installing is via the [Swift Package Manager](https://swift.org/package-manager/).

>Xcode 11 integrates with libSwiftPM to provide support for iOS, watchOS, and tvOS platforms.

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/rajubd49/PDFViewer.git`) and click **Next**.
3. For **Rules**, select **Branch** (with branch set to `1.0.1` ).
4. Click **Finish**.

## Excample code
```Swift
import SwiftUI
import PDFViewer

struct ContentView: View, DownloadManagerDelegate {
    
    @State private var viewLocalPDF = false
    @State private var viewRemotePDF = false
    @State var loadingPDF: Bool = false
    @State var progressValue: Float = 0.0
    @ObservedObject var downloadManager = DownloadManager.shared()
    
    let pdfName = "sample"
    let pdfUrlString = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    NavigationLink(destination: PDFViewer(pdfName: pdfName), isActive: $viewLocalPDF) {
                        Button("View Local PDF"){
                            self.viewLocalPDF.toggle()
                        }
                        .padding(.bottom, 20)
                    }
                    Button("View Remote PDF"){
                        if self.fileExistsInDirectory() {
                            self.viewRemotePDF = true
                        } else {
                            self.downloadPDF(pdfUrlString: self.pdfUrlString)
                        }
                    }
                    
                    if self.viewRemotePDF {
                        NavigationLink(destination: PDFViewer(pdfUrlString: self.pdfUrlString), isActive: self.$viewRemotePDF) {
                            EmptyView()
                        }.hidden()
                    }
                }
                ProgressView(value: self.$progressValue, visible: self.$loadingPDF)
            }
            
            .navigationBarTitle("PDFViewer", displayMode: .inline)
        }
    }
    
    func fileExistsInDirectory() -> Bool {
        if let cachesDirectoryUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first, let lastPathComponent = URL(string: self.pdfUrlString)?.lastPathComponent {
            let url = cachesDirectoryUrl.appendingPathComponent(lastPathComponent)
            if FileManager.default.fileExists(atPath: url.path) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func downloadPDF(pdfUrlString: String) {
        guard let url = URL(string: pdfUrlString) else { return }
        downloadManager.delegate = self
        downloadManager.downloadFile(url: url)
    }
    
    //MARK: DownloadManagerDelegate
    public func downloadDidFinished(success: Bool) {
        if success {
            loadingPDF = false
            viewRemotePDF = true
        }
    }
    
    public func downloadDidFailed(failure: Bool) {
        if failure {
            loadingPDF = false
            print("PDFCatalogueView: Download failure")
        }
    }
    
    public func downloadInProgress(progress: Float, totalBytesWritten: Float, totalBytesExpectedToWrite: Float) {
        loadingPDF = true
        progressValue = progress
    }
}
```

## Features

* View local PDF
* Download PDF from remote url and save in cache directory to view PDF
* PDF thumbnail view show
* PDF view page change notification 
* PDF view annotation hit otification
* Share PDF file

## Author

rajubd49@gmail.com

## License

PDFViewer is released under the MIT License. [See LICENSE](https://github.com/rajubd49/PDFViewer/blob/master/LICENSE) for details.
