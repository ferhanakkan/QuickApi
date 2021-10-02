//
//  CustomController.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit
import QuickApi
import Alamofire

final class CustomController: RequestController {
  
  private let httpHeader: HTTPHeaders = [
    "Authorization" : "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MGE4ZTIxNzY4NTZhMDUwMjRhZDkzYzQwMWU3MDk5MiIsInN1YiI6IjYwNDU0ZmNjZDhlMjI1MDA0NTUyZjg5OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.0eT2aN1gqiaZADmuf158U4fTJfS1jbQtD96g_kEbNhk",
    "Content-Type" : "application/json;charset=utf-8"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
      title = "Custom Controller"
      items = ["Get Successful Request",
               "Get Unauthorized Request",
               "Get Failure Request"]
  }
}

// MARK: - TableView Delegate & DataSource

extension CustomController {
  
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

extension CustomController {
  
  private func createListItem() {
    Quick.shared.customRequest(full: "https://api.themoviedb.org/4/list/1",
                               header: httpHeader,
                               method: .get,
                               parameters: nil,
                               decodeObject: TmdbResponse.self) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(let error):
        print(error.statusCode ?? "")
        print(error.json ?? "")
      }
    }
  }
  
  private func createListItemUnauthenticated() {
    
    let wrongTokenHeader: HTTPHeaders =   [
      "Authorization" : "wrongToken",
      "Content-Type" : "application/json;charset=utf-8"
    ]
    
    Quick.shared.customRequest(full: "https://api.themoviedb.org/4/list/1",
                               header: wrongTokenHeader,
                               method: .get,
                               parameters: nil,
                               decodeObject: TmdbResponse.self) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(let error):
        print(error.statusCode ?? "")
        print(error.json ?? "")
      }
    }
  }
  
  private func createListItemFailure() {
    Quick.shared.customRequest(full: "https://api.themoviedb.org/4/list",
                               header: httpHeader,
                               method: .get,
                               parameters: nil,
                               decodeObject: TmdbResponse.self) { result in
      switch result {
      case .success(_):
        break
        
      case .failure(let error):
        print(error.statusCode ?? "")
        print(error.json ?? "")
      }
    }
  }
}
