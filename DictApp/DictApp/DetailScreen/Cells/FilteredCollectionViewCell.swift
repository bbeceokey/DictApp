//
//  FilteredCollectionViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit
import WordsAPI
protocol FilteredCollectionViewCellProtocol: AnyObject {
    func configFilterCell( _ model : String)
}

class FilteredCollectionViewCell: UICollectionViewCell {
    var filteredLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        // Initialization code
    }
    var filtercellPresenter: FilteredCellPresenterProtocol! {
        didSet {
            filtercellPresenter.load()
        }
    }
    
    private func setupSubviews() {
           // UILabel oluştur
           filteredLabel = UILabel()
           filteredLabel.textAlignment = .center
           filteredLabel.textColor = .black
           filteredLabel.backgroundColor = .gray
           filteredLabel.layer.cornerRadius = 8 // Köşeleri yuvarla
           filteredLabel.clipsToBounds = true // Kesme özelliğini etkinleştir
           addSubview(filteredLabel)
           
           // UILabel'in constraints'larını ayarla
           filteredLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               filteredLabel.topAnchor.constraint(equalTo: topAnchor),
               filteredLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
               filteredLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
               filteredLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
       }

}
extension FilteredCollectionViewCell : FilteredCollectionViewCellProtocol {
    func configFilterCell(_ model: String) {
        filteredLabel.text = model
    }
    
    
}
