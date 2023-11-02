//
//  ChordDetailViewController.swift
//  443-Chordable
//
//  Created by Minjoo Kim on 10/31/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import Foundation
import SwiftUI
import AVFoundation

class ChordDetailViewController: NSObject, ObservableObject, AVAudioPlayerDelegate {
  @Published var status: AudioStatus = .stopped
  
  func viewDidLoad() {
    // configure audio permissions
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
        try session.setActive(true)
    } catch {
        print("AVAudioSession configuration error: \(error.localizedDescription)")
    }
  }
  
  var audioPlayer: AVAudioPlayer?
  
  
  // MARK: - Playing Audio -
  
  // playing audio
  func playChord(chordName: String) {
    // change audio file path for each chord
    guard let asset  = NSDataAsset(name: "\(chordName)_audio") else {
      print("File not found for chord: \(chordName)")
      return
    }
    do {
      audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint:"wav")
      audioPlayer?.delegate = self
      status = .playing
      audioPlayer?.play()
      status = .stopped
    } catch {
      print("Error playing chord file")
    }
  }
}