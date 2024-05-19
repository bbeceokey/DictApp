//
//  MeaningTableViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 19.05.2024.
//

import UIKit
import WordsAPI

protocol MeaningTableViewCellProtocol: AnyObject {
    func configMeaningCell(_ model : CustomDefinition , partOfSpeech: String)
}
class MeaningTableViewCell: UITableViewCell {

    @IBOutlet weak var example: UILabel!
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var speechName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        definition.numberOfLines = 0
        example.numberOfLines = 0
     
    }
    
    
    var cellPresenter: MeaningCellPresenterProtocol! {
        didSet {
            cellPresenter.load()
        }
    }

}

extension MeaningTableViewCell : MeaningTableViewCellProtocol {
    func configMeaningCell(_ model: CustomDefinition, partOfSpeech: String) {
        /*example.text = model.example
        definition.text = model.definition
        speechName.text = partOfSpeech*/
       
    }
    
}
