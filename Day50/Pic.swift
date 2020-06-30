//
//  Pic.swift
//  Day50
//
//  Created by Sultan Ali on 30/06/2020.
//  Copyright © 2020 Sultan Ali. All rights reserved.
//

import Foundation
import UIKit

class Pic: Codable {
    var image: String
    var desc: String
    
    init(image: String, desc: String) {
        self.image = image
        self.desc = desc
    }
}
