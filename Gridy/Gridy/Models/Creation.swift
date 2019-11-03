//
//  Creation.swift
//  Gridy
//
//  Created by Peter Bradtke on 30/10/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
//MARK: Creates grids for Collection Views
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

