//
//  ViewController.swift
//  Project15
//
//  Created by Vladimir on 05.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageView: UIImageView!
    private var currentAnimation = 0
    

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 4){
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -200, y: -200)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        } completion: { animationIsFinished in
            sender.isHidden = false
        }
        currentAnimation = (currentAnimation + 1) % 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: UIImage(resource: .penguin))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }


}

