//
//  SecondaryController.swift
//  Example
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit
import QuickApi

final class SecondaryController: RequestController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    items = ["Get Successful Request",
             "Get Unauthorized Request",
             "Get Failure Request"]
    title = "Secondary Controller"
  }
}

// MARK: - TableView Delegate & DataSource

extension SecondaryController {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch indexPath.row {
    case 0:
      QuickSettings.shared.setTrueTokenForSecondartApi()
      createListItem()
      
    case 1:
      QuickSettings.shared.setWrongTokenForSecondaryApi()
      createListItemUnauthenticated()
      
    case 2:
      QuickSettings.shared.setTrueTokenForSecondartApi()
      createListItemFailure()
      
    default:
      break
    }
  }
}


// MARK: - Requests

extension SecondaryController {
  
  private func createListItem() {
    
    Quick.shared.get(url: "list/1",
                      parameters: nil,
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
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
    
    Quick.shared.get(url: "list/1",
                      parameters: nil,
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
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
    
    Quick.shared.get(url: "list",
                      parameters: nil,
                      decodeObject: TmdbResponse.self,
                      apiType: .secondary) { result in
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
