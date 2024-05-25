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
    func showAlertDismiss(text : String)
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
        guard let search = searchWord?.trimmingCharacters(in: .whitespacesAndNewlines), !search.isEmpty else {
            self.showAlertDismiss(text:"Please some word.")
            return }
        if searchWord != "" {
            presenter.searchWord(word: search)
            recentSearches = presenter.fetchRecentSearches()
            reloadTableView()
        } else {
            self.showAlertDismiss(text:"Please some word.")
        }
    }
    
    override func viewDidLoad() {
        // supersiz memory leakler
        recentSearchsTable.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWordCell")
        
        recentSearches = presenter.fetchRecentSearches()
        recentSearchsTable.isUserInteractionEnabled = true
        reloadTableView()
        searchBar.delegate = self
        recentSearchsTable.delegate = self
        recentSearchsTable.dataSource = self
        //searchBar.delegate = self
        searchBar.becomeFirstResponder()
        originalSearchButtonTopConstraintConstant = buttonTopConstraint.constant
        originalSearchButtonBottomConstraintConstant = buttonBottomConstraint.constant
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Bu satır, bu jestle birlikte diğer jestlerin tanınmasına izin verir.
        view.addGestureRecognizer(tapGesture) // Tablonun bulunduğu view'e ekleyin.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            buttonBottomConstraint.constant = keyboardFrame.height + 2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        buttonBottomConstraint.constant = 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchWord = query
        presenter.searchWord(word: query)
        recentSearches = presenter.fetchRecentSearches()
        dismissKeyboard()
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
        guard let search = recentSearches[indexPath.row].name else { return }
        presenter.tappledWord(word: search)
        reloadTableView()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recentSearches.remove(at: indexPath.row)
            presenter?.deleteRecentSearch(at: indexPath.row)
            reloadTableView()
        }
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func showAlertDismiss(text : String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        present(alert, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                alert.dismiss(animated: true, completion: nil)
            }
        }
     }
    
    func displayRecentSearches(_ searches: [WordData]) {
        self.recentSearches = searches
        reloadTableView()
    }
    
    func reloadTableView() {
        self.recentSearches = presenter.fetchRecentSearches()
        recentSearchsTable.reloadData()
    }
}
