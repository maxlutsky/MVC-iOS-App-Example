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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(movie: Movie) {
        widthConstraint.constant = UIConstants.movieCellWidth
        movieTitle.text = movie.Title
        if let imageUrl = movie.Poster {
            ApiManager.getImageDataFromURL(url: imageUrl) { [weak self] (data) in
                if let data = data {
                    self?.movieImage.image = UIImage(data: data)
                }
            }
        }
        movieImage.contentMode = .scaleAspectFill
        movieImage.layer.cornerRadius = UIConstants.cornerRadius
        movieView.layer.cornerRadius = UIConstants.cornerRadius
    }
}
