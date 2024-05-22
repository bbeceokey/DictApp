//
//  FilteredCollectionViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit
import WordsAPI
protocol FilteredCollectionViewCellProtocol: AnyObject {
    func configFilterCell( _ model : String,isSelected: Bool)
}

class FilteredCollectionViewCell: UICollectionViewCell {
    var filteredLabel: UILabel!
    var isSelectedFilter: Bool = false {
        didSet {
            updateLabelAppearance()
        }
    }

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
           filteredLabel.layer.cornerRadius = 8
           filteredLabel.clipsToBounds = true
           addSubview(filteredLabel)
           
          
           filteredLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               filteredLabel.topAnchor.constraint(equalTo: topAnchor),
               filteredLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
               filteredLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
               filteredLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
               filteredLabel.isUserInteractionEnabled = true
               filteredLabel.addGestureRecognizer(tapGesture)
       }
        
        @objc private func labelTapped() {
                isSelectedFilter.toggle()
                updateLabelAppearance()
                NotificationCenter.default.post(name: NSNotification.Name("FilterSelectionChanged"), object: nil, userInfo: ["label": filteredLabel.text ?? "", "isSelected": isSelectedFilter])
            }
            
            private func updateLabelAppearance() {
                filteredLabel.backgroundColor = isSelectedFilter ? .blue : .gray
            }

}
extension FilteredCollectionViewCell : FilteredCollectionViewCellProtocol {
    func configFilterCell(_ model: String, isSelected: Bool) {
        filteredLabel.text = model
        isSelectedFilter = isSelected
    }
    
    
}
