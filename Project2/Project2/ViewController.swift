//
//  ViewController.swift
//  Project2
//
//  Created by Vladimir on 03.12.2024.
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
        var title: String
        var message: String
        questionsAnswered += 1
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct"
            message = "Your score is \(score)"
        } else {
            score -= 1
            title = "Wrong"
            message = "That is the flag of \(countries[sender.tag].capitalized)\n Your score is \(score)"
        }
        if questionsAnswered == 5 {
            title = "Game is over"
            message = "Your final score is \(score)"
            questionsAnswered = 0
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
}

