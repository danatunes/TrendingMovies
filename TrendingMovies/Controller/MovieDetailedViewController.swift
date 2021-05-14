//
//  MovieDetailedViewController.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 23.04.2021.
//

import UIKit
import Alamofire
import Kingfisher

class MovieDetailedViewController: UIViewController {
    
    public var idOfMovie : Int?
    //private let DETAILED_MOVIE_URL = "https://api.themoviedb.org/3/movie/399566?api_key=9ece5d65fc09b295528a6680acfcc58b&language=en-US"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var rattingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goBackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingView.layer.cornerRadius = 20
        ratingView.layer.masksToBounds = true
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        goBackButton.layer.cornerRadius = 10
        getDetailedInformation()
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    private func getDetailedInformation(){
        if let id = idOfMovie{
        AF.request("\(Constants.DETAILED_MOVIE_URL)\(id)\(Constants.API_KEY)", method: .get, parameters: [:]).responseJSON { (response) in
            switch response.result {
            case .success :
                
                if let data = response.data {
                    do{
                        
                        let movieJSON = try JSONDecoder().decode(MovieDetailedEntity.self, from: data)
                        var movie : MovieDetailedEntity?
                        movie = movieJSON
                        if let movie = movie{
                            self.setData(movie)
                        }
                        
                        //                        print(".... \(movie)")
                    }catch let JSONError{
                        print(JSONError)
                    }
                }
            case .failure :
                print("TRENDING_MOVIES_URL retrive data")
            }
        }
    }
    }
    
    
    private func setData(_ movie : MovieDetailedEntity){
        
        guard let poster = movie.poster else {
            print("... poster nil")
            return
        }
        
        let url = URL(string: "https://image.tmdb.org/t/p/w300\(poster)")
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
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
        
        rattingLabel.text = "\(movie.rating)"
        titleLabel.text = movie.title
        releaseDate.text = movie.releaseDate
        descriptionLabel.text = movie.description
    }
}

