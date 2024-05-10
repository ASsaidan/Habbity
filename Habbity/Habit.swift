//
//  Habit.swift
//  Habbity
//
//  Created by A.S on 2024-05-10.
//

import Foundation

struct Habit {
    let documentID: String
    let title: String
    let imageURL: String
    var status: Bool
    var streakCount: Int
    
    init(dictionary: [String: Any]) {
        self.documentID = dictionary["id"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.status = dictionary["status"] as? Bool ?? false
        self.streakCount = dictionary["streakCount"] as? Int ?? 0
    }
}
