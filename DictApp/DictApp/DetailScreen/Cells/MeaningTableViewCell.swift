//
//  MeaningTableViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit
import WordsAPI

protocol MeaningTableViewCellProtocol: AnyObject {
    func configMeaningCell(_ model: CustomDefinition, partOfSpeech: String)
}

class MeaningTableViewCell: UITableViewCell {
    
    var exampleLabel: UILabel!
    var definitionLabel: UILabel!
    var speechNameLabel: UILabel!
    
    var cellPresenter: MeaningCellPresenterProtocol! {
            didSet {
                cellPresenter.load()
            }
        }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        // UILabel'leri oluştur
        exampleLabel = UILabel()
        exampleLabel.numberOfLines = 0
        exampleLabel.font = UIFont.systemFont(ofSize: 14) // Silik font
        contentView.addSubview(exampleLabel)
        
        definitionLabel = UILabel()
        definitionLabel.numberOfLines = 0
        contentView.addSubview(definitionLabel)
        
        speechNameLabel = UILabel()
        speechNameLabel.font = UIFont.boldSystemFont(ofSize: 16) // Kalın font
        contentView.addSubview(speechNameLabel)
        
        // Constraints'leri ayarla
        exampleLabel.translatesAutoresizingMaskIntoConstraints = false
        definitionLabel.translatesAutoresizingMaskIntoConstraints = false
        speechNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            speechNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            speechNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            speechNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            definitionLabel.topAnchor.constraint(equalTo: speechNameLabel.bottomAnchor, constant: 8),
            definitionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            definitionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            exampleLabel.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 8),
            exampleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            exampleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            exampleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension MeaningTableViewCell: MeaningTableViewCellProtocol {
    func configMeaningCell(_ model: CustomDefinition, partOfSpeech: String) {
        exampleLabel.text = model.example
        definitionLabel.text = model.definition
        speechNameLabel.text = partOfSpeech
    }
}
