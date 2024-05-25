//
//  SynonymCollectionViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit

class SynonymCollectionViewCell: UICollectionViewCell {
    var synonymLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {

        synonymLabel = UILabel()
        synonymLabel.textAlignment = .center
        synonymLabel.textColor = .darkText
        synonymLabel.backgroundColor = .systemBlue
        synonymLabel.layer.cornerRadius = 8
        synonymLabel.clipsToBounds = true
        addSubview(synonymLabel)
        synonymLabel.translatesAutoresizingMaskIntoConstraints = false
        synonymLabel.numberOfLines = 0
    
        NSLayoutConstraint.activate([
            synonymLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 25),
            synonymLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 4),
            synonymLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -4),
            synonymLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -25),
             
        ])
        synonymLabel.preferredMaxLayoutWidth = 300
    }

    func synonymConfig(_ text: String){
        synonymLabel.text = text
    }
}
