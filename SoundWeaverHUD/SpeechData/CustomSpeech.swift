//
//  CustomSpeech.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 8/6/24.
//

import Foundation
import Speech

let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"), identifier: "zjhuang.SoundWeaverHUD", version: "1.0") {
    SFCustomLanguageModelData.CustomPronunciation(grapheme: "Darrin", phonemes: ["d", "ah", "hn"]) // custom for Darrin
}
