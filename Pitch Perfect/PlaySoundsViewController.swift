//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Francisco Barrios on 03-04-15.
//  Copyright (c) 2015 Francisco Barrios. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    let pitchEffect: AVAudioUnitTimePitch = AVAudioUnitTimePitch()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        /*
        
        not necesary anymore
        
        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            var filePathUrl = NSURL.fileURLWithPath(filePath)
            
        }else{
            println("file not found!!!")
        }
        */
        
        audioEngine = AVAudioEngine()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePath, error: nil)
        audioPlayer.enableRate=true
        
        audioFile = AVAudioFile(forReading: receivedAudio.filePath, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate=0.3
        audioPlayer.currentTime=0.0
        audioPlayer.play()
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate=2.5
        audioPlayer.currentTime=0.0
        audioPlayer.play()
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1200)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1200)
    }
    
    
    
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()

    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        if (audioPlayer.playing){
            audioPlayer.stop()
        }else{
            println("nothing to stop")
        }
    }
}
