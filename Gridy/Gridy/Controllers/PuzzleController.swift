//
//  PuzzleController.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import AVFoundation

class PuzzleController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate {
    
    //MARK: IBOUTLETS
    @IBOutlet weak var movesCounter: UILabel!
    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var gridView: UIImageView!
    @IBOutlet weak var tilesContainerView: UIView!
    @IBOutlet weak var newGameButton: UIButton!
    
    
    //MARK: Variables
    var gameImage = UIImage()
    private var imageArray = [UIImage]()
    private var tileViews = [Tiles]()
    private var gridLocations = [CGPoint]()
    private var moves = 0
    private var score = 0
    private var scoringreward = 0
    private let imageView = UIImageView()
    private let imageHoldingView = UIView()

    //MARK: IBACTIONS
    @IBAction func newGameButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: functionality of the image, presenting a preview of the image
    @IBAction func peekButtonPressed(_ sender: Any) {
        imageView.image = gameImage
        view.addSubview(imageHoldingView)
        imageHoldingView.addSubview(imageView)
        var imageViewDimension = 0.0
        var imageHoldingViewDimension = 0.0
        if view.frame.height > view.frame.width {
            imageViewDimension = Double(view.frame.width) - 30
            imageHoldingViewDimension = Double(view.frame.width) - 20
        } else {
            imageViewDimension = Double(view.frame.height) - 30
            imageHoldingViewDimension = Double(view.frame.height) - 20
        }
        imageHoldingView.frame = CGRect(x: 0.0, y: 0.0, width: imageHoldingViewDimension, height: imageHoldingViewDimension)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: imageViewDimension, height: imageViewDimension)
        imageHoldingView.backgroundColor = UIColor.black
        imageView.center = imageHoldingView.center
        imageHoldingView.center = CGPoint(x: view.center.y - view.frame.width, y: view.center.y)
        view.bringSubviewToFront(imageHoldingView)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.imageHoldingView.center = self.view.center
        })
        UIView.animate(withDuration: 0.4, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.imageHoldingView.center = CGPoint(x: self.view.center.x + self.view.frame.width, y: self.view.center.y)
        })
    }
    
    // MARK: Function for point scoring
    func updateMoveCounter(isItCorrect: Bool) {
        moves += 1
        if isItCorrect == false {
            scoringreward = 0
            if score > 0 {
                score -= 1
            }
        } else {
            scoringreward += 1
            score += scoringreward
        }
        movesCounter.text = String(format: "%03d", score)
    }
    
    //MARK: function to resize the passed image to prevent slices from being croped out when populated in the tiles, the new image will be passed to sliceImage() func
    func reSize(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //MARK: Function to make Buttons rounded, by creating an object from sructure model and call its method
    func rounded(button: UIButton) {
        var roundedButton = RoundedButton()
        roundedButton.setButton(button)
        roundedButton.rounded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        let draw = ViewGrid(drawingView: gridView)
        draw.drawingOn(thisView: gridView)
        rounded(button: newGameButton)
        sliceImage(image: reSize(image: gameImage, newWidth: gridView.frame.width)!)
        getGridLocations()
    }
    
    
    //MARK: function to slice the game image into 16 slices
    func sliceImage(image: UIImage) {
        let imageToSlice = image
        let width = imageToSlice.size.width/4
        let height = imageToSlice.size.height/4
        let scale = imageToSlice.scale
        for y in 0..<4 {
            for x in 0..<4 {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                let i = imageToSlice.cgImage?.cropping(to: CGRect(x: CGFloat(x)*width*scale, y: CGFloat(y)*height*scale, width: width, height: height))
                let tileImage = UIImage(cgImage: i!)
                imageArray.append(tileImage)
                UIGraphicsEndImageContext()
            }
        }
        makeTiles()
    }
    
    // MARK: function to create tiles (imageviews) that holds the 16 slices of the game image
    func makeTiles() {
        let numberOfTiles = 16
        let tileDimension = gridView.frame.height / 4
        let tileDimensionWithGap = tileDimension + 5
        let columns = Int((tilesContainerView.frame.width / tileDimensionWithGap).rounded(.down))
        let rows    = Int((tilesContainerView.frame.height / tileDimensionWithGap).rounded(.down))
        let numberOfTilesCanFit = columns * rows
        if numberOfTiles > numberOfTilesCanFit {
            print("More tiles than space available")
        } else {
            var imageNumber = 0
            var imagePositionsarray = Array(0...(imageArray.count - 1))
            for y in 0...rows {
                for x in 0...columns {
                    if imageNumber < numberOfTiles {
                        let tileXCoordinate = CGFloat(x) * tileDimensionWithGap
                        let tileYCoordinate = CGFloat(y) * tileDimensionWithGap
                        let tileRect = CGRect(x: tileXCoordinate, y: tileYCoordinate, width: tileDimension, height: tileDimension)
                        let tile = Tiles(originalTileLocation: CGPoint(x: tileXCoordinate, y: tileYCoordinate), frame: tileRect, tileGridLocation: imageNumber)
                        containingView.addSubview(tile)
                        let randomNumber = Int.random(in: 0...(imagePositionsarray.count - 1))
                        let imageIndexNumber = imagePositionsarray.remove(at: randomNumber)
                        tile.image = imageArray[imageIndexNumber]
                        tile.isUserInteractionEnabled = true
                        tile.accessibilityLabel = "\(imageIndexNumber)"
                        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(moveImage(_:)))
                        panGestureRecogniser.delegate = self
                        tile.addGestureRecognizer(panGestureRecogniser)
                        tileViews.append(tile)
                    }
                    imageNumber += 1
                }
            }
        }
    }
    
    //MARK: global var to hold the initial position of the sliced game image view
    private var initialImageViewOffset = CGPoint()
    @objc func moveImage(_ sender: UIPanGestureRecognizer) {
        sender.view?.superview?.bringSubviewToFront(sender.view!)
        let translation = sender.translation(in: sender.view?.superview)
        if sender.state == .began {
            initialImageViewOffset = (sender.view?.frame.origin)!
        }
        let position = CGPoint(x: translation.x + initialImageViewOffset.x - (sender.view?.frame.origin.x)!, y: translation.y + initialImageViewOffset.y - (sender.view?.frame.origin.y)!)
        let postionInSuperView = sender.view?.convert(position, to: sender.view?.superview)
        sender.view?.transform = (sender.view?.transform.translatedBy(x: position.x, y: position.y))!
        if sender.state == .ended {

            let (nearTile, snapPosition) = isTileNearGrid(droppingPosition: postionInSuperView!)
            let tile = sender.view as! Tiles
            if nearTile {
                sender.view?.frame.origin = gridLocations[snapPosition]
                
                //MARK: checs to see if tiles are in the right position
                if String(snapPosition) == tile.accessibilityLabel {
                    tile.isTileInCorrectLocation = true
                    updateMoveCounter(isItCorrect: true)
                } else {
                    tile.isTileInCorrectLocation = false
                    updateMoveCounter(isItCorrect: false)
                }
            } else {
                //MARK: if its not in the correct placement return it to the original location
                sender.view?.frame.origin = tile.originalTileLocation
                tile.isTileInCorrectLocation = false
            }
            GameCompleted()
        }
    }
    
    func GameCompleted() {
        if allTilesInCorrectPosition() {
            performSegue(withIdentifier: "goToGameOverController", sender: self)
        }
    }
    
    //MARK: segue func to pass the game image to FinalViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameOverController" {
            let destination = segue.destination as! GameOverController
            destination.gameImage = gameImage
            destination.moves = moves
            destination.score = score
        }
    }
    
    func allTilesInCorrectPosition() -> Bool {
        for tile in tileViews {
            if tile.isTileInCorrectLocation == false {
                return false
            }
        }
        return true
    }
    
    // MARK: check if the dropped location of the image slice is near any of the grid view locations
    func isTileNearGrid(droppingPosition: CGPoint) -> (Bool,Int) {
        for x in 0..<gridLocations.count {
            let gridlocation = gridLocations[x]
            let fromX = droppingPosition.x
            let toX = gridlocation.x
            let fromY = droppingPosition.y
            let toY = gridlocation.y
            let area = (fromX - toX) * (fromX - toX) + (fromY - toY) * (fromY - toY)
            let halfTileSideSize = (gridView.frame.height / 4) / 2
            if area < halfTileSideSize * halfTileSideSize {
                return(true, x)
            }
        }
        //MARK:this is here just so it retuned an INT
        return(false, 50)
    }
    
    //MARK: get grid view tiles locations and convert it to the containing view(superview)
    private var locationInSuperview = CGPoint()
    func getGridLocations() {
        let width  = gridView.frame.width / 4
        let height = gridView.frame.height / 4
        for y in 0..<3 {
            for x in 0..<3 {
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
                let location = CGPoint.init(x: CGFloat(x) * width, y: CGFloat(y) * height)
                locationInSuperview = gridView.convert(location, to: gridView.superview)
                gridLocations.append(locationInSuperview)
            }
        }
    }
    
}
