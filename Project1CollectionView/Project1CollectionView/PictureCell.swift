//
//  PictureCell.swift
//  Project1CollectionView
//
//  Created by Vladimir on 22.12.2024.
//

import UIKit

class PictureCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 50),
            contentView.heightAnchor.constraint(equalToConstant: 140),
            textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        textLabel.numberOfLines = 0
        textLabel.textColor = .black
        contentView.backgroundColor = .gray
    }
}
