//
//  ViewController.swift
//  Project4
//
//  Created by Vladimir on 09.12.2024.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
    
    private(set) var websites = ["Apple", "HackingWithSwift", "Google"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Websites"
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            vc.websites = websites
            vc.website = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        websites.count
    }
}
