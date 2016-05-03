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
    let colorButtons = UIColor.whiteColor()
    let prepareText = "prepare"
    let pausedText = "paused"
    let readyText = "ready?"
    
    let greenColors = [UIColor.greenColor(), UIColor.cyanColor()]
    let yellowColors = [UIColor.yellowColor(), UIColor.orangeColor()]
    let redColors = [UIColor.redColor(), UIColor.orangeColor()]
    
    let animationLength = 0.3
    let buttonPlaySize = 44
    let verticaButtonlOffset = 60
    let degreesOnCircle = 360.0
    let buttonPlayOffsetX = 30
    
    let smallProgressSize = 220
    let bigProgressSize = 340
    
    // UI items
    var progressView: KDCircularProgress!
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var labelTime = UILabel()
    lazy var labelInfo = UILabel()
    lazy var labelClock = UILabel()
    
    var timerConfig: TimerConfig!
    var timerModel: TimerModel!
    var tickTimer: NSTimer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dcgr = UITapGestureRecognizer(target: self, action: #selector(CoundownViewController.handleLongPress(_:)))
        dcgr.delegate = self
        dcgr.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(dcgr)
        self.view.userInteractionEnabled = true
        
        timerModel = TimerModel(timerConfig: timerConfig)
        timerModel.delegate = self
        
        initUI()
        onReset()
        
        tickTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
        
        updateTime()
    }
    
    func updateTime() {
        dispatch_async(dispatch_get_main_queue()) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.labelClock.text = dateFormatter.stringFromDate(NSDate())
        }
    }
    
    func initUI(){
        
        labelClock.textColor = colorPause
        labelClock.font = Constants.Fonts.ClockLabelFontSize
        labelClock.textAlignment = .Right
        self.view.addSubview(labelClock)
        labelClock.snp_makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(17)
            
            make.width.equalTo(150)
            make.height.equalTo(35)
        }
        
        labelInfo.textColor = colorPause
        labelInfo.font = Constants.Fonts.TimeLabelInfoFontSize
        labelInfo.textAlignment = .Center
        self.view.addSubview(labelInfo)
        labelInfo.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60)
            
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        labelInfo.textColor = colorPause
        labelInfo.font = Constants.Fonts.TimeLabelInfoFontSize
        labelInfo.textAlignment = .Center
        self.view.addSubview(labelInfo)
        labelInfo.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60)
            
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        labelTime.textColor = colorPause
        labelTime.font = Constants.Fonts.TimeLabelFontSize
        labelTime.textAlignment = .Center
        self.view.addSubview(labelTime)
        labelTime.snp_makeConstraints {
            (make) -> Void in
            make.centerX.centerY.equalTo(self.view)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: bigProgressSize, height: bigProgressSize))
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
        progressView.trackThickness = 0.1
        progressView.clockwise = false
        progressView.gradientRotateSpeed = 2
        progressView.roundedCorners = false
        progressView.glowMode = .Constant
        progressView.glowAmount = 0.9
        progressView.trackColor = UIColor.darkGrayColor()
        progressView.setColorsArray(greenColors)
        self.view.addSubview(progressView)
        progressView.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(bigProgressSize)
        }
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.addTarget(self, action: #selector(CoundownViewController.clickPlayPause), forControlEvents: .TouchDown)
        self.view.addSubview(buttonPlay)
        buttonPlay.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset)
            make.width.height.equalTo(buttonPlaySize)
        }
        
        buttonReset.tintColor = colorButtons
        buttonReset.setImage(UIImage.getResetIcon(), forState: .Normal)
        buttonReset.addTarget(self, action: #selector(CoundownViewController.clickReset), forControlEvents: .TouchDown)
        self.view.addSubview(buttonReset)
        buttonReset.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset)
            make.width.equalTo(buttonPlaySize)
            make.height.equalTo(buttonPlaySize)
        }
        
        buttonMenu.tintColor = UIColor.whiteColor()
        buttonMenu.contentMode = .ScaleAspectFit
        buttonMenu.setImage(UIImage.getMenuIcon(), forState: .Normal)
        buttonMenu.addTarget(self, action: #selector(CoundownViewController.clickMenu), forControlEvents: .TouchDown)
        self.view.addSubview(buttonMenu)
        buttonMenu.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(30)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    deinit {
        timerModel.stopTimer()
        
        tickTimer?.invalidate()
        tickTimer = nil
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.Ended) {
            return
        }
        
        timerModel.startStop()
    }
    // MARK: Buttons
    func clickPlayPause() {
        timerModel.startStop()
    }
    
    func clickReset() {
        timerModel.reset()
    }
    
    func clickMenu() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark: Private
    func onReset() {
        labelInfo.text = readyText
        
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.getPreviewValue())
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.hidden = false
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.view)
        }
        
        buttonReset.tintColor = colorButtons
        buttonReset.hidden = true
        
        progressView.angle = 0
        progressView.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize * 3)
        }
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        progressView.clockwise = false
    }
    
    func onPrepare() {
        labelInfo.text = prepareText
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause

        buttonPlay.tintColor = colorButtons
        buttonPlay.hidden = false

        buttonPlay.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
        }

        buttonReset.tintColor = colorButtons
        buttonReset.hidden = false
        buttonReset.enabled = false

        progressView.setColorsArray(yellowColors)
        progressView.angle = 0
        progressView.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        progressView.clockwise = false
    }
    
    func onWorkout() {
        labelInfo.text = timerConfig.title
        labelInfo.textColor = colorPlay
            
        labelTime.textColor = colorPlay

        buttonPlay.tintColor = colorButtons
        buttonReset.tintColor = colorButtons
        
        progressView.setColorsArray(greenColors)
        progressView.angle = degreesOnCircle
        
        buttonMenu.tintColor = colorPlay
        labelClock.textColor = colorPlay
        
        if timerConfig.style == .StopWatch {
            progressView.clockwise = true
        } else {
            progressView.clockwise = false
        }
    }
    
    private func getProgressColors() -> [UIColor] {
        if timerModel.state == .Prepare {
            return yellowColors
        } else {
            return timerModel.isCriticalTimer ? redColors : greenColors
        }
    }
}

extension CoundownViewController: TimerModelProtocol{
    func didStateChanged() {
        switch  timerModel.state {
        case .Reset:
            onReset()
        case .Prepare:
            onPrepare()
        case .Workout:
            onWorkout()
        }
    }
    
    func didActivityChanged() {
        if timerModel.isPaused {
            labelInfo.text = pausedText
            buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
            buttonReset.enabled = true
            
            labelInfo.textColor = colorPause
            labelTime.textColor = colorPause
            buttonMenu.tintColor = UIColor.yellowColor()
            progressView.setColorsArray(yellowColors)
            labelClock.textColor = UIColor.yellowColor()
        } else {
            labelInfo.text = timerModel.state == .Prepare ? prepareText : timerConfig.title
            buttonPlay.setImage(UIImage.getPauseIcon(), forState: .Normal)
            buttonReset.enabled = false

            if timerModel.state != .Prepare {
                labelInfo.textColor = colorPlay
                labelTime.textColor = colorPlay
                progressView.setColorsArray(getProgressColors())
                buttonMenu.tintColor = UIColor.greenColor()
                labelClock.textColor = UIColor.greenColor()
            }
        }
    }
    
    func didTickTimer() {
        labelTime.text = Utilites.secondsToTimer( Int(timerModel.secondsToShow) )
        progressView.angle = timerModel.progressToShow
        progressView.setColorsArray(getProgressColors())
        
        labelClock.text = "12:23"
    }
}

extension CoundownViewController: UIGestureRecognizerDelegate {
    
}