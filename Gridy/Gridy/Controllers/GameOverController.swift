//
//  PlayfieldView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//
import UIKit

class GameOverController: UIViewController {
    
    var gameImage = UIImage()
    var moves = Int()
    var score = Int()
    
    //MARK: variables
    @IBOutlet weak var completeImageHolder: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: IBACTIONS/FUNCTIONS
    //Function to let user create new game
    @IBAction func newGameButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Function to let user share game results
    @IBAction func shareButton(_ sender: Any) {
        let note = "Congratulation!"
        let image = gameImage
        let items = [note as Any, image as Any]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        present(activityController, animated: true)
    }
    //MARK: Function to turn buttons rounded
    func rounded(button: UIButton) {
        var roundedButton = RoundedButton()
        roundedButton.setButton(button)
        roundedButton.rounded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rounded(button: newGameButton)
        rounded(button: shareButton)
        
        //MARK: set finished game label using score and moves
        scoreLabel.text = "The puzzle was solved in \(moves) moves and you scored \(score) points"
        completeImageHolder.image = gameImage
    }
    
    
   
}
