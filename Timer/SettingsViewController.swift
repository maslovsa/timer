//
//  SettingsViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var iconsSwitch: UISwitch!
    @IBOutlet weak var vibrateSwitch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem!.title = "Settings"
        loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadSettings() {
        vibrateSwitch.on = Utilites.isVibrateEnabled()
        iconsSwitch.on = Utilites.isUseIcons()
    }
    
    @IBAction func clickVibrate(sender: AnyObject) {
        defaults.setBool(vibrateSwitch.on, forKey: Constants.UserDefaultsKeys.UseActionVibrations)
        defaults.synchronize()
    }
    
    @IBAction func clickIcons(sender: AnyObject) {
        defaults.setBool(iconsSwitch.on, forKey: Constants.UserDefaultsKeys.UseActionIcons)
        defaults.synchronize()
    }
    
}