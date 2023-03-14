//
//  Download.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import Foundation

enum DownloadState {
    case idle
    case loading
    case finish
}

class Downloader {
    
    static let shared = Downloader()
    
    private var task: URLSessionDataTask!
    
    func imageLoad(_ url: URL, _ callback: @escaping (Data?)->Void ) -> Void {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                
                return
            }
            
            callback(data)
        }
        
        task.resume()
    }
}
