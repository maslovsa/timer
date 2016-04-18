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
    var timerMaxValue = 0
    
    
    var progressView: KDCircularProgress!
    lazy var buttonPlay = UIButton()
    lazy var buttonReset = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        restartTimer()
        
        progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progressView.startAngle = -90
        progressView.progressThickness = 0.3
        progressView.trackThickness = 0.1
        progressView.clockwise = false
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = true
        progressView.glowMode = .Constant
        progressView.glowAmount = 0.9
        progressView.trackColor = UIColor.lightGrayColor()
        progressView.setColors( UIColor.cyanColor(), UIColor.greenColor())
        progressView.center = CGPoint(x: view.center.x, y: view.center.y + 25)
        self.view.addSubview(progressView)
        progressView.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(300)
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
            self.progressView.angle = 360 * ( Double(self.timerCoundownValue) / Double(self.timerMaxValue) )
            print(self.progressView.angle)
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
        timerCoundownValue = 60 //(timer?.presets[0].seconds)!
        timerMaxValue = timerCoundownValue
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
