//
//  HomeTableViewCell.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var wordSearchName: UILabel!
    @IBOutlet weak var serachIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellConfig(_ model : WordData){
        wordSearchName.text = model.name?.capitalized
    }

   
    
}
