//
//  GameData.swift
//  straysaga
//
//  Created by Petre Chkonia on 07.10.24.
//

import Foundation

class GameData: NSObject, Codable {
    
    // MARK: - Properties
    
    var type: String = ""
    
    var gold: Int = 0
    var xp: Int = 0
    
    var skills: [String] = []
    
    var items: [String: Int] = [:]
    
    // Set up a shared instance of GameData
    static let shared: GameData = {
        let instance = GameData()
        
        return instance
    }()
    
    // MARK: - Init
    private override init() {}
    
    // MARK: - Save & Load Locally Stored Game Data
    func saveDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try PropertyListEncoder().encode(self)
            let dataFile = try NSKeyedArchiver.archivedData(withRootObject: data,
                                                            requiringSecureCoding: true)
            try dataFile.write(to: fullPath)
        } catch {
            print("Couldn't write Store Data file.")
        }
    }
    
    func loadDataWithFileName(_ filename: String) {
        let fullPath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let contents = try Data(contentsOf: fullPath)
            if let data = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSData.self, from: contents) as? Data {
                let gd = try PropertyListDecoder().decode(GameData.self, from: data)
                
                // Restore data (properties)
                type = gd.type
                gold = gd.gold
                xp = gd.xp
                skills = gd.skills
                
            }
        } catch {
            print("Couldn't load Store Data file.")
        }
    }
    
    // Get the user's documents directory
    fileprivate func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

