//
//  MovieCell.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 20.04.2021.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {
    
    static let identifier = String(describing: MovieCell.self)
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet private var posterImageView: UIImageView!
    @IBOutlet private var ratingContainer: UIView!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var movieTitleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    
    public var movie : MovieEntity.Movie? {
        didSet{
            if let movie = movie{

                guard let poster = movie.poster else {
                    print("... poster nil")
                    return
                }
                
                let url = URL(string: "https://image.tmdb.org/t/p/w300\(poster)")
                let processor = DownsamplingImageProcessor(size: posterImageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
                posterImageView.kf.indicatorType = .activity
                posterImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(3)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
                ratingLabel.text = "\(movie.rating)"
                movieTitleLabel.text = movie.title
                releaseDateLabel.text = movie.releaseDate
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        posterImageView.layer.cornerRadius = 12
        posterImageView.layer.masksToBounds = true
        ratingContainer.layer.cornerRadius = 20
        ratingContainer.layer.masksToBounds = true
    }

}
