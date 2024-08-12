//
//  SoundLevelMonitor.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 8/1/24.
//

import Foundation
import AVFoundation
import Combine

@Observable class SoundLevelMonitor {
    
    static let shared = SoundLevelMonitor()

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    var amplitudes: [CGFloat] = Array(repeating: 0.0, count: 100)
    
    var suddenSpikeDetected: Bool = false
//
//    enum SoundCategory: String {
//        case quiet = "Quiet"
//        case ambient = "Ambient"
//        case loud = "Loud"
//        case veryLoud = "Very Loud"
//    }
//    
//    var soundLevel: Float = 0.0
//    var soundLevelCategory: SoundCategory = .quiet
//    
//    func updateSoundCategory() {
//        let level = self.soundLevel
//        switch level {
//        case ..<(-40):
//            soundLevelCategory = .quiet
//        case -40..<(-20):
//            soundLevelCategory = .ambient
//        case -20..<(-10):
//            soundLevelCategory = .loud
//        default:
//            soundLevelCategory = .veryLoud
//        }
//    }
    
    func startMonitoring() {
        
        // Document path for the temporary audio file for sound level monitoring.
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = documentsPath.appendingPathComponent("temp_audio.caf")
        
        do {
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            // Start recording
            audioRecorder?.record()
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.updateAmplitudes()
            }
//            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//                self.audioRecorder?.updateMeters()
//                self.soundLevel = self.audioRecorder?.averagePower(forChannel: 0) ?? 0
//                self.updateSoundCategory()
//            })
        } catch {
            print("Failed to set up audio recorder: \(error)")
        }
        
    }
    
    private func updateAmplitudes() {
        audioRecorder?.updateMeters()
        
        let amplitude = pow(10, (0.05 * audioRecorder!.averagePower(forChannel: 0)))
        let normalizedAmplitude = CGFloat(amplitude) * -6.0
        
        DispatchQueue.main.async {
            
            // watch out for anomalies
            if let lastAmplitude = self.amplitudes.last, abs(normalizedAmplitude - lastAmplitude) > 0.08 {
                self.suddenSpikeDetected = true
                // Reset suddenSpikeDetected to false after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.suddenSpikeDetected = false
                }
            }
            
            self.amplitudes.append(normalizedAmplitude)
            if self.amplitudes.count > 100 {
                self.amplitudes.removeFirst()
            }
        }
        
//        amplitudes.append(normalizedAmplitude)
//        if amplitudes.count > 100 {
//            amplitudes.removeFirst()
//        }
    }
    
    func stopMonitoring() {
        audioRecorder?.stop()
        timer?.invalidate()
    }
}
