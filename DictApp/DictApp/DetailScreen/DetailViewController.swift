//
//  DetailViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 18.05.2024.
//

import UIKit
import WordsAPI
import AVFoundation

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

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var wordName: UILabel!
    @IBOutlet weak var audioImage: UIImageView!
    @IBOutlet weak var wordRead: UILabel!
    @IBOutlet weak var filtereledCollection: UICollectionView!
    @IBOutlet weak var wordTable: UITableView!
    @IBOutlet weak var synonymCollections: UICollectionView!
    
    var cswords = [CustomWord]()
    var words = [Word2]()
    var synonyms = [SynonymWord]()
    var filteredList = [String]()
    
    var presenter: DetailPresenterProtocol!
    var audioPlayer: AVAudioPlayer?
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(audioImageTapped))
        audioImage.addGestureRecognizer(tapGesture)
        audioImage.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFilterSelectionChange(_:)), name: NSNotification.Name("FilterSelectionChanged"), object: nil)
   
    }
    @objc private func handleFilterSelectionChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let label = userInfo["label"] as? String else { return }
        presenter.updateSelectedFilters(with: label)
}
    
    @objc func audioImageTapped() {
        if let audioURLString = presenter.getAudioURL(), let url = URL(string: audioURLString) {
            downloadAndPlayAudio(from: url)
        } else {
            showAlertWithDismiss()
        }
    }
        
    func downloadAndPlayAudio(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading audio: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: No data received")
                return
            }
            self.playAudio(with: data)
        }
        task.resume()
    }
        
    func playAudio(with data: Data) {
        DispatchQueue.main.async {
            do {
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.audioPlayer?.play()
            } catch let error {
                print("Error playing audio: \(error.localizedDescription)")
            }
        }
    }
    
    func showAlertWithDismiss() {
        let alert = UIAlertController(title: nil, message: "This word does not have a pronunciation audio.", preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        present(alert, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        }
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filtereledCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filteredCell", for: indexPath) as! FilteredCollectionViewCell
            cell.configFilterCell(filteredList[indexPath.row], isSelected: false)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "synonymCell", for: indexPath) as! SynonymCollectionViewCell
            cell.synonymConfig(synonyms[indexPath.row].word ?? "ece")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.updateSelectedFilters(with: presenter.getFilteredWords()[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == synonymCollections{
            let text = synonyms[indexPath.row].word
            let width = collectionView.bounds.width - 20
            return CGSize(width: width, height: 150)
        }
        return CGSize(width: 0, height: 0)
    }
 
    func setUpFiltered() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Yatay yönde kaydırma
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
      
    }
    
    func setUpSynonyms() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: 350, height: 50)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.scrollDirection = .horizontal
        
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
