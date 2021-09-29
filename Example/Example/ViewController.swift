//
//  ViewController.swift
//  Example
//
//  Created by Ferhan Akkan on 29.09.2021.
//

import UIKit
import QuickApi

// MARK: - Welcome
struct Welcome: Codable {
    let info: Info?
    let results: [Result]?
    let error: String?
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}


struct TestRequestResponse<T: Codable>: Codable {
  var error: String?
  var data: T
}

final class ViewController: UIViewController {
  
  private let items = ["post", "get",  "put", "patch", "delete", "upload"]
  
  private let textView: UITextView = {
    let textView = UITextView()
    return textView
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.tableFooterView = UIView(frame: .zero)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Quick.shared.showResponseInDebug(true)
    
    
    Quick.shared.setCustomErrorManager { json in
      guard let json = json else { return nil }
      if let message = json["hh"] as? String {
        return message
      }
      return nil
    }
    
    Quick.shared.get(url: "https://rickandmortyapi.com/api/character/?status=ferhan",
                      decodeObject: Welcome.self,
                      retryCount: 2) { result in
      switch result {
      case .success(let model):
        print(model)
      case .failure(let error):
        print(error.customErrorMessage)
        
      }
    }
    
    setLayout()
    tableView.reloadData()
  }
}

// MARK: - TableView Delegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
}

// MARK: - Layout

extension ViewController {
  
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
