//
//  CoundownViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 17.04.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class CoundownViewController: UIViewController {
    var timer: Timer?
    var tickTimer: NSTimer? = nil
    var timerCoundownValue = 0
    
    lazy var timeView1 = DDHTimerControl()
    lazy var timeView2 = DDHTimerControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        restartTimer()
        
        timeView1.color = UIColor.greenColor()
        timeView1.titleLabel.text = "sec"
        timeView1.minutesOrSeconds = timerCoundownValue
        timeView1.userInteractionEnabled = false
        self.view.addSubview(timeView1)
        timeView1.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
    }
    
    deinit {
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func updateTime() {
        dispatch_async(dispatch_get_main_queue()) { 
            self.printTimerValue()
            
            self.timeView1.minutesOrSeconds = self.timerCoundownValue
            
            if self.timerCoundownValue == 0 {
                self.tickTimer?.invalidate()
            }
            
            self.timerCoundownValue -= 1
        }
    }
    
    @IBAction func clickMenu(sender: UIButton) {
        self.tickTimer?.invalidate()
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func clickReset(sender: AnyObject) {
        restartTimer()
    }
    
    @IBAction func clickPlayPause(sender: AnyObject) {
        tickTimer?.invalidate()
    }
    
    private func restartTimer() {
        tickTimer?.invalidate()
        timerCoundownValue = (timer?.presets[0].seconds)!
        self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
        updateTime()
    }
    
    private func printTimerValue() {
        let minutes = timerCoundownValue/60
        let seconds = timerCoundownValue - minutes * 60
        
        let str = NSString(format: "%02d:%02d", minutes,seconds) as String
        
        print(str)

    }
}
