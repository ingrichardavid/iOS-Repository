//
//  ViewController.swift
//  Working With Audio
//
//  Created by Ing. Richard José David González on 15/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit
import AVFoundation

/**
    ViewController responsible for managing run view of Audio files.
*/
class ViewController: UIViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.

    @IBOutlet weak var btnItemPlay: UIBarButtonItem!
    @IBOutlet weak var btnItemPause: UIBarButtonItem!
    @IBOutlet weak var btnItemStop: UIBarButtonItem!
    @IBOutlet weak var sdrVolume: UISlider!
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK: - Objects, Variables and Constants.
    
    ///Variable audio file to run.
    var player: AVAudioPlayer = AVAudioPlayer()
    
    ///Variable time management loading progress bar.
    var timer: NSTimer = NSTimer()
    
    ///Variable increases up to the total duration of the audio file.
    var limit: Float = Float()
    
    //MARK: - Connecting elements storyboard: IBAction.
    
    ///Audio function to start.
    @IBAction func play(sender: UIBarButtonItem) {
        self.configurationBarButtonItem(0)
    }
    
    ///Audio function to pause.
    @IBAction func pause(sender: UIBarButtonItem) {
        self.configurationBarButtonItem(1)
    }
    
    ///Audio function to stop.
    @IBAction func stop(sender: UIBarButtonItem) {
        self.configurationBarButtonItem(2)
    }
    
    ///Function to adjust the volume.
    @IBAction func adjustVolume(sender: UISlider) {
        self.player.volume = self.sdrVolume.value
    }
    
    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurationPlayer()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: Self.
    
    ///Function to set the AVAudioPlayer object.
    private func configurationPlayer() {
        
        
        self.btnItemPlay.enabled = true
        self.btnItemPause.enabled = false
        self.btnItemStop.enabled = false
        
        let audioPath: String = NSBundle.mainBundle().pathForResource("bach", ofType: "mp3")!
        
        do {
            try self.player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
        } catch {
            print("Error executing audio file!")
        }
        
    }
    
    ///Method to increase the progress bar.
    func modifyProgressBar() {
        
        self.limit++

        guard self.limit >= Float(self.player.duration) else {
            self.progressBar.progress = Float(1/self.player.duration) + self.progressBar.progress
            return
        }
        
        self.restartData()
        
    }
    
    ///Function to restore the fields with default values.
    private func restartData() {
        
        self.btnItemPlay.enabled = true
        self.btnItemPause.enabled = false
        self.btnItemStop.enabled = false
        self.limit = 0
        self.progressBar.progress = 0
        self.timer.invalidate()
        
    }
    
    ///Function to manage the behavior of UIBarButtonItem.
    private func configurationBarButtonItem(barButtonItem: Int) {
    
        switch (barButtonItem) {
        
        case 0:
            
            self.btnItemPlay.enabled = false
            self.btnItemPause.enabled = true
            self.btnItemStop.enabled = true
            self.player.play()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("modifyProgressBar"), userInfo: nil, repeats: true)
            break
            
        case 1:
            
            self.btnItemPlay.enabled = true
            self.btnItemPause.enabled = false
            self.btnItemStop.enabled = true
            self.timer.invalidate()
            self.player.pause()
            break
        
        case 2:
            
            self.btnItemPlay.enabled = true
            self.btnItemPause.enabled = false
            self.btnItemStop.enabled = false
            self.restartData()
            self.configurationPlayer()
            break
            
        default:
            break
        
        }
    
    }
    
}

