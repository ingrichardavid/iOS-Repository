//
//  ViewController.swift
//  Swipes and Shakes
//
//  Created by Ing. Richard José David González on 15/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import AVFoundation

/**
    Class to manage Sounds, Shakes or Swipes events.
*/
class ViewController: UIViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.

    @IBOutlet weak var lblText: UILabel!
    
    //MARK: - Objects, Variables and Constants.
    
    ///Variable audio file to run.
    var player: AVAudioPlayer = AVAudioPlayer()
    
    //Constant to store the name sounds.
    let sounds: [String] = ["bean","belch","giggle","pew","pig","snore","static","uuu"]
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Function to detect Swipes events on view.
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        
        switch (sender.direction) {
            
        case UISwipeGestureRecognizerDirection.Right:
            
            self.random()
            self.lblText.text = "RIGHT"
            break
            
        case UISwipeGestureRecognizerDirection.Left:
            
            self.random()
            self.lblText.text = "LEFT"
            break
            
        case UISwipeGestureRecognizerDirection.Up:
            
            self.random()
            self.lblText.text = "UP"
            break
            
        case UISwipeGestureRecognizerDirection.Down:
            
            self.random()
            self.lblText.text = "DOWN"
            break
            
        default:
            break
            
        }
        
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        guard event?.subtype != UIEventSubtype.MotionShake else {
            
            self.random()
            self.lblText.text = "Device was shaken!"
            
            return
            
        }
        
    }
    
    //MARK: - Methods: Self.
    
    ///Function to generate a sound at random.
    private func random() {
        
        let randomNumber: Int = Int(arc4random_uniform(UInt32(self.sounds.count)))
        let fileLocation: String = NSBundle.mainBundle().pathForResource(self.sounds[randomNumber], ofType: "mp3")!
        
        do {
            try self.player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: fileLocation))
            self.player.play()
        } catch {
            print("Error executing audio file!")
        }
        
    }

}

