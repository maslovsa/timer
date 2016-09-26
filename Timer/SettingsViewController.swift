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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem!.title = "Settings"
        loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadSettings() {
        vibrateSwitch.isOn = Utilites.isVibrateEnabled()
        iconsSwitch.isOn = Utilites.isUseIcons()
    }
    
    @IBAction func clickVibrate(_ sender: AnyObject) {
        defaults.set(vibrateSwitch.isOn, forKey: Constants.UserDefaultsKeys.UseActionVibrations)
        defaults.synchronize()
    }
    
    @IBAction func clickIcons(_ sender: AnyObject) {
        defaults.set(iconsSwitch.isOn, forKey: Constants.UserDefaultsKeys.UseActionIcons)
        defaults.synchronize()
    }
    
}
