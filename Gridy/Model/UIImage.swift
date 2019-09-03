//
//  File.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

extension UIImage {
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

