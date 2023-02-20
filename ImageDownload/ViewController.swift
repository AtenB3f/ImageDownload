//
//  ViewController.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/02/17.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let viewModel = ImageDownloadViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let downloadView = ImageDownloadView(viewModel: viewModel)
        self.view.addSubview(downloadView)
        
        downloadView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }


}

enum DownloadState {
    case idle
    case loading
    case finish
}

