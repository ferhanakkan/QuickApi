//
//  PrimaryController.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit
import QuickApi

final class PrimaryController: UIViewController {
  
  private let items = ["Get Successful Request",
                       "Get Failure Request"]
  
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

extension PrimaryController: UITableViewDelegate, UITableViewDataSource {
  
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
      fetchCurrentWeatherForIstanbul()
      
    case 1:
      fetchFailureCurrentWeather()
      
    default:
      break
    }
  }
}


// MARK: - Requests

extension PrimaryController {
  
  private func fetchCurrentWeatherForIstanbul() {
    
    let params = OpenWeatherRequest(appid: "0450ce247d7299b5dc2f7aa86ec667e0",
                                    q: "istanbul")
    
    Quick.shared.get(url: "data/2.5/weather",
                     parameters: params.asDictionary(),
                     decodeObject: OpenWeatherResponse.self) { result in
      switch result {
      case .success(let value):
        print(value)
      case .failure(let error):
        print(error.alamofireError.url)
      }
    }
  }
  
  private func fetchFailureCurrentWeather() {
    
    let params = OpenWeatherRequest(appid: "0450ce247d7299b5dc2f7aa86ec667e0---",
                                    q: "WrongCity")
    
    Quick.shared.get(url: "data/2.5/weatherrrr",
                     parameters: params.asDictionary(),
                     decodeObject: OpenWeatherResponse.self) { result in
      switch result {
      case .success(let value):
        print(value)
      case .failure(let error):
//        print(error.json ?? [:])
        print(error.response)
      }
    }
  }
}

// MARK: - Layout

extension PrimaryController {
  
  private func setLayout() {
    view.backgroundColor = .white
    title = "Primary Controller"
    
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
