//
//  Tiles.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

class Tiles: UIImageView, UIGestureRecognizerDelegate {
    
    var originalTileLocation: CGPoint
    // final position in grid 0 - 15
    // access using gridLocations array
    var tileGridLocation: Int
    var isTileInCorrectLocation: Bool
    
    init(originalTileLocation: CGPoint, frame: CGRect, tileGridLocation: Int) {
        self.originalTileLocation = originalTileLocation
        self.tileGridLocation     = tileGridLocation
        isTileInCorrectLocation   = false
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
