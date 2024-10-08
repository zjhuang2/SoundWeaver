//
//  SpeechRecognizer.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import Foundation
import SwiftUI
import AVFoundation
import Speech

@Observable class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate, AVAudioRecorderDelegate {
    static let shared = SpeechRecognizer()
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
//    var transcriptText: String = "Go ahead, I am listening."
//    var isRecording: Bool = false
    
    // Just an indicator for checking microphone access.
    var hasMicrophoneAccess = false
    
    public func startTranscribing(completion: @escaping (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startSpeechRecognition(completion: completion)
            case .denied, .restricted, .notDetermined:
                completion("Speech recognition authorization was Denied.")
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func startSpeechRecognition(completion: @escaping (String) -> Void) {
        do {
            // Cancel the previous task if it's running.
            if let recognitionTask = recognitionTask {
                recognitionTask.cancel()
                self.recognitionTask = nil
            }
            
            // The AudioSession is already active, creating input node.
            let inputNode = audioEngine.inputNode
//            try inputNode.setVoiceProcessingEnabled(false)
            
            // Create and configure the speech recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a recognition request") }
            recognitionRequest.shouldReportPartialResults = true
            
            // Keep speech recognition data on device
            if #available(iOS 13, *) {
                recognitionRequest.requiresOnDeviceRecognition = true
            }
            
            // Create a recognition task for speech recognition session.
            // Keep a reference to the task so that it can be canceled.
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//                var isFinal = false
                
                if let result = result {
                    // Update the recognizedText
                    let recognizedText = result.bestTranscription.formattedString
                    let lines = recognizedText.split(separator: "\n")
                    let lastTwoLines = lines.suffix(2).joined(separator: "\n")
                    completion(lastTwoLines)
                } else if let error = error {
                    completion("Recognition stopped: \(error.localizedDescription)")
                }
                
                if error != nil || result?.isFinal == true {
                    // Stop recognizing speech if there is a problem
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
            
            // Configure the microphone input
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            completion("Audio engine could not start: \(error.localizedDescription)")
        }
    }
    
    // Stop the speech rceognition task
    func stopTranscribing() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }
}
