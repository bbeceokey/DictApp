//
//  HomeViewController.swift
//  DictApp
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
import UIKit
import WordsAPI
import Alamofire
import CoreData


protocol HomeViewControllerProtocol : AnyObject{
    func displayRecentSearches(_ searches: [WordData])
    func reloadTableView()
}
final class HomeViewController: UIViewController {
    var presenter: HomePresenterProtocol!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentSearchsTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    var originalSearchButtonTopConstraintConstant: CGFloat = 0
    var originalSearchButtonBottomConstraintConstant: CGFloat = 0
    private var searchWord : String?
    
    private var recentSearches: [WordData] = []
    @IBAction func SearchClicked(_ sender: Any) {
        guard let search = searchWord else { return }
        presenter.tappledWord(word: search)
    }
    
    override func viewDidLoad() {
        recentSearchsTable.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWordCell")

        recentSearches = presenter.fetchRecentSearches()
        reloadTableView()
        searchBar.delegate = self
        recentSearchsTable.delegate = self
        recentSearchsTable.dataSource = self
        searchBar.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               
        originalSearchButtonTopConstraintConstant = buttonTopConstraint.constant
        originalSearchButtonBottomConstraintConstant = buttonBottomConstraint.constant
       
    }
    deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc func keyboardDidHide() {
            if let searchText = searchBar.text {
                print("Arama metni: \(searchText)")
                searchWord = searchText
            }
        }
    @objc func keyboardWillShow(_ notification: Notification) {
        // Klavyenin boyutunu al
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            // Klavyenin yüksekliğini ve konumunu elde et
            let keyboardHeight = keyboardFrame.size.height
            
            // Arayüzdeki searchButton'un üst ve alt constraint'lerini klavyenin yüksekliği ile güncelle
            let newSearchButtonTopConstraintConstant = originalSearchButtonTopConstraintConstant + keyboardHeight + 50 // İstenilen boşluk (20) eklendi
            let newSearchButtonBottomConstraintConstant = originalSearchButtonBottomConstraintConstant + keyboardHeight + 50 // İstenilen boşluk (20) eklendi
            
            // Animasyon ile searchButton'un constraint'lerini güncelle
            UIView.animate(withDuration: 0.3) {
                self.buttonTopConstraint.constant = newSearchButtonTopConstraintConstant
                self.buttonBottomConstraint.constant = newSearchButtonBottomConstraintConstant
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchWord = query
        presenter.searchWord(word: query)
        recentSearches = presenter.fetchRecentSearches()
        reloadTableView()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard let query = searchBar.text else { return }
        searchWord = query
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentSearches.isEmpty {
            let emptyCell = UITableViewCell()
            emptyCell.textLabel?.text = "Arama yapılmadı"
            emptyCell.textLabel?.textAlignment = .center
            return emptyCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeWordCell", for: indexPath) as! HomeTableViewCell
            cell.cellConfig(recentSearches[indexPath.row])
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let search = recentSearches[indexPath.row].name ?? "ece"

        presenter.tappledWord(word: search)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recentSearches.remove(at: indexPath.row)
            presenter?.deleteRecentSearch(at: indexPath.row)
        }
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func displayRecentSearches(_ searches: [WordData]) {
        self.recentSearches = searches
        reloadTableView()
    }
    func reloadTableView() {
            recentSearchsTable.reloadData()
        }
}
