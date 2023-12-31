//
//  ChordTests.swift
//  443-ChordableTests
//
//  Created by Owen Gometz on 12/10/23.
//

import XCTest
import CoreData
@testable import _43_Chordable

class ChordTests: XCTestCase {

    var testCoreDataStack: TestCoreDataStack!
    var mockContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        super.setUp()
        testCoreDataStack = TestCoreDataStack()
        mockContext = testCoreDataStack.persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        mockContext = nil
        testCoreDataStack = nil
        super.tearDown()
    }

    func testFetchChordsWithDifficulty() {
        let request = Chord.fetchChords(filteredBy: "Easy", completed: nil, searchText: nil)
        XCTAssertEqual(request.predicate?.predicateFormat, "difficulty == \"Easy\"", "Predicate should match difficulty filter")
    }

    func testFetchChordsWithCompleted() {
        let request = Chord.fetchChords(filteredBy: nil, completed: true, searchText: nil)
        XCTAssertEqual(request.predicate?.predicateFormat, "completed == 1", "Predicate should match completed filter")
    }

    func testFetchChordsWithSearchText() {
        let request = Chord.fetchChords(filteredBy: nil, completed: nil, searchText: "A")
        XCTAssertTrue(request.predicate?.predicateFormat.contains("displayable_name BEGINSWITH[cd] \"a\"") ?? false, "Predicate should match search text filter")
    }

    func testFetchChordsWithSingleCharacterAndSpace() {
        let request = Chord.fetchChords(filteredBy: nil, completed: nil, searchText: "A ")
        XCTAssertEqual(request.predicate?.predicateFormat, "displayable_name ==[cd] \"a\"", "Predicate should match exact chord name filter")
    }

    func testFetchChordsWithMultipleSearchTerms() {
      let request = Chord.fetchChords(filteredBy: nil, completed: nil, searchText: "A minor")
      
      let namePredicateFormat = "displayable_name ==[cd] \"A\""
      let qualityPredicateFormat = "quality CONTAINS[cd] \"minor\""
      let expectedPredicateFormat = "\(namePredicateFormat) AND (\(qualityPredicateFormat))"
      
      XCTAssertEqual(request.predicate?.predicateFormat, expectedPredicateFormat, "Predicate should match combined name and quality filters")
    }

}
