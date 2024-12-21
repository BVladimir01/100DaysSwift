//
//  ViewController.swift
//  Hangman
//
//  Created by Vladimir on 18.12.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let letterRows = ["qwertyuiop",
                              "asdfghjkl",
                              "zxcvbnm"
    ]
    
    private let maxMistakes = 7
    private var mistakes = 0
    private var mistakeLabels = [UILabel]()
    private var keys = [UIButton]()
    private var targetWord = "targetword"
    private var guessedChars = [Character]()
    private var wordLabel: UILabel!
    private var scoreLabel: UILabel!
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private let wordsFileName = "hangmanWords"
    
    private let fontSize = 30.0
    private let wordFontSize = 40.0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        setUpScoreLabel()
        setUpMistakeLabels()
        setUpKeyBoard()
        setUpTargetWord()
    }
    
    private func setUpScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.text = "Score: 0"
//        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = .systemFont(ofSize: fontSize.cgFloat)
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        scoreLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setUpMistakeLabels() {
        var previousLabel: UILabel? = nil
        for _ in 0..<maxMistakes {
            let newLabel = UILabel()
            newLabel.translatesAutoresizingMaskIntoConstraints = false
            newLabel.text = "_"
//            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.font = .systemFont(ofSize: fontSize.cgFloat)
            newLabel.textColor = .systemGray
            newLabel.textAlignment = .center
            mistakeLabels.append(newLabel)
            view.addSubview(newLabel)
            
            if let previousLabel {
                newLabel.leadingAnchor.constraint(equalTo: previousLabel.trailingAnchor).isActive = true
                newLabel.widthAnchor.constraint(equalTo: previousLabel.widthAnchor).isActive = true
            } else {
                newLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            }
            NSLayoutConstraint.activate([
                newLabel.topAnchor.constraint(equalTo: scoreLabel.topAnchor),
                newLabel.bottomAnchor.constraint(equalTo: scoreLabel.bottomAnchor)
            ])
            
            previousLabel = newLabel
        }
        mistakeLabels.last?.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: mistakeLabels.last!.trailingAnchor).isActive = true
        
    }
    
    private func setUpKeyBoard() {
        
        var previousStack: UIStackView? = nil
        var previousButton: UIButton? = nil
        
        for row in letterRows.reversed() {
            
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.alignment = .center
            view.addSubview(hStack)
            
            NSLayoutConstraint.activate([
                hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                hStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor),
                hStack.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
            if let previousStack {
                NSLayoutConstraint.activate([
                    hStack.bottomAnchor.constraint(equalTo: previousStack.topAnchor),
                    hStack.heightAnchor.constraint(equalTo: previousStack.heightAnchor)
                ])
            } else {
                hStack.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
            }
            
            for char in row {
                let newButton = UIButton(type: .roundedRect)
                newButton.setTitle(String(char), for: .normal)
//                newButton.titleLabel?.adjustsFontSizeToFitWidth = true
                newButton.titleLabel?.font = .systemFont(ofSize: fontSize.cgFloat)
                newButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
                newButton.translatesAutoresizingMaskIntoConstraints = false
                hStack.addArrangedSubview(newButton)
                if let previousButton {
                    NSLayoutConstraint.activate([
                        newButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor),
                        newButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor),
                        newButton.topAnchor.constraint(equalTo: previousButton.topAnchor),
                        newButton.bottomAnchor.constraint(equalTo: previousButton.bottomAnchor)
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        newButton.topAnchor.constraint(equalTo: hStack.topAnchor),
                        newButton.bottomAnchor.constraint(equalTo: hStack.bottomAnchor)
                    ])
                    keys.first?.widthAnchor.constraint(equalTo: newButton.widthAnchor).isActive = true
                }
                keys.append(newButton)
                previousButton = newButton
            }
            previousStack = hStack
            previousButton = nil
        }
        
    }
    
    private func setUpTargetWord() {
//        generateNewWord()
        wordLabel = UILabel()
//        wordLabel.adjustsFontSizeToFitWidth = true
        wordLabel.font = .systemFont(ofSize: wordFontSize.cgFloat)
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = String(repeating: "?", count: targetWord.count)
        view.addSubview(wordLabel)
        NSLayoutConstraint.activate([
            wordLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func generateNewWord() {
        guard let url = Bundle.main.url(forResource: wordsFileName, withExtension: "txt") else { return }
        guard let wordsString = try? String(contentsOf: url) else { return }
        let words = wordsString.components(separatedBy: .whitespacesAndNewlines)
        if let newWord = words.randomElement() {
            targetWord = newWord.lowercased()
        }
    }
    
    @objc
    private func buttonPressed(_ sender: UIButton) {
        defer {
            sender.isEnabled = false
        }
        guard let guessedChar = sender.titleLabel?.text else { return }
        if targetWord.contains(guessedChar) {
            guessedChars.append(Character(guessedChar))
            var newDisplayedWord = ""
            for char in targetWord {
                if guessedChars.contains(char) {
                    newDisplayedWord.append(String(char))
                    score += (char == Character(guessedChar)) ? 1 : 0
                } else {
                    newDisplayedWord.append("?")
                }
            }
            wordLabel.text = newDisplayedWord
            if newDisplayedWord == targetWord {
                presentNewLevel()
            }
        } else {
            if mistakes == maxMistakes {
                presentGameOver()
                return
            }
            mistakeLabels[mistakes].text = guessedChar
            mistakeLabels[mistakes].textColor = .systemRed
            mistakes += 1
        }
    }
    
    private func presentGameOver() {
        let ac = UIAlertController(title: "Game over", message: "You made too much mistakes", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "NewGame", style: .default) { [weak self] action in
            self?.score = 0
            self?.newGame()
        })
        present(ac, animated: true)
    }
    
    private func presentNewLevel() {
        let ac = UIAlertController(title: "Well done", message: "You guessed the whole word", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Next word!", style: .default) { [weak self] action in
            self?.newGame()
        })
        present(ac, animated: true)
    }
    
    private func newGame() {
        for key in keys {
            key.isEnabled = true
        }
        generateNewWord()
        wordLabel.text = String(repeating: "?", count: targetWord.count)
        guessedChars.removeAll()
        mistakes = 0
        for mistakeLabel in mistakeLabels {
            mistakeLabel.text = "_"
            mistakeLabel.textColor = .systemGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        generateNewWord()
    }

}

