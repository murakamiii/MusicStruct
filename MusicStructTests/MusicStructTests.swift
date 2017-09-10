//
//  MusicStructTests.swift
//  MusicStructTests
//
//  Created by MURAKAMI on 2017/09/10.
//
//

import XCTest
@testable import MusicStruct

class MusicStructTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSong() {
        var musicTitle = "testSong"
        var musiclength = "12:34"
        var parts: [[String: String]]? = [["00:00": "イントロ"],
                                          ["00:33": "Aメロ"],
                                          ["03:22": "メロメロ"],
                                          ["10:00": "サビ"]]
        var testSong = Song.init(title: musicTitle,
                                 length: musiclength,
                                 musicParts: parts)!
        XCTAssertEqual(testSong.title,"testSong")
        XCTAssertEqual(testSong.length,754)
        XCTAssertEqual(testSong.musicParts?.first?.text, "イントロ")
        XCTAssertEqual(testSong.musicParts?.first?.range.lowerBound, 0)
        XCTAssertEqual(testSong.musicParts?.first?.range.upperBound, 33)
        XCTAssertEqual(testSong.musicParts?.last?.range.lowerBound, 600)
        XCTAssertEqual(testSong.musicParts?.last?.range.upperBound, 754)
        
        XCTAssertEqual(testSong.getTexts(currentTime: "00:01").prev, nil)
        XCTAssertEqual(testSong.getTexts(currentTime: "00:01").prime, "イントロ")
        XCTAssertEqual(testSong.getTexts(currentTime: "00:01").next, "Aメロ")
        
        XCTAssertEqual(testSong.getTexts(currentTime: "10:01").prev, "メロメロ")
        XCTAssertEqual(testSong.getTexts(currentTime: "10:01").prime, "サビ")
        XCTAssertEqual(testSong.getTexts(currentTime: "10:01").next, nil)
        
        musicTitle = "testSong2"
        musiclength = "12:34:56"
        parts = nil
        testSong = Song.init(title: musicTitle,
                             length: musiclength,
                             musicParts: parts)!

        XCTAssertEqual(testSong.length, 45296)
        XCTAssertNil(testSong.musicParts)
        XCTAssertNil(testSong.getTexts(currentTime: "10:01").prev)
        XCTAssertNil(testSong.getTexts(currentTime: "10:01").prime)
        XCTAssertNil(testSong.getTexts(currentTime: "10:01").next)
        
        musiclength = "12：34：56" //全角
        XCTAssertNil(Song.init(title: musicTitle,
                               length: musiclength,
                               musicParts: parts))
    }
    
}
