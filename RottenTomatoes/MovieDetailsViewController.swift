//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Siyu Song on 2/7/15.
//  Copyright (c) 2015 Siyu-CodePath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieDictionary: NSDictionary?
    var incomingThumb: UIImage?
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    //Movie info
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieInfoView: UIView!
    
    // tab view controller
    @IBOutlet weak var expandButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviePosterImage.image = self.incomingThumb
        
        self.movieTitleLabel.text = self.movieDictionary?["title"] as NSString
        self.ratingLabel.text = self.movieDictionary?["mpaa_rating"] as NSString
        let run_time : NSNumber = self.movieDictionary?["runtime"] as NSNumber
        self.runtimeLabel.text = run_time.stringValue as NSString + NSString(string:" mins")

        self.synopsisLabel.text = self.movieDictionary?["synopsis"] as NSString
        self.synopsisLabel.sizeToFit()
        
        let tmbPosterURLString : String = self.movieDictionary?["posters"]?["thumbnail"] as String

        let oriPosterURLString = tmbPosterURLString.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg", options: nil, range: nil)

        moviePosterImage.setImageWithURL( NSURL(string:oriPosterURLString)! )
    }

    @IBAction func showButtonPressed(sender: AnyObject) {
        //var buttonText = self.expandButton.titleLabel?.text
        
        
        var ypos = self.movieInfoView.frame.minY
        
        if ypos < 200 {
            self.movieInfoView.frame = CGRectMake(0, 100, 400, 550)
            //self.expandButton.titleLabel?.text = "Hide"
            //self.expandButton.setTitle("Hide", forState: UIControlState.Normal)
        }
            
        else if ypos > 300 {
            self.movieInfoView.frame = CGRectMake(0, 570, 400, 550)
            //self.expandButton.titleLabel?.text = "Show"
            //self.expandButton.setTitle("Show", forState: UIControlState.Normal)
        }
    }
    /*
    @IBAction func showHideButtonPressed(sender: UIButton) {
        var buttonText = self.expandButton.titleLabel?.text
        
        if buttonText == "Show" {
            self.movieInfoView.frame = CGRectMake(0, 100, 400, 550)
            //self.expandButton.titleLabel?.text = "Hide"
            self.expandButton.setTitle("Hide", forState: UIControlState.Normal)
        }
            
        else if buttonText == "Hide" {
            self.movieInfoView.frame = CGRectMake(0, 570, 400, 550)
            //self.expandButton.titleLabel?.text = "Show"
            self.expandButton.setTitle("Show", forState: UIControlState.Normal)
        }
    }
    */
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
