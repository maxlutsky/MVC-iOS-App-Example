//
//  MovieCell.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieView: UIView!
    
    private var moviePosterUrl: String = ""
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
        movieTitle.text = ""
        moviePosterUrl = ""
    }
    
    func setupCell(movie: Movie, cacheManager: CacheProtocol) {
        widthConstraint.constant = UIConstants.movieCellWidth
        movieTitle.text = movie.title
        
        if let imageUrl = movie.poster {
            moviePosterUrl = imageUrl
            cacheManager.getImageDataFromURL(url: imageUrl) { [weak self] (data, posterUrl) in
                if let data = data,
                   self?.moviePosterUrl == posterUrl {
                    self?.movieImage.image = UIImage(data: data)
                }
            }
        }
        movieImage.contentMode = .scaleAspectFill
        movieImage.layer.cornerRadius = UIConstants.cornerRadius
        movieView.layer.cornerRadius = UIConstants.cornerRadius
    }
}
