//
//  ImageItemView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit
import SnapKit

class ImageItemView: UIView {
    private enum Tag: Int {
        case root
        case image
        case progress
        case button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var index: Int? = nil
    var url: URL? = nil
    var viewModel: ImageDownloadViewModel? = nil
    private var indicator: UIActivityIndicatorView? = nil
    private var state: DownloadState = .idle
    private var percent: CGFloat = .zero
    
    convenience init(frame: CGRect = CGRect(), index:Int, url: URL, viewModel: ImageDownloadViewModel) {
        self.init(frame: frame)
        self.index = index
        self.url = url
        self.viewModel = viewModel
        state = .idle
        percent = .zero
        
        let view = {
            let view = UIView()
            
            let image: UIImageView = {
                let view = UIImageView()
                view.contentMode = .scaleAspectFit
                
                return view
            }()
            
            let progressBar:UIView = {
                let view = UIView()
                view.backgroundColor = .lightGray
                view.layer.cornerRadius = 2.0
                return view
            }()
            
            let button:UIButton = {
                let button = UIButton()
                
                button.setTitle("Load Image", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = .darkGray
                button.layer.cornerRadius = 5.0
                
                return button
            }()
            
            button.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
            
            image.tag = Tag.image.rawValue
            progressBar.tag = Tag.progress.rawValue
            button.tag = Tag.button.rawValue
            
            view.addSubview(image)
            view.addSubview(progressBar)
            view.addSubview(button)
            
            // 오토 레이아웃 설정 해야함
            image.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview().inset(4)
                make.width.height.equalTo(100)
            }
            
            progressBar.snp.makeConstraints { make in
                make.left.equalTo(image.snp.right).offset(10)
                make.height.equalTo(4)
                make.centerY.equalToSuperview()
            }
            
            button.snp.makeConstraints { make in
                make.width.equalTo(120)
                make.height.equalTo(44)
                make.centerY.equalToSuperview()
                make.left.equalTo(progressBar.snp.right).offset(10)
                make.right.equalToSuperview().inset(16)
            }
            
            return view
        }()
        
        let indicator: UIActivityIndicatorView = {
            let view = UIActivityIndicatorView()
            
            view.style = .medium
            view.isHidden = false
            
            return view
        }()
        
        indicator.stopAnimating()
        self.indicator = indicator
        
        view.tag = Tag.root.rawValue
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadingImage(_:)), name: NSNotification.Name(rawValue: "LoadingImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadedImage(_:)), name: NSNotification.Name(rawValue: "UpdateImage"), object: nil)
        
        self.addSubview(view)
        view.viewWithTag(Tag.image.rawValue)?.addSubview(indicator)
        
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.center.equalToSuperview()
        }
        
        update(UIImage(named: "EmptyImage")!)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func update(_ image: UIImage) {
        guard let view = self.viewWithTag(Tag.image.rawValue) as? UIImageView else { return }
        
        view.image = image
        indicator?.stopAnimating()
    }
    
    func updata(_ percent: CGFloat) {
        // progress bar 올리기
    }
    
    @objc func loadingImage(_ notification: Notification) {
        if let index = notification.object as? Int, index == self.index {
            print("start")
            
            indicator?.startAnimating()
        }
        
    }
    
    @objc func loadedImage(_ notification: Notification) {
        guard let index = index else { return }
        
        if let data = notification.userInfo as? [Int: UIImage] {
            if let image = data[index], index == self.index {
                update(image)
            }
        }
    }
    
    @objc func action(_ sender: Any) {
        if let url = url, let index = index {
            viewModel?.requestImageLoad(index, url, callback: update(_:))
        }
    }
}
