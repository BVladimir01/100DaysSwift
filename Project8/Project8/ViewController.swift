//
//  ViewController.swift
//  Project8
//
//  Created by Vladimir on 17.12.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var cluesLabel: UILabel!
    private var answersLabel: UILabel!
    private var currentAnswer: UITextField!
    private var scoreLabel: UILabel!
    private var letterButtons = [UIButton]()
    private var clearButton: UIButton!
    private var submitButton: UIButton!
    
    private var activatedButtons = [UIButton]()
    private var score = 0 {
        didSet {
            score = max(score, 0)
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var level = 1
    private var solutions = [String]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        setUpScoreLabel()
        setUpClues()
        setUpAnswers()
        setUpCurrentAnswer()
        setUpClearSubmit()
        setUpButtons()
    }
    
    private func setUpScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        scoreLabel.textAlignment = .right
        scoreLabel.font = .systemFont(ofSize: 24)
        scoreLabel.numberOfLines = 0
        
        view.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpClues() {
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES"
        cluesLabel.font = .systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(.init(1), for: .vertical)
        
        view.addSubview(cluesLabel)
        
        NSLayoutConstraint.activate([
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100)
        ])
    }
    
    private func setUpAnswers() {
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.text = "ANSWERS"
        answersLabel.font = .systemFont(ofSize: 24)
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(.init(1), for: .vertical)
        
        view.addSubview(answersLabel)
        
        NSLayoutConstraint.activate([
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answersLabel.bottomAnchor.constraint(equalTo: cluesLabel.bottomAnchor)
        ])
    }
    
    private func setUpCurrentAnswer() {
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = .systemFont(ofSize: 44)
        
        view.addSubview(currentAnswer)
        
        NSLayoutConstraint.activate([
            currentAnswer.topAnchor.constraint(equalTo: answersLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1)
        ])
    }
    
    private func setUpClearSubmit() {
        clearButton = UIButton(type: .system)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.titleLabel?.font = .systemFont(ofSize: 24)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.titleLabel?.font = .systemFont(ofSize: 24)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(clearButton)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            submitButton.topAnchor.constraint(equalTo: clearButton.topAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100)
        ])
    }
    
    private func setUpButtons() {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        for row in 0..<4 {
            for col in 0..<5 {
                let button = UIButton(type: .system)
                button.setTitle("WWW", for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 36)
                button.frame = CGRect(x: width*col, y: height*row, width: width, height: height)
                button.layer.cornerRadius = 20
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.gray.cgColor
                button.addTarget(self, action: #selector(lettersTapped), for: .touchUpInside)
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    private func loadLevel() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var cluesString = ""
            var solutionString = ""
            var lettersBits = [String]()
            
            guard let gameFileURL = Bundle.main.url(forResource: "level\(self.level)", withExtension: "txt") else { return }
            guard let gameFileString = try? String(contentsOf: gameFileURL) else { return }
            
            for (i, question) in gameFileString.components(separatedBy: "\n").shuffled().enumerated() {
                let contents = question.components(separatedBy: ": ")
                let separatedAnswer = contents[0]
                let answer = separatedAnswer.replacingOccurrences(of: "|", with: "")
                let clue = contents[1]
                
                cluesString += ("\(i + 1). \(clue)\n")
                solutionString += "\(answer.count) letters\n"
                self.solutions.append(answer)
                let answerBits = separatedAnswer.components(separatedBy: "|")
                lettersBits.append(contentsOf: answerBits)
            }
            self.updateUIAfterGameLoaded(cluesString: cluesString, answersString: solutionString, lettersBits: lettersBits.shuffled())
        }
    }

    private func updateUIAfterGameLoaded(cluesString: String, answersString: String, lettersBits: [String]) {
        DispatchQueue.main.async {
            self.cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answersLabel.text = answersString.trimmingCharacters(in: .whitespacesAndNewlines)
            if lettersBits.count == self.letterButtons.count {
                for i in 0..<lettersBits.count {
                    self.letterButtons[i].setTitle(lettersBits[i], for: .normal)
                }
            }
        }
    }
    
    @objc
    private func clearTapped(_ sender: UIButton? = nil) {
        currentAnswer.text = nil
        for button in activatedButtons {
//            button.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
            }
        }
        activatedButtons.removeAll()
    }
    
    @objc
    private func submitTapped(_ sender: UIButton? = nil) {
        defer {
            activatedButtons.removeAll()
            currentAnswer.text = nil
        }
        guard let guessedWord = currentAnswer.text, guessedWord != "" else { return }
        guard let answersText = answersLabel.text else { return }
        guard let guessedIndex = solutions.firstIndex(of: guessedWord) else {
            for button in activatedButtons {
//                button.isEnabled = true
                UIView.animate(withDuration: 0.3) {
                    button.alpha = 1
                }
            }
            showUnsuccessfulSubmit(for: guessedWord)
            score -= 1
            return
        }
        var answersTextArray = answersText.components(separatedBy: "\n")
        answersTextArray[guessedIndex] = guessedWord
        answersLabel.text = answersTextArray.joined(separator: "\n")
        score += 1
        let gameIsOver = letterButtons.allSatisfy({!$0.isEnabled})
        if gameIsOver {
            let ac = UIAlertController(title: "Congrats!", message: "You completed level \(level)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
        
    }
    
    private func showUnsuccessfulSubmit(for word: String) {
        let ac = UIAlertController(title: "Wrong guess", message: "Word '\(word)' is not the answer", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func levelUp(alertAction: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        for button in letterButtons {
//            button.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1
            }
        }
    }

    @objc
    private func lettersTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text?.append(buttonTitle)
//        sender.isEnabled = false
        UIView.animate(withDuration: 0.3) {
            sender.alpha = 0
        }
        activatedButtons.append(sender)
    }
}

