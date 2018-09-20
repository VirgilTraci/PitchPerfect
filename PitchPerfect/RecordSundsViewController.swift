//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by David Hulmes on 11/07/2018.
//  Copyright © 2018 jackhumble. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordButtonOutlet: UIButton!
    @IBOutlet var stopRecordingOutlet: UIButton!
    @IBOutlet var recordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stopRecordingOutlet.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
       
    
        recordButtonOutlet.isEnabled = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
       
       recordButtonOutlet.isEnabled = false
        
    }
    

    @IBAction func recordAudio(_ sender: Any) {
       
        recordLabel.text = "Recording in progress"
        recordButtonOutlet.isEnabled = false
        stopRecordingOutlet.isEnabled = true
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        print(audioRecorder)
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        print("here1")
        try! session.setActive(true)
        audioRecorder.prepareToRecord()
        print("here2")
        audioRecorder.record()
        
    }

    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordLabel.text = "Tap to record"
        stopRecordingOutlet.isEnabled = false
        recordButtonOutlet.isEnabled = true
        
        audioRecorder.stop()
        //checking out if this makes a difference
       // audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            
            performSegue(withIdentifier: "stopSegue", sender: audioRecorder.url)
        
        }
        
        else {
    
            print("File was not saved successfully")
            
        }
        
            }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopSegue" {
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    
}

