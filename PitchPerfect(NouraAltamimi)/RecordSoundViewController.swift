//
//  RecordSoundViewController.swift
//  PitchPerfect(NouraAltamimi)
//
//  Created by noura tamimi on 29/03/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecord : AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    
    @IBAction func recordAudio(_ sender: Any) {
   
        configureUI(recording :true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
   
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        
        try! audioRecord = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecord.delegate = self
        audioRecord.isMeteringEnabled = true
        audioRecord.prepareToRecord()
        audioRecord.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        
    configureUI(recording :false)
        audioRecord.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "Stop", sender: audioRecord.url)
        } else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="Stop"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(recording : Bool) {
        if(recording){
        recordLabel.text="Recording in progresss"
        }
        else {
            recordLabel.text="Tap To Record"
        }
        stopRecordingButton.isEnabled=recording
        recordButton.isEnabled = !recording
    }
}

