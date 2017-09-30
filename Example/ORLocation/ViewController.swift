//
//  ViewController.swift
//  ORLocation
//
//  Created by Maxim Soloviev on 09/11/2016.
//  Copyright (c) 2016 Maxim Soloviev. All rights reserved.
//

import UIKit
import ORLocation

class ViewController: UIViewController {

    @IBOutlet weak var labelCoord: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORCurrentLocationDetector.shared.detect { (loc) in
            self.labelCoord.text = loc != nil ? "\(loc!)" : "nil"
        }
    }
}
