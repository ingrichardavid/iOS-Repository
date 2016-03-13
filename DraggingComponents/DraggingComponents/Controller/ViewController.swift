//
//  ViewController.swift
//  DraggingComponents
//
//  Created by Ing. Richard José David González on 11/3/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    Controller. Implements: UIViewController.
*/
class ViewController: UIViewController {
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Drag and Drop.
    @IBAction func wasDragged(sender: UIPanGestureRecognizer) {
        
        let translation: CGPoint = sender.translationInView(self.view)
        let label: UIView = sender.view!
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        let xFromCenter: CGFloat = label.center.x - (self.view.bounds.width / 2)
        let scale: CGFloat = min(100 / abs(xFromCenter), 1)
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        label.transform = stretch
        
        guard sender.state != UIGestureRecognizerState.Ended else {
            
            if (label.center.x < 100) {
                print("No chosen!")
            } else if (label.center.x > self.view.bounds.width - 100) {
                print("Chosen!")
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            return
        
        }
        
    }
    
    //MARK: - Functions: UIVIewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

