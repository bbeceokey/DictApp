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
        synonymLabel.clipsToBounds = true
        addSubview(synonymLabel)
        synonymLabel.translatesAutoresizingMaskIntoConstraints = false
    
       NSLayoutConstraint.activate([
           synonymLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
           synonymLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           synonymLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           synonymLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
       ])
               
    }
    
    func synonymConfig(_ text: String){
        synonymLabel.text = text
    }
}
