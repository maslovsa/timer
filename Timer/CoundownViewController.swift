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
    
    let colorPause = UIColor.yellowColor()
    let colorPlay = UIColor.greenColor()
    let buttonPlaySize = 44
    let verticaButtonlOffset = 55
    
    var progressView: KDCircularProgress!
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var labelTime = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTime.textColor = colorPause
        labelTime.font = Constants.Fonts.TimeLabelFontSize
        labelTime.textAlignment = .Center
        self.view.addSubview(labelTime)
        labelTime.snp_makeConstraints {
            (make) -> Void in
            make.centerX.centerY.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(55)
        }
        
        progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
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
        
        buttonPlay.tintColor = colorPause
        buttonPlay.setImage(UIImage(named: "Play"), forState: .Normal)
        buttonPlay.addTarget(self, action: #selector(CoundownViewController.clickPlayPause), forControlEvents: .TouchDown)
        self.view.addSubview(buttonPlay)
        buttonPlay.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(-30)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset)
            make.width.equalTo(buttonPlaySize)
            make.height.equalTo(buttonPlaySize)
        }
        
        buttonReset.tintColor = colorPause
        buttonReset.setImage(UIImage(named: "Rounds"), forState: .Normal)
        buttonReset.addTarget(self, action: #selector(CoundownViewController.clickReset), forControlEvents: .TouchDown)
        self.view.addSubview(buttonReset)
        buttonReset.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(30)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset)
            make.width.equalTo(buttonPlaySize)
            make.height.equalTo(buttonPlaySize)
        }
        
        buttonMenu.tintColor = UIColor.whiteColor()
        buttonMenu.layer.cornerRadius = 10
        buttonMenu.layer.masksToBounds = true
        buttonMenu.contentMode = .ScaleAspectFit
        buttonMenu.setImage(UIImage(named: "Menu"), forState: .Normal)
        buttonMenu.addTarget(self, action: #selector(CoundownViewController.clickMenu), forControlEvents: .TouchDown)
        self.view.addSubview(buttonMenu)
        buttonMenu.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(30)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //restartTimer()
        

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
    
    func clickPlayPause() {

    }
    
    func clickReset() {
        restartTimer()
    }
    
    func clickMenu() {
        self.tickTimer?.invalidate()
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func updateTime() {
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.labelTime.text = self.printTimerValue()
            self.progressView.angle = 360 * ( Double(self.timerCoundownValue) / Double(self.timerMaxValue) )
            print(self.progressView.angle)
            if self.timerCoundownValue == 0 {
                self.tickTimer?.invalidate()
            }
            self.timerCoundownValue -= 1
        }
    }

    private func restartTimer() {
        tickTimer?.invalidate()
        timerCoundownValue = 60 //(timer?.presets[0].seconds)!
        timerMaxValue = timerCoundownValue
        self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
        updateTime()
    }
    
    private func printTimerValue() -> String {
        let minutes = timerCoundownValue/60
        let seconds = timerCoundownValue - minutes * 60
        
        return NSString(format: "%02d:%02d", minutes,seconds) as String

    }
}
