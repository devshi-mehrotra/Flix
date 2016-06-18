//
//  MoviesViewController.swift
//  Flix
//
//  Created by Devshi Mehrotra on 6/15/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    //var data: [String]?
    //var filteredData: [String]?
    
    var endpoint: String!
    //var modif: String!
    var modify: Double!
    
    var tableData = ["one", "two", "three", "four", "six", "seven", "eight", "nine", "ten"]
    var request: NSURLRequest!
    var movies: [NSDictionary]!
    var filteredMovies: [NSDictionary]!
    
    func colorForIndex(index: Int) -> UIColor {
        
        let itemCount = tableData.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.35
        let blueColor = CGFloat(modify)
        return UIColor(red: 0.7, green: color, blue: blueColor, alpha: 1.0)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        refreshControlAction(refreshControl)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        //filteredMovies = movies
        
        // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil
            {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary
                {
                    print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.filteredMovies = self.movies
                    
                }
            
            }
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        });
  
        task.resume()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0;
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat(0.816),
            green: CGFloat(0.325),
            blue: CGFloat(0.251),
            alpha: CGFloat(1.0)
        )
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColorFromRGB(0x209624)
        cell.selectedBackgroundView = backgroundView
        
        
        
        let movie = filteredMovies![indexPath.row]
        //let title = movie["title"] as! String
        
        //let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        
            //addition
            /*let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
            let request = NSURLRequest(
                URL: url!,
                cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
                timeoutInterval: 10)
        
            cell.posterView.setImageWithURLRequest(
                request,
                placeholderImage: nil,
                success: { (request, imageResponse, image) -> Void in
                
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        UIView.animateWithDuration(0.3, animations: { () ->     Void in
                            cell.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.image = image
                    }
                },
                failure: { (request, imageResponse, error) -> Void in
                    // do something for the failure condition
            })*/
        
        
           //cell.titleLabel.text = title
        
           //cell.overviewLabel.text = overview
        }
        
        //print("\(overview)")
        print("row \(indexPath.row)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBar(searchBar:UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredMovies = movies!.filter({(dataItem: NSDictionary) -> Bool in
                let title = dataItem["title"] as! String
                // If dataItem matches the searchText, return true to include it
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    print("\(title)")
                    return true
                } else {
                    return false
                }
            })
        }
        print("\(filteredMovies)")
        print("SEARCH BAR")
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = filteredMovies[indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
