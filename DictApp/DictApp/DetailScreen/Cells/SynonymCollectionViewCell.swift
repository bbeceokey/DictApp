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
        synonymLabel.textColor = .black
        synonymLabel.backgroundColor = .gray
        synonymLabel.layer.cornerRadius = 8
        synonymLabel.clipsToBounds = false
        addSubview(synonymLabel)
        synonymLabel.translatesAutoresizingMaskIntoConstraints = false
        synonymLabel.numberOfLines = 0
    
       
        
        NSLayoutConstraint.activate([
            synonymLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            synonymLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            synonymLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            synonymLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             // Activate the width constraint
        ])
        
        // Set preferredMaxLayoutWidth to enable multiline support
        synonymLabel.preferredMaxLayoutWidth = 300
        // set the same value as the maximum width constraint
    }

    
    func synonymConfig(_ text: String){
        synonymLabel.text = text
    }
}
