//
//  Home.swift
//  443-Chordable
//
//  Created by Ariel Kwak on 11/30/23.
//

import Foundation
import CoreData

class HomeModel: ObservableObject {
    
    @Published var lastOpened: Date?
    @Published var streak: Int = 0

    init() {
    }

    func appOpened() {
        let now = Date()
        if let lastOpened = lastOpened {
            let calendar = Calendar.current
            if calendar.isDateInYesterday(lastOpened) {
                streak += 1
            } else if !calendar.isDateInToday(lastOpened) {
                streak = 1
            }
        } else {
            streak = 1
        }
        lastOpened = now
    }

    func fetchChords(context: NSManagedObjectContext) -> (total: Int, completed: Int) {
        let fetchRequest: NSFetchRequest<Chord> = Chord.fetchRequest()
        do {
            let chords = try context.fetch(fetchRequest)
            let completedChords = chords.filter { $0.completed }
            return (chords.count, completedChords.count)
        } catch {
            print("Failed to fetch chords: \(error)")
            return (0, 0)
        }
    }
  
    func fetchSongs(context: NSManagedObjectContext) -> (total: Int, unlocked: Int) {
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        do {
            let songs = try context.fetch(fetchRequest)
            let unlockedSongs = songs.filter { $0.unlocked }
            return (songs.count, unlockedSongs.count)
        } catch {
            print("Failed to fetch songs: \(error)")
            return (0, 0)
        }
    }
  
}