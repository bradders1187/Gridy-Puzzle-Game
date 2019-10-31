//
//  PuzzleControllerDelegates.swift
//  Gridy
//
//  Created by Peter Bradtke on 30/10/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

extension PuzzleController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Number Of Items In Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.tileView ? puzzleBoardImages.count : puzzleBoardImages.count
    }

    //MARK: - Cell For Item At
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! myCell
        cell.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = .white
        // COLLECTION VIEW 1
        if collectionView == tileView {
            let width = (tileView.frame.size.width - 30) / 6
            let layout = tileView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.imageView.image = tileViewImages[indexPath.item]
        // COLLECTION VIEW 2
        } else {
            let width = puzzleBoard.frame.size.width / 4
            let layout = puzzleBoard.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.imageView.image = puzzleBoardImages[indexPath.item]
        }
        return cell
    }
    
    //MARK: - Did Select Item At - help button
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (tileViewImages.count - 1) {
            popUpView.isHidden = false
            popUpView.layer.borderColor = UIColor(red: 243/255, green: 233/255, blue: 210/255, alpha: 1).cgColor
            popUpView.layer.borderWidth = 5
            popUpView.layer.cornerRadius = 15
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hidePopUpImage), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hidePopUpImage() {
        popUpView.isHidden = true
    }
    
    //MARK: Orientation Transition
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layoutOne = tileView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (tileView.frame.width - 30) / 6
            layoutOne.itemSize = CGSize(width: width, height: width)
            layoutOne.invalidateLayout()
        } else
            if UIDevice.current.orientation.isPortrait,
            let layoutOne = tileView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = (tileView.frame.width - 30) / 6
            layoutOne.itemSize = CGSize(width: width , height: width)
            layoutOne.invalidateLayout()
        }
        if UIDevice.current.orientation.isLandscape,
            let layoutTwo = puzzleBoard.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = puzzleBoard.frame.width/4
            layoutTwo.itemSize = CGSize(width: width, height: width)
            layoutTwo.invalidateLayout()
        } else if UIDevice.current.orientation.isPortrait,
            let layoutTwo = puzzleBoard.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = puzzleBoard.frame.width/4
            layoutTwo.itemSize = CGSize(width: width , height: width)
            layoutTwo.invalidateLayout()
        }
        tileView.reloadData()
        puzzleBoard.reloadData()
    }
}

