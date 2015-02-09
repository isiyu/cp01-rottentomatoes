//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Siyu Song on 2/7/15.
//  Copyright (c) 2015 Siyu-CodePath. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var moviesTableView: UITableView!
    var moviesArray: NSArray?
    var imageCache = [String : UIImage]()

    @IBOutlet weak var tableViewRefreshControl: UIRefreshControl!

    //var str: String! = self.restorationIdentifier
    //let navController = self.navigationController as UINavigationController!
    var tabIndex = 0
    let rtAPIUrls = [ "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=xv5y28amz3m6pmg6gmjmnrvh",
            "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=xv5y28amz3m6pmg6gmjmnrvh"
        ]
    
    // creating notification button for network issues
    let notificationButton = UIButton.buttonWithType(UIButtonType.System) as UIButton

    
    @IBAction func tableViewRefresh(sender: UIRefreshControl) {
        self.loadTableData()
        self.tableViewRefreshControl?.endRefreshing()
    }
    
    
    func networkIssuesButtonTouched(sender:UIButton!)
    {
        UIView.animateWithDuration(0.3, animations: {
            //self.dunamicButton.removeFromSuperview()
            self.notificationButton.frame = CGRectMake(0, -50, 400, 40)
            }, completion: { finished in
                self.notificationButton.removeFromSuperview()
        })
    }
    
    
    func loadTableData () {
        //self.NotificationUIView.removeFromSuperview()
        
        var parent = self.parentViewController
        var RottenTomatoesURLString = self.rtAPIUrls[self.tabIndex]
        
        let request = NSMutableURLRequest(URL: NSURL(string:RottenTomatoesURLString)!)
        
        
        SVProgressHUD.show()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{(response, data, error) in
            var errorValue:NSError? = nil
            
            if (error == nil && data != nil)  {
                if let d = data {
                    //Only executed if data isn't nil
                    //jsonResults = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
                    let dictionary = NSJSONSerialization.JSONObjectWithData(d, options: nil, error: &errorValue) as NSDictionary
                    self.moviesArray = dictionary["movies"] as NSArray
                    self.tableView.reloadData()
                }
                //let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                //self.moviesArray = dictionary["movies"] as NSArray
                //self.tableView.reloadData()
            }
            else {
                self.notificationButton.backgroundColor = UIColor(red:0.7 , green:0.7 , blue: 0.7 , alpha:0.9)
                //self.notificationButton.b
                self.notificationButton.setTitle("Network Issues", forState: UIControlState.Normal)
                self.notificationButton.frame = CGRectMake(0, -50, 400, 40)
                self.notificationButton.addTarget(self, action: "networkIssuesButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
                
                
                self.view.addSubview(self.notificationButton)
                UIView.animateWithDuration(0.3, animations: {
                    //self.dunamicButton.removeFromSuperview()
                    self.notificationButton.frame = CGRectMake(0, 0, 400, 40)
                })
            }
        })
        SVProgressHUD.dismiss()
        
        //self.NotificationUIView.bringSubviewToFront(self.NotificationUIView)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.tabIndex = appDelegate.tabIndex
        self.loadTableData()
        
        return
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let array = moviesArray{
            return array.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier("com.siyu-codepath.mycell") as MovieTableViewCell
        
        //cell.movieTitleLabel.text = "Row: \(indexPath.row)"
        cell.movieTitleLabel.text = movie["title"] as NSString
        
        // get movie poster url
        let postersDict = movie["posters"] as NSDictionary
        let posterUrlString: NSString = postersDict["thumbnail"] as NSString
        //let imgURL: NSURL? = NSURL(string: posterUrlString)

        // set a placeholder image as the poster
        cell.posterImageView.image = UIImage(named: "loading.gif")
        //return cell
        
        // look for poster in the image cahce
        var posterImage = self.imageCache[posterUrlString]
        
        // if poster doesn't exist, send async request to download it
        if posterImage == nil {
            var imgURL: NSURL = NSURL(string: posterUrlString)!
            
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request , queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
                if error == nil {
                    posterImage = UIImage(data:data)
                    
                    //store image in cache
                    self.imageCache[posterUrlString] = posterImage
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? MovieTableViewCell {
                            cellToUpdate.posterImageView?.image = posterImage
                            cellToUpdate.posterImageView!.alpha = 0
                            UIView.animateWithDuration(0.5, animations: {
                                //self.dunamicButton.removeFromSuperview()
                                //self.notificationButton.frame = CGRectMake(0, 0, 400, 40)
                                cellToUpdate.posterImageView!.alpha = 1
                            })
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? MovieTableViewCell {
                    cellToUpdate.posterImageView?.image = posterImage
                    // poster image animation
                    cellToUpdate.posterImageView!.alpha = 0
                    UIView.animateWithDuration(0.5, animations: {
                        //self.dunamicButton.removeFromSuperview()
                        //self.notificationButton.frame = CGRectMake(0, 0, 400, 40)
                        cellToUpdate.posterImageView!.alpha = 1
                    })
                }

            })
        }
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Did tap row: \(indexPath.row)")
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movieDetailsViewController: MovieDetailsViewController = segue.destinationViewController as MovieDetailsViewController
        var movieIndex = moviesTableView!.indexPathForSelectedRow()!.row
        var selectedMovie = self.moviesArray![movieIndex] as NSDictionary
        movieDetailsViewController.movieDictionary = selectedMovie
        
        let postersDict = selectedMovie["posters"] as NSDictionary
        let posterUrlString: NSString = postersDict["thumbnail"] as NSString
        var posterImage = self.imageCache[posterUrlString]
        // set the movie poster to thumbnail for now
        // if poster doesn't exist, send async request to download it
        if posterImage != nil {
            movieDetailsViewController.incomingThumb = posterImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

