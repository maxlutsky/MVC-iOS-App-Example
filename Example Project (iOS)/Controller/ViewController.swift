//
//  ViewController.swift
//  Example Project (iOS)
//
//  Created by Max on 29/04/2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchField: TextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        #if DEBUG
        getMovies(search: "Fast")
        #endif
    }
    
    func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchField.becomeFirstResponder()
        searchField.delegate = self
        searchButton.layer.cornerRadius = UIConstants.cornerRadius
        searchField.layer.cornerRadius = UIConstants.cornerRadius
        searchField.attributedPlaceholder = NSAttributedString(string: "Enter the name of a movie",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func getMovies(search: String) {
        
        ApiManager.getMoviesBySearch(search: search) { [weak self] (response, error) in
            if let error = error {
                self?.presentAlert(title: error.localizedDescription)
            } else if let response = response {
                self?.movies = response
                self?.collectionView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        getMovies(search: searchField.text ?? "")
        return true
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchField.resignFirstResponder()
        getMovies(search: searchField.text ?? "")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            
            cell.setupCell(movie: movies[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}

extension ViewController {
    func presentAlert(title: String?, message: String = "") {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
