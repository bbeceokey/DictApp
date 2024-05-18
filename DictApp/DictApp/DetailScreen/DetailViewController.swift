//
//  DetailViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit
import WordsAPI

protocol DetailViewControllerProtocol{
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
