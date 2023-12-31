import Foundation
import SwiftUI
import CoreData


class ChordsViewController: ObservableObject {
    @Published var displayedChords: [Chord] = []
    @Published var filterOnCompleted: Bool = false {
        didSet {
            fetchChords()
        }
    }
    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    init() {
        fetchChords()
    }
  
    @Published var searchQuery: String = "" {
        didSet {
            fetchChords()
        }
    }
    func fetchChords() {
      let request: NSFetchRequest<Chord> = Chord.fetchChords(completed: filterOnCompleted, searchText: searchQuery)
      do {
          displayedChords = try viewContext.fetch(request)
      } catch {
          print("Failed to fetch chords: \(error)")
      }
    }
  
    func completeChord(_ chord: Chord) {
        chord.completed = true
        do {
            try viewContext.save()
        } catch {
            print("Failed to save completed state: \(error)")
        }
        fetchChords()
    }
}

