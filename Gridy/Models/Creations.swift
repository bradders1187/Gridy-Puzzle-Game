//
//  Creations.swift
//  Gridy
//
//  Created by Peter Bradtke on 17/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

class Creation {
    var image: UIImage
    static var defaultImage : UIImage {
        return UIImage.init(named: "Lake")!
    }
    init() {
        image = Creation.defaultImage
    }
    func reset() {
        image = Creation.defaultImage
    }
}

