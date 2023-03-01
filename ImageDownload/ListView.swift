//
//  ListView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/03/01.
//

import UIKit
import SnapKit

class ListViewController: UIViewController {
    
    lazy var tableView: UITableView = UITableView()
    
    lazy var allButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("All Load Image", for: .normal)
        button.backgroundColor = .black
        
        return button
    }()
    
    let viewModel = ImageDownloadViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAttribute()
    }
    
    func setAttribute() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageItemView.self, forCellReuseIdentifier: ImageItemView.id)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 108
        
        allButton.addTarget(self, action: #selector(action), for: .touchUpInside)
    }
    
    func setLayout() {
        self.view.addSubview(tableView)
        self.view.addSubview(allButton)
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(72)
        }
        
        allButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
}

extension ListViewController {
    @objc func action() {
        viewModel.requestAllLoad()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageItemView.id, for: indexPath) as? ImageItemView else {
                    return UITableViewCell()
                }
        
        
        cell.index = indexPath.row
        cell.delegate = self
        if let url = URL(string: viewModel.urls[indexPath.row]) {
            cell.initialize(index: indexPath.row, url: url, viewModel: viewModel)
        }
        
        return cell
    }
    
}

extension ListViewController: TableCellDelegate {
    func cellTapped(index: Int) {
        if let url = URL(string: viewModel.urls[index]) {
            viewModel.requestImageLoad(index, url)
        }
    }
}
