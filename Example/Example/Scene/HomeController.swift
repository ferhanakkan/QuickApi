//
//  HomeController.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit

final class HomeController: UIViewController {
  
  private let items = ["Primary Api",
                       "Secondary Api",
                       "Custom Api",
                       "Multipart Api",
                       "Multipart Custom"]
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableFooterView = UIView(frame: .zero)
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLayout()
    tableView.reloadData()
  }
}

// MARK: - TableView Delegate & DataSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.row {
    case 0:
      show(PrimaryController(), sender: nil)
    case 1:
      show(SecondaryController(), sender: nil)
    case 2:
      show(CustomController(), sender: nil)
    case 3:
      show(MultipartController(), sender: nil)
    case 4:
      show(CustomMultipartController(), sender: nil)
    default:
      break
    }
  }
}

// MARK: - Layout

extension HomeController {
  
  private func setLayout() {
    view.backgroundColor = .white
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
