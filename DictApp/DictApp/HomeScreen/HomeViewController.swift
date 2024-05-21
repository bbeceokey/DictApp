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
    func showAlertDismiss()
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
        if searchWord != "" {
            presenter.searchWord(word: search)
            recentSearches = presenter.fetchRecentSearches()
        } else {
            self.showAlertDismiss()
        }
    }
 
    override func viewDidLoad() {
        recentSearchsTable.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeWordCell")

        recentSearches = presenter.fetchRecentSearches()
        reloadTableView()
        searchBar.delegate = self
        recentSearchsTable.delegate = self
        recentSearchsTable.dataSource = self
        searchBar.becomeFirstResponder()
        originalSearchButtonTopConstraintConstant = buttonTopConstraint.constant
        originalSearchButtonBottomConstraintConstant = buttonBottomConstraint.constant
        
        // Klavye bildirimleri
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Ekrana dokunma tanıyıcısı
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
       
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
    func showAlertDismiss() {
        let alert = UIAlertController(title: nil, message: "Please entry some word", preferredStyle: .alert)
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
        recentSearchsTable.reloadData()
    }
}
