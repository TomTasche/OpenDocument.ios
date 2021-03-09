//
//  OpenDocumentReaderTests.swift
//  OpenDocumentReaderTests
//
//  Created by Thomas Taschauer on 08.11.20.
//  Copyright © 2020 Thomas Taschauer. All rights reserved.
//

import XCTest

@testable import OpenDocumentReader

class OpenDocumentReaderTests: XCTestCase {
    
    // ONLINE fails on GitHub Actions for some reason
    private let ONLINE = false
    
    private var saveURL: URL?

    override func setUpWithError() throws {
        var fileURL: URL?
        
        let documentsURL = try
            FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        
        saveURL = documentsURL.appendingPathComponent("test.odt")
        
        if (FileManager.default.fileExists(atPath: saveURL!.path)) {
            return
        }
        
        if (ONLINE) {
            let url = URL(string: "https://api.libreoffice.org/examples/cpp/DocumentLoader/test.odt")
            
            let downloadTask = URLSession.shared.downloadTask(with: url!) {
                urlOrNil, responseOrNil, errorOrNil in
                
                fileURL = urlOrNil
            }
            downloadTask.resume()
        } else {
            let filePath = Bundle(for: type(of: self)).path(forResource: "test", ofType: "odt")
            fileURL = URL(fileURLWithPath: filePath!)
        }
        
        try FileManager.default.moveItem(at: fileURL!, to: self.saveURL!)
    }
    
    func testExample() throws {
        measure {
            let coreWrapper = CoreWrapper()
                            
            var translatePath = URL(fileURLWithPath: NSTemporaryDirectory())
            translatePath.appendPathComponent("translate.html")
            
            coreWrapper.translate(saveURL?.path, into: translatePath.path, at: 0, with: nil, editable: true)
            XCTAssertNil(coreWrapper.errorCode)
            
            var backTranslatePath = URL(fileURLWithPath: NSTemporaryDirectory())
            backTranslatePath.appendPathComponent("backtranslate.html")
            
            let diff = "{\"modifiedText\":{\"3\":\"This is a simple test document to demonstrate the DocumentLoadewwwwr example!\"}}"
            
            coreWrapper.backTranslate(diff, into: backTranslatePath.path)
            XCTAssertNil(coreWrapper.errorCode)
        }
    }
}
