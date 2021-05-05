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
    
    let progressView = UIActivityIndicatorView()
    var movies: [Movie] = []
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        #if DEBUG
        searchField.text = "Fast"
        getMovies(search: "Fast", page: page)
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
        
        progressView.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        progressView.center = view.center
    }
    
    func getMovies(search: String, page: Int) {
        showProgressView()
        if page == 1 {
            movies.removeAll()
            collectionView.reloadData()
        }
        ApiManager.getMoviesBySearch(search: search, page: page) { [weak self] (response, error) in
            if let error = error {
                self?.presentAlert(title: error.localizedDescription)
            } else if let response = response {
                self?.movies.append(contentsOf: response)
                self?.collectionView.reloadData()
            }
            self?.hideProgressView()
        }
    }
    
    func showProgressView(){
        view.addSubview(progressView)
        view.isUserInteractionEnabled = false
        progressView.bringSubviewToFront(view)
        progressView.startAnimating()
    }
    
    func hideProgressView(){
        progressView.stopAnimating()
        view.isUserInteractionEnabled = true
        progressView.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        page = 1
        getMovies(search: searchField.text ?? "", page: page)
        return true
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchField.resignFirstResponder()
        page = 1
        getMovies(search: searchField.text ?? "", page: page)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell, indexPath.row < movies.count {
            cell.setupCell(movie: movies[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 4 {
            page += 1
            getMovies(search: searchField.text ?? "", page: page)
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
