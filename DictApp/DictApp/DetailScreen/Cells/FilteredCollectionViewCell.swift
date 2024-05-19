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

    @IBOutlet weak var filteredLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
extension FilteredCollectionViewCell : FilteredCollectionViewCellProtocol {
    func configFilterCell(_ model: String) {
        filteredLabel.text = model
    }
    
    
}
