//
//  ImageItemView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit

class ImageItemView: UIView {
    private enum Tag: Int {
        case image
        case progress
        case button
    }
    
    var url: URL
    private var state: DownloadState = .idle
    private var percent: CGFloat = .zero
    var view: UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), url: URL) {
        self.init(frame: frame)
        
        self.url = url
        state = .idle
        percent = .zero
        
        self.view = {
            let view = UIView()
            
            let image = UIImageView()
            let progressBar = UIView()
            let button = UIButton()
            
            image.tag = Tag.image.rawValue
            progressBar.tag = Tag.progress.rawValue
            button.tag = Tag.button.rawValue
            
            view.addSubview(image)
            view.addSubview(progressBar)
            view.addSubview(button)
            
            // 오토 레이아웃 설정 해야함
            
            return
        }()
    }
    
    func update(_ frame: CGRect, _ image: UIImage) {
        guard let view = self.view.viewWithTag(Tag.image.rawValue) as? UIImageView else { return }
        
        view.image = image
        view.frame = CGRect(origin: .zero, size: image.size)
    }
    
    func updata(_ percent: CGFloat) {
        // progress bar 올리기
    }
    
}
