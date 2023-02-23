//
//  ImageDownloadViewModel.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/18.
//

import UIKit
import Combine

enum Status {
    case idle
    case loading
}

class ImageDownloadViewModel {
     var urls:[String] = ["https://cdn.pixabay.com/photo/2023/02/14/18/55/flowers-7790227_1280.jpg",
                          "https://cdn.pixabay.com/photo/2012/03/01/00/55/flowers-19830_1280.jpg",
                          "https://cdn.pixabay.com/photo/2014/04/14/20/11/pink-324175_1280.jpg"]
    
    var images:[Int:UIImage] = [:]
    
    var status: Status = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestImageLoad(_ index:Int, _ url: URL, callback: @escaping (UIImage)->Void) {
        guard status != .loading else { return }
        
        status = .loading
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadingImage"), object: index)
        
        Downloader().imageLoad(url)
            .sink { [weak self] error in
                guard let self = self else { return }
                
                print(error)
                self.status = .idle
                
            } receiveValue: { [weak self]  response in
                guard let self = self else { return }
                
                if let image = UIImage(data: response) {
                    self.images[index] = image
                    callback(image)
                }
            }
            .store(in: &cancellables)
    }
    
    func requestAllLoad() {
        guard status != .loading else { return }
        
        status = .loading
        
        for (index, url) in urls.enumerated(){
            if let url = URL(string: url) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoadingImage"), object: index)
                
                Downloader().imageLoad(url)
                    .sink { [weak self] error in
                        guard let self = self else { return }
                        print(error)
                        
                        self.status = .idle
                        
                    } receiveValue: { [weak self]  response in
                        guard let self = self else { return }
                        
                        print("ret")
                        if let image = UIImage(data: response) {
                            self.images[index] = image
                            
                            let data = [index:image]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateImage"), object: nil, userInfo: data)
                        }
                    }
                    .store(in: &self.cancellables)
            }
        }
    }
}
