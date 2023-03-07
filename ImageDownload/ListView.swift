//
//  ListView.swift
//  ImageDownload
//
//  Created by Ivy Moon on 2023/03/01.
//

import UIKit

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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -72).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        allButton.translatesAutoresizingMaskIntoConstraints = false
        allButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        allButton.leftAnchor.constraint(equalTo: tableView.leftAnchor, constant: 16).isActive = true
        allButton.rightAnchor.constraint(equalTo: tableView.rightAnchor, constant: -16).isActive = true
        allButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        allButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
