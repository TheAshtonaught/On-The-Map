//
//  StudentCell.swift
//  OnTheMap
//
//  Created by Ashton Morgan on 11/16/16.
//  Copyright © 2016 algebet. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {

    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func setCell(_ location: StudentLocation) {
        pinImage.image = UIImage(named: "pin")
        nameLabel.text = "\(location._student.firstName) \(location._student.lastName)"
        urlLabel.text = location._student.mediaUrl
    }

    

}
