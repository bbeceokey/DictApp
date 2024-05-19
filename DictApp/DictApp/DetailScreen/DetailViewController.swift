//
//  DetailViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit
import WordsAPI

protocol DetailViewControllerProtocol: AnyObject {
    func setWordName(_ text: String)
    func setWordRead(_ text: String)
    func setUpWordTable()
    func setUpFiltered()
    func setUpSynonyms()
    func getWords() -> Word2
    func getFilteredLists() -> [String]
    func getDictionary() -> [CustomWord]
    func getSynonyms() -> [SynonymWord]
    func reloadWordTable()
    func reloadFilterTable()
}

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
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
        presenter = DetailPresenter(view: self, router: router, interactor: interactor)
        
        wordTable.register(MeaningTableViewCell.self, forCellReuseIdentifier: "MeaningTableViewCell")
        filtereledCollection.register(UINib(nibName: "FilteredCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filteredCell")
        synonymCollections.register(UINib(nibName: "SynonymCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "synonymCell")
        
        wordTable.delegate = self
        wordTable.dataSource = self
        
        filtereledCollection.delegate = self
        filtereledCollection.dataSource = self
        
        synonymCollections.delegate = self
        synonymCollections.dataSource = self
        
        presenter.viewDidload()
        presenter.setWordDetail()
        
        wordTable.reloadData()
        filtereledCollection.reloadData()
        synonymCollections.reloadData()
        
        setUpFiltered()
        setUpSynonyms()
        
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTable()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeaningTableViewCell", for: indexPath) as! MeaningTableViewCell
        let definitionData = presenter.getDefinition(at: indexPath.row)
        cell.cellPresenter = MeaningCellPresenter(view: cell, model: definitionData.definition, partOfSpeech: definitionData.partOfSpeech)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtereledCollection {
            return presenter.numberOfFilter()
        } else if collectionView == synonymCollections {
           
            return presenter.getSynonyms().count
            
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filtereledCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filteredCell", for: indexPath) as! FilteredCollectionViewCell
            cell.configFilterCell(filteredList[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "synonymCell", for: indexPath) as! SynonymCollectionViewCell
            cell.synonymConfig(synonyms[indexPath.row].word ?? "ece")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectFilter(indexPath.row)
    }
   
       
      
    
    func setUpFiltered() {
        let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .horizontal // Yatay yönde kaydırma
       layout.itemSize = UICollectionViewFlowLayout.automaticSize // Otomatik hücre boyutu
       layout.minimumInteritemSpacing = 10 // Minimum aralık ayarı
       layout.minimumLineSpacing = 10 // Minimum satır aralığı ayarı
       synonymCollections.collectionViewLayout = layout
    }
    
    func setUpSynonyms() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        synonymCollections.setCollectionViewLayout(flowLayout, animated: true)
    }
}

extension DetailViewController: DetailViewControllerProtocol {
    func reloadFilterTable() {
        filtereledCollection.reloadData()
    }
    
    func reloadWordTable() {
        wordTable.reloadData()
    }
    
    func setWordName(_ text: String) {
        self.wordName.text = text
    }
    
    func setWordRead(_ text: String) {
        self.wordRead.text = text
    }
    
    func setUpWordTable() {
        wordTable.delegate = self
        wordTable.dataSource = self
        wordTable.reloadData()
    }
    
    func getWords() -> Word2 {
        return words[0]
    }
    
    func getFilteredLists() -> [String] {
        var list = [String]()
        for x in cswords {
            list.append(x.partOfSpeech)
        }
        filteredList = list
        return filteredList
    }
    
    func getDictionary() -> [CustomWord] {
        return cswords
    }
    
    func getSynonyms() -> [SynonymWord] {
        return synonyms
    }
}
