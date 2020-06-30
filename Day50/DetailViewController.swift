//
//  DetailViewController.swift
//  Day50
//
//  Created by Sultan Ali on 28/06/2020.
//  Copyright © 2020 Sultan Ali. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailLabe: UILabel!
    
    @IBOutlet var detailImage: UIImageView!
    
    override func viewDidLoad() {
        detailLabe.text = ViewController.transText
        detailImage.image = ViewController.transImage
    }
}
