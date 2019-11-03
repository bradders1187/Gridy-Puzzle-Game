//
//  View Grid.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import Foundation
import UIKit

class ViewGrid: Grid {
    
    let drawingView: UIImageView
    
    init(drawingView: UIImageView) {
        self.drawingView = drawingView
    }
    
    func drawingOn(thisView: UIImageView) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: thisView.frame.width, height: thisView.frame.height))
        let image = renderer.image { (ctx) in
            let squareDimension = thisView.frame.width
            drawGrid(context: ctx, squareDimension: squareDimension)
        }
        thisView.image = image
    }
    
}
