//
//  DetectionState.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import Foundation

/// An object that aggregates information over time to predict sound classification. It requires a sound to be
/// present for more than a single prediction, and after detection, the sound has to be absent for several
/// predictions before the system no longer detects it.
struct DetectionState {
    // The confidence threshold that considers a sound present
    let presenceThreshold: Double
    
    // The confidence threshold that considers a sound absent
    let absenceThreshold: Double
    
    // The number of consecutive presence measurements necessary to begin detection
    let presenceMeasurementsToStartDetection: Int
    
    /// The number of consecutive absence measurements necessary to end detection.
    let absenceMeasurementsToEndDetection: Int

    /// Indicates whether the app detects a sound.
    var isDetected = false
    
    /// The app contains inertia values that prevent changing the state of `isDetected` immediately.
    /// This value indicates the progress toward changing its state.
    var transitionProgress = 0
    
    /// The most recent confidence measurement for the sound.
    var currentConfidence = 0.0
    
    // Cumulative average confidence
    var cumulativeConfidence = 0.0
    
    /// Creates a detection state with a confidence of zero, and a state that indicates the system doesn't detect a sound.
    init(presenceThreshold: Double,
         absenceThreshold: Double,
         presenceMeasurementsToStartDetection: Int,
         absenceMeasurementsToEndDetection: Int) {
        self.presenceThreshold = presenceThreshold
        self.absenceThreshold = absenceThreshold
        self.presenceMeasurementsToStartDetection = presenceMeasurementsToStartDetection
        self.absenceMeasurementsToEndDetection = absenceMeasurementsToEndDetection
    }
    
    /// Creates a detection state with a confidence measurement.
    ///
    /// - Parameters:
    ///   - prevState: The state from which to derive a new detection state. The difference relies on the
    ///     confidence measurement that the system provides to the `currentConfidence` argument.
    ///   - currentConfidence: A confidence measurement that reflects whether the system detects
    ///     a sound according to the latest observation.
    init(advancedFrom prevState: DetectionState, currentConfidence: Double) {
        isDetected = prevState.isDetected
        transitionProgress = prevState.transitionProgress
        presenceThreshold = prevState.presenceThreshold
        absenceThreshold = prevState.absenceThreshold
        presenceMeasurementsToStartDetection = prevState.presenceMeasurementsToStartDetection
        absenceMeasurementsToEndDetection = prevState.absenceMeasurementsToEndDetection
        
        if isDetected { // If sound is previously in a "detected" state
            if currentConfidence < absenceThreshold {
                transitionProgress += 1 // one step towards transitioning detection state
            } else {
                transitionProgress = 0 // reset transition progress
            }
            
            if transitionProgress >= absenceMeasurementsToEndDetection { // progress meets the "absence" threshold
                isDetected = !isDetected
                transitionProgress = 0
            }
        } else { // If Sound is not previously in a "not detected" state
            if currentConfidence > presenceThreshold {
                transitionProgress += 1
            } else {
                transitionProgress = 0
            }
            
            if transitionProgress >= presenceMeasurementsToStartDetection {
                isDetected = !isDetected
                transitionProgress = 0
            }
        }
        
        self.currentConfidence = currentConfidence
    }
}
