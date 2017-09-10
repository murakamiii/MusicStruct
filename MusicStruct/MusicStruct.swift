//
//  MusicStruct.swift
//  MusicStruct
//
//  Created by MURAKAMI on 2017/09/10.
//
//

import Foundation

struct Song {
    var title: String
    var length: Int
    var musicParts: [MusicPart]?
    
    init?(title: String, length: String, musicParts: [[String: String]]?) {
        guard let lengthInt = Song.hmsToInt(string: length) else {
            return nil
        }
        
        self.title = title
        self.length = lengthInt
        self.musicParts = Song.generateMusicPartArray(arr: musicParts, length:lengthInt)
    }

    static private func hmsToInt(string: String) -> Int? {
        // ss, mm:ss, hh:mm:ss を許容する
        let pattern = "(\\d{1,2}:){1,2}\\d{1,2}"
        guard let Regexp = try? NSRegularExpression(pattern: pattern, options:[]),
            Regexp.matches(in: string, options: [], range: NSMakeRange(0, (string as NSString).length)).count == 1 else {
                return nil
        }
        
        let lengthInt: Int = Array(string.components(separatedBy: ":").reversed())
            .enumerated()
            .map{ tuple in
                return Int(tuple.element)! * Int(pow(60.0, tuple.offset) as NSDecimalNumber)
            }.reduce (0, +)
        
        return lengthInt
    }
    
    static private func generateMusicPartArray(arr: [[String: String]]?, length: Int) -> [MusicPart]? {
        guard let arr = arr else {
            return nil
        }

        let musicParts: [MusicPart] = arr.enumerated().map { tuple -> MusicPart in
            let rangeEnd :Int = (arr.last! == tuple.element) ? length : hmsToInt(string: arr[tuple.offset + 1].keys.first!)!
            return MusicPart.init(range: hmsToInt(string:(tuple.element.keys.first!))!..<rangeEnd,
                                  text: tuple.element.values.first!)
        }
        
        return musicParts
    }
    
    func getTexts(currentTime: String) -> (prev: String?, prime: String?, next: String?) {
        guard let musicParts = self.musicParts else {
            return (nil,nil,nil)
        }
        
        var primeText: String?
        var prevText: String?
        var nextText: String?

        if let currentTimeInt: Int = Song.hmsToInt(string: currentTime),
            let index: Int = musicParts.index(where: {$0.range ~= currentTimeInt}) {
            primeText = musicParts[index].text
            
            if musicParts[index] != musicParts.first! {
                prevText = musicParts[musicParts.index(before: index)].text
            }
            
            if musicParts[index] != musicParts.last! {
                nextText = musicParts[musicParts.index(after: index)].text
            }
        }
        
        return (prevText, primeText, nextText)
    }
}

struct MusicPart: Equatable {
    var range: Range<Int>
    var text: String
    
    static func == (left : MusicPart, right : MusicPart) -> Bool {
        return left.range == right.range &&
        left.text == right.text
    }
}
