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
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!
    
    let pitchEffect: AVAudioUnitTimePitch = AVAudioUnitTimePitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // call audioEngine
        audioEngine = AVAudioEngine()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePath, error: nil)
        audioPlayer.enableRate = true
        audioFile = AVAudioFile(forReading: receivedAudio.filePath, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSoundSlow(sender: UIButton) {
        playAudioWithVariableRate(0.3)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playAudioWithVariableRate(2.5)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1200)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1200)
    }
    @IBAction func stopPlaying(sender: UIButton) {
        stopAllAudio()
    }

    /// Play recorded sound fast or slow:
    ///
    /// - rate: is a float
    /// - default value is 1.0
    /// - 2.0 means the sound will be played double speed
    /// - 0.5 means the sound will be played half speed
    func playAudioWithVariableRate(rate: Float){

        stopAllAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    /// Play recorded sound like Darth Vader or Chipmunk
    ///
    /// - pitch: is a Float between -2400 and 2400
    /// - if pitch < 0 and < 2400 then sound will like DarthVader
    /// - if pitch > 0 and > -2400 sound will be plays like Chipmunk
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAllAudio()
        
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

    /// Stop and reset all audio
    func stopAllAudio(){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

    }
    
}
