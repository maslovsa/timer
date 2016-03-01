//
//  FirstViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

enum TimerStyle {
    case StopWatch
    case AMRAP
    case Tabata
}

class StopWatchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var type = TimerStyle.StopWatch
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        type = .StopWatch
        
        let nib = UINib(nibName: kMyCell, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: kMyCell)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension StopWatchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellRaw = tableView.dequeueReusableCellWithIdentifier(kMyCell, forIndexPath: indexPath)
        if let cell = cellRaw as? MyCell {
            cell.descriptionLabel.text = "1"
            
            return cell
        }

        
        return cellRaw
    }
}

