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
        scoreLabel.backgroundColor = .red
        
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
        cluesLabel.backgroundColor = .green
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
        answersLabel.backgroundColor = .blue
        answersLabel.setContentHuggingPriority(.init(1), for: .vertical)
        
        view.addSubview(answersLabel)
        
        NSLayoutConstraint.activate([
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100)
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
            currentAnswer.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setUpClearSubmit() {
        clearButton = UIButton(type: .system)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.titleLabel?.font = .systemFont(ofSize: 24)
        
        submitButton = UIButton(type: .system)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.titleLabel?.font = .systemFont(ofSize: 24)
        
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
        buttonsView.backgroundColor = .yellow
        
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
                buttonsView.addSubview(button)
                letterButtons.append(button)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

