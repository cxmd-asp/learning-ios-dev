//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
        
    }

      
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    
    var secondsRemaining = 0
    
    var timer = Timer()
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        var hardness = sender.currentTitle!
        var hardnessSeconds = 15
        let change  = Double(100.0 / Double(hardnessSeconds) / 100)
        
        print("\(hardness): \(hardnessSeconds) seconds. \nStarting")
        
        secondsRemaining = hardnessSeconds
     
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
              if self.secondsRemaining > 0 {
                  
                  print ("\(self.secondsRemaining) seconds")
                  
                  self.progressView.progress = self.progressView.progress + Float(change)
              
                  
                  self.secondsRemaining -= 1
              } else {
                  Timer.invalidate()
                  self.playSound(soundName: "alarm_sound")
              }
          }

    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        var player  = try! AVAudioPlayer(contentsOf: url!)
        player.play()
                
    }
    
}
