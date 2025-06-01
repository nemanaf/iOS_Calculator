//
//  ViewController.swift
//  iOS_Calculator
//
//  Created by Manaf A. on 31.05.25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func actionButton(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
            print("Button pressed: \(title)")
    }
}

