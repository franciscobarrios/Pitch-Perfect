//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Francisco Barrios on 02-04-15.
//  Copyright (c) 2015 Francisco Barrios. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordingLabel.text = "Tap to record"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
        recordButton.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func RecordAudio(sender: UIButton) {

        stopButton.hidden = false
        recordingLabel.hidden = false
        recordingLabel.text = "Recording ..."
        recordButton.enabled = false
      
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {

            if(flag){
                recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, recordingFilePath: recorder.url)
                self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }else{
                println("Error while recording!!!")
                recordingLabel.enabled = true
                stopButton.hidden = true
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func StopRecordingAudio(sender: UIButton) {

        recordingLabel.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        audioRecorder.stop()

        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}



