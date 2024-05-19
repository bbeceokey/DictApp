//
//  DetailViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit
import WordsAPI

protocol DetailViewControllerProtocol{
    func setWordName()
    func setWordRead()
    func setUpWordTable()
    func setUpFiltered()
    func setUpSynonyms()
    
}
class DetailViewController: UIViewController {
    
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var wordRead: UILabel!
    @IBOutlet weak var filtereledCollection: UICollectionView!
    @IBOutlet weak var wordTable: UITableView!
    @IBOutlet weak var synonymCollections: UICollectionView!
    
    var words : [Word2]?
    var synonyms : [SynonymWord]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension DetailViewController : DetailViewControllerProtocol {
    func setWordName() {
        wordName.text = words?[0].word?.capitalized
    }
    
    func setWordRead() {
        wordRead.text = words?[0].phonetics?[0].text
    }
    
    func setUpWordTable() {
        <#code#>
    }
    
    func setUpFiltered() {
        <#code#>
    }
    
    func setUpSynonyms() {
        <#code#>
    }
    
    
}
