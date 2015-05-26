//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Francisco Barrios on 22-04-15.
//  Copyright (c) 2015 Francisco Barrios. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {

    var filePath: NSURL!
    var title: String!
    
    /// - title: Name of the saved file
    /// - recordingFilePath: Path of the saved file
    
    init(title: String!, recordingFilePath: NSURL!) {
        self.title = title
        self.filePath = recordingFilePath
    }
}