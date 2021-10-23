//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var letterIndex = 0.0
        titleLabel.text = ""
        let letters = "⚡️FlashChat"
        
        for letter in letters {
            Timer.scheduledTimer(withTimeInterval: 0.1 * letterIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            letterIndex += 1
        }
    }

}
