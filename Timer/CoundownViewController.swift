//
//  CoundownViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 17.04.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit

class CoundownViewController: UIViewController {
    // Constants
    let colorPause = UIColor.yellowColor()
    let colorPlay = UIColor.greenColor()
    
    let buttonPlaySize = 44
    let verticaButtonlOffset = 55
    
    
    var timerConfig: TimerConfig!
    
    //2delete
    var tickTimer: NSTimer? = nil
    var timerCoundownValue = 0
    var timerMaxValue = 1
    
    // UI items
    var progressView: KDCircularProgress!
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var labelTime = UILabel()
    var timerModel: TimerModel!
    
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
        progressView.trackColor = UIColor.darkGrayColor()
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
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.addTarget(self, action: #selector(CoundownViewController.clickPlayPause), forControlEvents: .TouchDown)
        self.view.addSubview(buttonPlay)
        buttonPlay.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(-30)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset)
            make.width.equalTo(buttonPlaySize)
            make.height.equalTo(buttonPlaySize)
        }
        
        buttonReset.tintColor = colorPause
        buttonReset.setImage(UIImage.getResetIcon(), forState: .Normal)
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
        buttonMenu.setImage(UIImage.getMenuIcon(), forState: .Normal)
        buttonMenu.addTarget(self, action: #selector(CoundownViewController.clickMenu), forControlEvents: .TouchDown)
        self.view.addSubview(buttonMenu)
        buttonMenu.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(30)
        }
        
        timerModel = TimerModel(timerConfig: timerConfig)
        timerModel.delegate = self
        initPrepare()
    }

    func initPrepare() {
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.presets[1].seconds)
        buttonPlay.tintColor = colorPause
        buttonReset.tintColor = colorPause
        
        progressView.setColors(UIColor.yellowColor(), UIColor.orangeColor())
        progressView.angle = 360
        
        buttonMenu.tintColor = UIColor.yellowColor()
    }
    
    func initWorkout() {
        labelTime.textColor = colorPlay
        labelTime.text = Utilites.secondsToTimer(timerConfig.presets[1].seconds)
        buttonPlay.tintColor = colorPlay
        buttonReset.tintColor = colorPlay
        
        progressView.setColors(UIColor.cyanColor(), UIColor.greenColor())
        progressView.angle = 360
        
        buttonMenu.tintColor = UIColor.cyanColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func restartTimer() {
//        tickTimer?.invalidate()
//        
//        if timerCoundownValue == 0 {
//            timerCoundownValue = timerConfig.state == .Prepare ? timerConfig.presets[0].seconds : timerConfig.presets[1].seconds
//            timerMaxValue = timerCoundownValue
//        }
//        
//        self.tickTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
//        
//        
//        labelTime.text = Utilites.secondsToTimer(self.timerCoundownValue)
    }
    // MARK: Buttons
    
    func clickPlayPause() {
        
        timerModel.startStop()
//        switch timerConfig.style {
//        case .StopWatch, .AMRAP:
//            
//            if timerConfig.isActive {
//                timerConfig.isActive = false
//                buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
//                tickTimer?.invalidate()
//            } else {
//                timerConfig.isActive = true
//                buttonPlay.setImage(UIImage.getPauseIcon(), forState: .Normal)
//                
//                restartTimer()
//            }
//            
//            
//        case .Tabata:
//            print("stop")
//            
//        }
    }
    
    func clickReset() {
        timerModel.reset()
//        if timerConfig.state == TimerState.Prepare {
//            initPrepare()
//        } else {
//            
//        }
    }
    
    func clickMenu() {
        self.tickTimer?.invalidate()
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func updateTime() {
//        dispatch_async(dispatch_get_main_queue()) { 
//            
//            if self.timerCoundownValue == 0 {
//                self.tickTimer?.invalidate()
//                self.tickTimer = nil
//                
//                self.timerConfig.state = .Workout
//                self.initWorkout()
//                self.restartTimer()
//            }
//            self.timerCoundownValue -= 1
//
//            self.labelTime.text = Utilites.secondsToTimer(self.timerCoundownValue)
//            self.progressView.angle = 360 * ( Double(self.timerCoundownValue) / Double(self.timerMaxValue) )
//            print(self.progressView.angle)
//
//            
//        }
    }
    
}

extension CoundownViewController: TimerModelProtocol{
    func didStateChanged() {
        
    }
    
    func didTickTimer() {
        dispatch_async(dispatch_get_main_queue()) {
            self.labelTime.text = Utilites.secondsToTimer(Int(self.timerModel.timerCoundownValue) )
            self.progressView.angle = 360 * ( Double(self.timerModel.timerCoundownValue) / Double(self.timerModel.timerMaxValue) )
        }
    }
}
