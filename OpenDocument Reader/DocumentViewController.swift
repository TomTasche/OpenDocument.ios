//
//  DocumentViewController.swift
//  OpenDocument Reader
//
//  Created by Thomas Taschauer on 06.02.19.
//  Copyright © 2019 Thomas Taschauer. All rights reserved.
//

import UIKit
import WebKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    var document: UIDocument?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                var tempPath = URL(fileURLWithPath: NSTemporaryDirectory())
                tempPath.appendPathComponent("temp.html")
                
                CoreWrapper().translate(self.document?.fileURL.path, into: tempPath.path)
                
                self.webview.loadFileURL(tempPath, allowingReadAccessTo: tempPath)
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document?.close(completionHandler: nil)
        }
    }
}