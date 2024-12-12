//
//  ViewController.swift
//  Project6a
//
//  Created by Vladimir on 12.12.2024.
//

import UIKit

class ViewController: UIViewController {

    private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    private var score = 0 {
        didSet {
            score = max(score, 0)
        }
    }
    private var correctAnswer = 0
    private var questionsAnswered = 0
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var button2: UIButton!
    @IBOutlet private weak var button3: UIButton!
    
    private var buttons: [UIButton] {
        [button1, button2, button3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreTapped))
            button.imageView?.contentMode = .scaleAspectFit
        }
        askQuestion()
    }

    private func askQuestion(_ action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "What flag is \(countries[correctAnswer].capitalized)? Score: \(score)/\(questionsAnswered)"
        for (i, button) in buttons.enumerated() {
            button.setImage(UIImage(named: countries[i]), for: .normal)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        var message: String
        questionsAnswered += 1
        if sender.tag == correctAnswer {
            score += 1
            alertTitle = "Correct"
            message = "Your score is \(score)"
            title = "What flag is \(countries[correctAnswer].capitalized)? Score: \(score)/\(questionsAnswered)"
        } else {
            score -= 1
            alertTitle = "Wrong"
            message = "That is the flag of \(countries[sender.tag].capitalized)\n Your score is \(score)"
            title = "What flag is \(countries[correctAnswer].capitalized)? Score: \(score)/\(questionsAnswered)"
        }
        if questionsAnswered == 5 {
            alertTitle = "Game is over"
            message = "Your final score is \(score)"
            title = "What flag is \(countries[correctAnswer].capitalized)? Score: \(score)/\(questionsAnswered)"
            questionsAnswered = 0
            score = 0
        }
        
        let ac = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    @objc
    private func scoreTapped() {
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(.init(title: "Continue", style: .default))
        present(ac, animated: true)
    }
}
