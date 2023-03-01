//
//  ImageItemView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit
import SnapKit

class ImageItemView: UITableViewCell {
    
    static let id = "ImageItemView"
    
    var delegate: TableCellDelegate?
    
    var index: Int?
    var url: URL?
    var viewModel: ImageDownloadViewModel?
    
    var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.style = .medium
        view.isHidden = false
        view.stopAnimating()
        
        return view
    }()
    
    var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2.0
        return view
    }()
    
    var button: UIButton = {
        let button = UIButton()
        
        button.setTitle("Load Image", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5.0
        
        return button
    }()
    
    private var state: DownloadState = .idle
    private var percent: CGFloat = .zero
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
        setAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(index:Int, url: URL, viewModel: ImageDownloadViewModel) {
        self.index = index
        self.url = url
        self.viewModel = viewModel
        
        state = .idle
        percent = .zero
        
        setLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadingImage(_:)), name: NSNotification.Name(rawValue: "LoadingImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadedImage(_:)), name: NSNotification.Name(rawValue: "UpdateImage"), object: nil)
        
        update(UIImage(named: "EmptyImage")!)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setLayout() {
        
        contentView.addSubview(image)
        contentView.addSubview(progressBar)
        contentView.addSubview(button)
        image.addSubview(indicator)
        
        indicator.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.center.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
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
    }
    
    func setAttribute() {
        self.selectionStyle = .none
        
        button.addTarget(self, action: #selector(cellTapped), for: .touchUpInside)
    }
    
    func update(_ image: UIImage) {
        
        self.image.image = image
        indicator.stopAnimating()
    }
    
    func update(_ percent: CGFloat) {
        // progress bar 올리기
    }
    
    @objc func loadingImage(_ notification: Notification) {
        if let index = notification.object as? Int, index == self.index {
            
            image.image = nil
            indicator.startAnimating()
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
    
    @objc func cellTapped() {
        guard let index = index else { return }
        
        delegate?.cellTapped(index: index)
    }
}

