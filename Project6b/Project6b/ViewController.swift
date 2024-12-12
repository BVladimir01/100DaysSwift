//
//  ViewController.swift
//  Project6и
//
//  Created by Vladimir on 12.12.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let labelStrings = "THESE ARE SOME AWESOME LABELS".components(separatedBy: " ")
        let colors: [UIColor] = [.red, .cyan, .yellow, .green, .orange]
        var labelViews = [UILabel]()
        var labelDict = [String: UILabel]()
        
        for (i, string) in labelStrings.enumerated() {
            let label = UILabel()
            label.backgroundColor = colors[i]
            label.text = string
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            view.addSubview(label)
            labelViews.append(label)
            labelDict["label\(i + 1)"] = label
        }
        
//        for labelName in labelDict.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(labelName)]|", options: [], metrics: nil, views: labelDict))
//        }
//        let metrics = ["labelHeight": 88]
        let labelHeight = 30.0
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=50)-|", metrics: metrics, views: labelDict))
        var previous: UILabel? = nil
        var spread = [NSLayoutConstraint]()
        var cramped = [NSLayoutConstraint]()
        for label in labelViews {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            spread.append(label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -20))
            cramped.append(label.heightAnchor.constraint(equalToConstant: labelHeight))
            if let previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 20).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            }
            previous = label
        }
        NSLayoutConstraint.activate(cramped)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else {
                print("fail")
                return
            }
            UIView.animate(withDuration: 1.0) {
                NSLayoutConstraint.deactivate(cramped)
                NSLayoutConstraint.activate(spread)
                self.view.layoutIfNeeded()
            }
        }
    }


}

