//
//  MovieCell.swift
//  Flix
//
//  Created by Devshi Mehrotra on 6/15/16.
//  Copyright © 2016 Devshi Mehrotra. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet weak var posterView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
