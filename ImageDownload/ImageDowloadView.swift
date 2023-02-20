//
//  ImageDowloadView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit

class ImageDownloadView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100), viewModel: ImageDownloadViewModel) {
        self.init(frame: frame)
        
        let stack: UIStackView = {
            let view = UIStackView()
            
            view.axis = .vertical
            view.spacing = 0
            view.alignment = .top
            view.distribution = .fillProportionally
            
            for item in viewModel.urls {
                if let url = URL(string: item) {
                    let itemView = ImageItemView(url: url, viewModel: viewModel)
                    view.addArrangedSubview(itemView)
                    print("utem")
                    itemView.snp.makeConstraints { make in
                        make.left.right.equalToSuperview()
                    }
                }
            }
            
            
            return view
        }()
        
        let allButton: UIButton = {
            let button = UIButton()
            
            button.setTitle("All Image Load", for: .normal)
            button.backgroundColor = .blue
            button.layer.cornerRadius = 5.0
            
            return button
        }()
        
        stack.tag = 0
        
        self.addSubview(stack)
        self.addSubview(allButton)
        
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        allButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(10)
        }
        
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
//    convenience init(frame: CGRect, viewModel: ImageDownloadViewModel) {
//        self.init(frame: frame)
//        
//        self.view = {
//            let view = UIView()
//            
//            let allButton = UIButton()
//            
//            return view
//        }()
//    }
}
