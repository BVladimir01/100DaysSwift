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
    
    private var alertTitle: String?
    private var alertMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let wordsURL = Bundle.main.url(forResource: "start (1)", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                allWords = words.components(separatedBy: "\n")
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPrompt))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
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
    
    @objc
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
        let lowerWord = answer.lowercased()
        let checkFunctions = [isReal, isOriginal, isCompilable, isLongEnough, isNotTargetWord]
        let isSubmitted = checkFunctions.allSatisfy { fun in
            fun(lowerWord)
        }
        if isSubmitted {
            usedWords.insert(answer, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        }
        showErrorAlert()
    }
    
    private func isCompilable(_ word: String) -> Bool {
        guard var targerWord = navigationItem.title?.lowercased() else { return false }
        for char in word {
            if let index = targerWord.firstIndex(of: char) {
                targerWord.remove(at: index)
            } else {
                alertTitle = "Word not possible"
                alertMessage = "You can't spell that word from \"\(targerWord)\""
                return false
            }
        }
        return true
    }
    
    private func isOriginal(_ word: String) -> Bool {
        if !usedWords.map({ $0.lowercased() }).contains(word) {
            return true
        } else {
            alertTitle = "Word used already"
            alertMessage = "Be more original!"
            return false
        }
    }
    
    private func isReal(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if misspelledRange.location == NSNotFound {
            return true
        } else {
            alertTitle = "Word not recognised"
            alertMessage = "You can't just make them up, you know!"
            return false
        }
    }
    
    private func isLongEnough(_ word: String) -> Bool {
        if word.count > 3 {
            return true
        } else {
            alertTitle = "Word too short"
            alertMessage = "Try something longer"
            return false
        }
    }
    
    private func isNotTargetWord(_ word: String) -> Bool {
        guard let targetWord = navigationItem.title else { return false }
        if word != targetWord.lowercased() {
            return true
        } else {
            alertTitle = "Word is target word"
            alertMessage = "Stop messing around"
            return false
        }
    }
    
    private func showErrorAlert() {
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}
