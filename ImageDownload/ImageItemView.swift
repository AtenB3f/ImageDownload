//
//  ImageItemView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit

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
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: image.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 44).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: progressBar.rightAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        button.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 128).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
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

