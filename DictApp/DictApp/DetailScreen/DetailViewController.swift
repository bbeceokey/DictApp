//
//  DetailViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit
import WordsAPI

protocol DetailViewControllerProtocol : AnyObject{
    func setWordName(_ text: String)
    func setWordRead(_ text: String)
    func setUpWordTable()
    func setUpFiltered()
    func setUpSynonyms()
    func getWords() -> Word2
    func getFilterdeLists() -> [String]
    func getDictionary() -> [CustomWord]
    func getSynonyms() -> [SynonymWord]
    func reloadWordTable()
    func reloadFilterTable()
  
}
class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: MeaningTableViewCell.self, for: indexPath)
               let definitionData = presenter.getDefinition(at: indexPath.row)
        cell.cellPresenter = MeaningCellPresenter(view: cell, model: definitionData.definition, partOfSpeech: definitionData.partOfSpeech)
        
               return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filteredCell", for: indexPath) as! FilteredCollectionViewCell
        cell.configFilterCell(filteredList[indexPath.row])
                return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectFilter(indexPath.row)
    }
    
    
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var wordRead: UILabel!
    @IBOutlet weak var filtereledCollection: UICollectionView!
    @IBOutlet weak var wordTable: UITableView!
    @IBOutlet weak var synonymCollections: UICollectionView!
    
    var cswords = [CustomWord]()
    var words = [Word2]()
    var synonyms = [SynonymWord]()
    var filteredList = [String]()
    
    var presenter: DetailPresenterProtocol!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let interactor = DetailInteractor(csWords: cswords) // Initialize the interactor with csWords
        let router = DetailRouter(viewController: self) // Initialize the router
        presenter = DetailPresenter(view: self, router: router as? DetailRouterProtocol, interactor: interactor)
        wordTable.register(MeaningTableViewCell.self, forCellReuseIdentifier: "MeaningTableViewCell")
        //filteredCollectionView.register(UINib(nibName: "FilteredCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
        //let nib = UINib(nibName: "FilteredCell", bundle: nil)
        filtereledCollection.register(UINib(nibName: "FilteredCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filteredCell")
        
       
        presenter.viewDidload()
        presenter.setWordDetail()
        setUpFiltered()
        setUpSynonyms()
        

    }
    
    func filteredListCreate(){
        for part in cswords {
            filteredList.append(part.partOfSpeech)
        }
    }
    
}

extension DetailViewController : DetailViewControllerProtocol{
    func reloadFilterTable() {
        filtereledCollection.reloadData()
    }
    
    func reloadWordTable() {
        wordTable.reloadData()
    }
    
    func setWordName(_ text : String) {
        self.wordName.text = text
    }
    
    func setWordRead(_ text : String) {
        self.wordRead.text = text
    }
    
    func setUpWordTable() {
        wordTable.delegate = self
        wordTable.dataSource = self
        wordTable.reloadData()
        
    }
    
    func setUpFiltered() {
        let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .horizontal // Yatay kaydırma yönünü ayarlayın
                filtereledCollection.setCollectionViewLayout(flowLayout, animated: true)
        filtereledCollection.delegate = self
        filtereledCollection.dataSource = self
        filtereledCollection.reloadData()
    }
    
    func setUpSynonyms() {
        synonymCollections.delegate = self
        synonymCollections.dataSource = self
        synonymCollections.reloadData()
    }
    
    func getWords() -> WordsAPI.Word2 {
        return words[0]
    }
    
    func getFilterdeLists() -> [String] {
        return filteredList
    }
    
    func getDictionary() -> [WordsAPI.CustomWord] {
        return cswords
    }
    
    func getSynonyms() -> [WordsAPI.SynonymWord] {
        return synonyms
    }

}


