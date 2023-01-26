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
    
    var moviesSource: MoviesSourceProtocol = MoviesSource()
    var cacheManager: CacheProtocol = CacheManager()
    
    var currentSearch: String?
    
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
        view.addSubview(progressView)
        progressView.bringSubviewToFront(view)
        progressView.isHidden = true
    }
    
    func getMovies(search: String, page: Int) {
        showProgressView()
        if page == 1 {
            movies.removeAll()
            collectionView.reloadData()
        }
        moviesSource.getMoviesBySearch(search: search, page: page) { [weak self] (response, error) in
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
        view.isUserInteractionEnabled = false
        progressView.startAnimating()
        progressView.isHidden = false
    }
    
    func hideProgressView(){
        progressView.stopAnimating()
        view.isUserInteractionEnabled = true
        progressView.isHidden = true
    }
    
    func presentAlert(title: String?, message: String = "") {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func startSearch() {
        searchField.resignFirstResponder()
        currentSearch = searchField.text
        page = 1
        getMovies(search: searchField.text ?? "", page: page)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        startSearch()
        return true
    }

    @IBAction func searchButton(_ sender: Any) {
        startSearch()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.id, for: indexPath) as? MovieCell,
            indexPath.row < movies.count {
            cell.setupCell(movie: movies[indexPath.row], cacheManager: cacheManager)
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
