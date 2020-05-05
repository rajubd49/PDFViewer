//
//  DownloadManager.swift
//  PDFViewer
//
//  Created by Raju on 4/5/20.
//  Copyright © 2020 Raju. All rights reserved.
//

import Foundation
import SwiftUI

public protocol DownloadManagerDelegate {
    func downloadDidFinished(success: Bool)
    func downloadDidFailed(failure: Bool)
    func downloadInProgress(progress: Float, totalBytesWritten: Float, totalBytesExpectedToWrite:Float)
}

public class DownloadManager: NSObject, ObservableObject {
    
    private var fileUrl: URL?
    private var downloadTask: URLSessionDownloadTask!
    public var delegate: DownloadManagerDelegate?
    static let downloadManager = DownloadManager()
    
    public class func shared() -> DownloadManager{
        return downloadManager
    }
    
    public func downloadFile(url: URL) {
        fileUrl = url
        let configuration = URLSessionConfiguration.default
        configuration.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        if downloadTask?.state == .running {
            downloadTask?.cancel()
        }
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
}

extension DownloadManager: URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let cachesDirectoryUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        if let url = fileUrl, let cachesDirectoryUrl = cachesDirectoryUrl {
            let destinationFileUrl = cachesDirectoryUrl.appendingPathComponent(url.lastPathComponent)
            do {
                try FileManager.default.moveItem(at: location, to: destinationFileUrl)
                print("Downloaded file path: \(destinationFileUrl.path)")
                self.delegate?.downloadDidFinished(success: true)
            }
            catch let error as NSError {
                print("Failed moving directory: \(error)")
                self.delegate?.downloadDidFailed(failure: true)
            }
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("Task completed: \(task), error: \(String(describing: error?.localizedDescription))")
        if error != nil {
            self.delegate?.downloadDidFailed(failure: true)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            if totalBytesExpectedToWrite > 0 {
                let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                print("Download progress: \(progress)")
                self.delegate?.downloadInProgress(progress: progress, totalBytesWritten: Float(totalBytesWritten) , totalBytesExpectedToWrite: Float(totalBytesExpectedToWrite))
            }
        }
    }
    
}
