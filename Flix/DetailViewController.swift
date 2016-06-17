//
//  DetailViewController.swift
//  Flix
//
//  Created by Devshi Mehrotra on 6/17/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        let baseURL = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: baseURL + posterPath)
            posterImageView.setImageWithURL(posterURL!)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    @IBAction func openURL(sender: AnyObject) {
        let baseURL = "https://rottentomatoes.com/m/"
        let title = movie["title"] as? String
        
        let noDash = title!.stringByReplacingOccurrencesOfString("-", withString: " ")
        let noSpaces = noDash.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let noPeriod = noSpaces.stringByReplacingOccurrencesOfString(".", withString: "")
        let noComma = noPeriod.stringByReplacingOccurrencesOfString(",", withString: "")
        let modTitle = noComma.stringByReplacingOccurrencesOfString(":", withString: "")
        print("TITLE: \(modTitle)")
        let url = NSURL(string: baseURL + modTitle)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
