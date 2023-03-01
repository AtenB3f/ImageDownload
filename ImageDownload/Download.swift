//
//  Download.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import Foundation
import Combine

enum DownloadState {
    case idle
    case loading
    case finish
}

class Downloader {
    func imageLoad(_ url: URL) -> AnyPublisher<Data, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                
//                let dataToString = String(decoding: result.data, as: UTF8.self)
                
                return result.data
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    func imageDownload(_ url: URL, destinationUrl: URL) -> AnyPublisher<Data, Error> {
        let subject = PassthroughSubject<Data, Error>()
        
        let task = URLSession.shared.downloadTask(with: url) { url, response, error in
            guard let url = url, let response = response else {
                if let error = error {
                    print("imageDownload error - \(error.localizedDescription)")
                    subject.send(completion: .failure(error))
                }
                
                return
            }
            
            do {
                if let type = response.mimeType, type.hasPrefix("image") {
                    let file = try FileHandle(forReadingFrom: url)
                    
                    DispatchQueue.global().async {
                        let data = file.readDataToEndOfFile()
                        FileManager().createFile(atPath: destinationUrl.path, contents: data)
                        subject.send(data)
                    }
                }
                
            } catch {
                print("imageDownload error")
            }
        }
        
        task.resume()
        // open func downloadTask(with url: URL, completionHandler: @escaping @Sendable (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
        
        return subject
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
