//
//  ViewController.swift
//  Countet
//
//  Created by Mikhail Andriyuk on 28.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label:
    UILabel!
    var count = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func plusAction(_ sender: Any) {
        count = count + 1
        label.text = "\(count)"
    }
    
    @IBAction func minesAction(_ sender: Any) {
        count = count - 1
        label.text = "\(count)"
    }
}

