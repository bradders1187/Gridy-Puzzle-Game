//
//  GameOverView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

class GameOverView: UIViewController {
    
    //Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var scoreListView: UIView!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var totalMoves: UILabel!
    @IBOutlet weak var wrongMoves: UILabel!
    @IBOutlet weak var correctMoves: UILabel!

}
