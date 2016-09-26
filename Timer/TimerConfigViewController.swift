//
//  TimerConfigViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 01.03.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit


class TimerConfigViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var timerConfig = TimerConfig.createStopWatch()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(TimerCell.self, forCellReuseIdentifier: TimerCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem!.title = timerConfig.title
        
        let button: UIButton = UIButton(type: UIButtonType.system)
        button.contentMode = .scaleAspectFit
        button.tintColor = Constants.Colors.MainThemeColor
        button.setTitle("Go", for: UIControlState())
        button.setImage(UIImage(named: "Exercise"), for: UIControlState())
        button.addTarget(self, action: #selector(TimerConfigViewController.clickGo), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func clickGo() {
        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoundownViewController") as! CoundownViewController
        controller.modalTransitionStyle = .crossDissolve
        controller.timerConfig = timerConfig
        self.present(controller, animated: true, completion: nil)
    }
}

extension TimerConfigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerConfig.prefCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerCellIdentifier, for: indexPath) as! TimerCell
        let preset = timerConfig.presets[(indexPath as NSIndexPath).row]
        cell.configure(preset)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension TimerConfigViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PickerViewController()
        vc.preset = timerConfig.presets[(indexPath as NSIndexPath).row]
        vc.completion = { [weak self](newValue) -> Void in
            self?.timerConfig.presets[(indexPath as NSIndexPath).row] = newValue
            self?.tableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
}

