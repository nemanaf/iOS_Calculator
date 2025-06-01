//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Manaf A. on 31.05.25.
//

import UIKit

class ViewController: UIViewController {
    
    var currentTitle: String = "0"

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.text = "0"
    }

    @IBAction func actionButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
            print("Button pressed: \(title)")
        
        if "0"..."9" ~= title {
            if currentTitle == "0" {
                currentTitle = title
            } else {
                currentTitle += title
            }
            displayLabel.text = currentTitle
        }
    }
}

