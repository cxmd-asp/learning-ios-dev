//
//  ViewController.swift
//  Dicee-iOS13
//
//  Created by Angela Yu on 11/06/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!
    
    var diceImages = [#imageLiteral(resourceName: "DiceOne"), #imageLiteral(resourceName: "DiceTwo"), #imageLiteral(resourceName: "DiceThree"), #imageLiteral(resourceName: "DiceFour"), #imageLiteral(resourceName: "DiceFive"), #imageLiteral(resourceName: "DiceSix") ]
    
 
    @IBAction func rollButtonPressed(_ sender: UIButton) {

        leftDiceImageView.image = diceImages.randomElement()
        rightDiceImageView.image = diceImages.randomElement()

    }
}
