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
        // UILabel oluştur
        synonymLabel = UILabel()
               synonymLabel.translatesAutoresizingMaskIntoConstraints = false
               contentView.addSubview(synonymLabel)
               
               // UILabel için constraints belirle
               NSLayoutConstraint.activate([
                   synonymLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                   synonymLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   synonymLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   synonymLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
               ])
               
               // Arka plan rengi ve köşe yuvarlama (radius) ayarla
               contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
               contentView.layer.cornerRadius = 8.0 // İsteğe bağlı: Köşe yuvarlama miktarı
               contentView.clipsToBounds = true 
    }
    
    func synonymConfig(_ text: String){
        synonymLabel.text = text
    }
}
