//
//  PrimaryController.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit
import QuickApi

final class PrimaryController: RequestController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    items = ["Get Successful Request",
             "Get Failure Request"]
    title = "Primary Controller"
  }
}

// MARK: - TableView Delegate & DataSource

extension PrimaryController {
  
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
