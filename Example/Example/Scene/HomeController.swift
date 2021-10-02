//
//  HomeController.swift
//  
//
//  Created by Ferhan Akkan on 1.10.2021.
//

import UIKit

final class HomeController: RequestController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    items = ["Primary Api",
             "Secondary Api",
             "Custom Api"]
  }
}

// MARK: - TableView Delegate & DataSource

extension HomeController {

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    default:
      break
    }
  }
}
