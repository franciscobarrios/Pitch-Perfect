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

    
    @IBOutlet weak var stopButtonImage: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButtonImage: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButtonImage.hidden=true
        recordButtonImage.enabled=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func RecordAudio(sender: UIButton) {

        stopButtonImage.hidden=false
        recordingInProgress.hidden=false
        recordButtonImage.enabled=false
        println("In RecordAudio")
        
        //TODO: Record the user's voice
      
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as! String

        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!,
        successfully flag: Bool) {
            if(flag){
                recordedAudio = RecordedAudio()
                recordedAudio.filePath = recorder.url
                recordedAudio.title = recorder.url.lastPathComponent
                self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            }else{
                println("Error while recording!!!")
                recordButtonImage.enabled = true
                stopButtonImage.hidden = true
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController

            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
        
    }
    
    
    @IBAction func StopRecordingAudio(sender: UIButton) {

        println("In StopRecordingAudio")
        recordingInProgress.hidden=true
        stopButtonImage.hidden=true
        recordButtonImage.enabled=true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
}



