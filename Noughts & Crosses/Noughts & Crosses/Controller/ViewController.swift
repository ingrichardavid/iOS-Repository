//
//  ViewController.swift
//  Noughts & Crosses
//
//  Created by Ing. Richard José David González on 30/11/15.
//  Copyright © 2015 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Implements UIViewController. It contains the run of play noughts and crosses.
*/
class ViewController: UIViewController {
    
    ///MARK: Objects, variables and constants.
    
    ///Value indicating that player is active, nought or cross.
    var activePlayer: Int = Int()

    ///Status of game
    var gameState: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    ///Array containing the winning combinations.
    let winningCombinations: [[Int]] = [[0, 1, 2],[3, 4, 5],[6, 7, 8],[0, 3, 6],[1, 4, 7],[2, 5, 8],[0, 4, 8],[2, 4, 6]]
    
    ///Indicates whether the game is still active or already completed.
    var gameActive = true
    
    ///Label to display the message that the game is over.
    @IBOutlet weak var gameOverLabel: UILabel!
    
    ///Can restart the game.
    @IBOutlet weak var playAgainButton: UIButton!
    
    //MARK: - Methods: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activePlayer = 2
        self.gameOverLabel.hidden = true
        self.playAgainButton.hidden = true
        self.gameOverLabel.center = CGPointMake(self.gameOverLabel.center.x - 500, self.gameOverLabel.center.y)
        self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x - 500, self.playAgainButton.center.y)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Functions.
    
    ///Function to determine which player is active.
    @IBAction func buttonPressed(sender: AnyObject) {
        
        if (self.gameState[sender.tag] == 0 && self.gameActive == true) {
        
            self.gameState[sender.tag] = self.activePlayer
            
            if (self.activePlayer == 1) {
                
                sender.setImage(UIImage(named: "nought"), forState: UIControlState.Normal)
                self.activePlayer = 2
                
            } else {
                
                sender.setImage(UIImage(named: "cross"), forState: UIControlState.Normal)
                self.activePlayer = 1
                
            }
            
            for combination in winningCombinations {
                
                if (self.gameState[combination[0]] != 0 && (self.gameState[combination[0]] == self.gameState[combination[1]]) && (self.gameState[combination[1]] == self.gameState[combination[2]])) {
                
                    self.gameActive = false
                    
                    if (self.gameState[combination[0]] == 1) {
                    
                        self.gameOverLabel.text = "Noughts have won!"
                    
                    } else {
                        
                        self.gameOverLabel.text = "Crosses have won!"
                    
                    }
                    
                    self.endGame()
                
                }
            
            }
            
            if (self.gameActive == true) {
                
                self.gameActive = false
                
                for buttonState in self.gameState {
                    
                    if (buttonState == 0) {
                        
                        self.gameActive = true
                        
                    }
                    
                }
                
                if (self.gameActive == false) {
                    
                    self.gameOverLabel.text = "It's a draw!"
                    self.endGame()
                    
                }
            
            }
        
        }
        
    }
    
    ///Function to finish the game.
    private func endGame() {
    
        self.gameOverLabel.hidden = false
        self.playAgainButton.hidden = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.gameOverLabel.center = CGPointMake(self.gameOverLabel.center.x + 500, self.gameOverLabel.center.y)
            
            self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x + 500, self.playAgainButton.center.y)
            
        })
    
    }
    
    ///Function to reset the game.
    @IBAction func playAgain(sender: UIButton) {
        
        self.gameActive = true
        self.gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        self.activePlayer = 2
        self.gameOverLabel.hidden = true
        self.playAgainButton.hidden = true
        self.gameOverLabel.center = CGPointMake(self.gameOverLabel.center.x - 500, self.gameOverLabel.center.y)
        self.playAgainButton.center = CGPointMake(self.playAgainButton.center.x - 500, self.playAgainButton.center.y)
        
        var buttonToClear: UIButton = UIButton()
        
        for (var i = 0; i < 9; i++) {
        
            buttonToClear = self.view.viewWithTag(i) as! UIButton
            buttonToClear.setImage(nil, forState: UIControlState.Normal)
        
        }
        
    }
    
}

