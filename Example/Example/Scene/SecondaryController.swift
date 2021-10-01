//
//  SecondaryController.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit
import QuickApi

final class SecondaryController: UIViewController {
  
  private let items = ["Post Successful Request",
                       "Post Unauthorized Request",
                       "Post Failure Request"]
  
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

extension SecondaryController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0:
      createListItem()
      
    case 1:
      createListItemUnauthenticated()
      
    case 2:
      createListItemFailure()
      
    default:
      break
    }
  }
}


// MARK: - Requests

extension SecondaryController {
  
  private func createListItem() {
    
    let params = TmdbRequest(name: "test",
                             iso_639_1: "en")
    
    Quick.shared.post(url: "list",
                      parameters: params.asDictionary(),
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(let error):
        print("fero \(error.statusCode)")
        print("test \(error.json)")
      }
    }
  }
  
  private func createListItemUnauthenticated() {
    
    let params = TmdbRequest(name: "test",
                             iso_639_1: "test")
    
    Quick.shared.post(url: "list",
                      parameters: params.asDictionary(),
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(_):
        break
      }
    }
  }
  
  private func createListItemFailure() {
    
    let params = TmdbRequest(name: "test",
                             iso_639_1: "test")
    
    Quick.shared.post(url: "wronUrl",
                      parameters: params.asDictionary(),
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(_):
        break
      }
    }
  }
}

// MARK: - Layout

extension SecondaryController {
  
  private func setLayout() {
    view.backgroundColor = .white
    title = "Secondary Controller"
    
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
