//
//  MeaningTableViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit
import WordsAPI

protocol MeaningTableViewCellProtocol: AnyObject {
    func configMeaningCell(_ model : Word2, defCount: Int)
}
class MeaningTableViewCell: UITableViewCell {

    @IBOutlet weak var example: UILabel!
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        definition.numberOfLines = 0
        example.numberOfLines = 0
        // Initialization code
    }
    var cellPresenter: MeaningCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}

extension MeaningTableViewCell : MeaningTableViewCellProtocol {
    
    func configMeaningCell(_ model : Word2, defCount: Int){
        name.text = "\(defCount) - \(model.meanings?[defCount].partOfSpeech)"
        definition.text = model.meanings?[defCount].definitions[defCount].definition
        if let exampleM = model.meanings?[defCount].definitions[defCount].example{
            example.text = "Example\n \(exampleM)"
        } else {
            example.isHidden = true
        }
       
    }
    
}
