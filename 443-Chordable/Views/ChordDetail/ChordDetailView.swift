//
//  ChordDetailView.swift
//  443-Chordable
//
//  Created by Owen Gometz on 10/29/23.
//  Audio code adapted from lesson: https://www.kodeco.com/21868250-audio-with-avfoundation/lessons/1

import SwiftUI
import AVFoundation

struct ChordDetailView: View {
  @ObservedObject var audio = ChordDetailViewController()
  @State var hasMicAccess = false
  @State var displayNotification = false
  
    let chord: Chord

  var body: some View {
    VStack {
      Text(chord.chord_name ?? "")
        .font(.largeTitle)
        .padding()
      
      Spacer()
    }
    .navigationTitle(chord.chord_name ?? "Chord Detail")
    
    Button {
      // record audio
      if audio.status == .stopped {
        if hasMicAccess {
          audio.record(forDuration: 5)
        } else {
          requestMicrophoneAccess()
        }
      } else {
        audio.stopRecording()
      }
    } label: {
      // change images from assets import
      Image(audio.status == .recording ?
            "button-record-active" :
              "button-record-inactive")
      .resizable()
      .scaledToFit()
    }
  }
  
  private func requestMicrophoneAccess() {
    AVAudioApplication.requestRecordPermission { granted in
      hasMicAccess = granted
      if granted {
        audio.record(forDuration: 5)
      } else {
        displayNotification = true
      }
    }
  }
}

//
//struct ChordDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChordDetailView()
//    }
//}

