//
//  ViewController.swift
//  Project5
//
//  Created by Vladimir on 10.12.2024.
//

import UIKit

class ViewController: UITableViewController {

    private var allWords = ["silkworm"]
    private var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wordsURL = Bundle.main.url(forResource: "start (1)", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                allWords = words.components(separatedBy: "\n")
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPrompt))
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    private func startGame() {
        let targetWord = allWords.randomElement()
        title = targetWord?.uppercased()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc
    private func addPrompt() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer: answer)
        }
        ac.addAction(submitAction)
        ac.preferredAction = submitAction
        present(ac, animated: true)
    }
    
    private func submit(answer: String) {
        
    }
}

