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
    
    let greenColors = [UIColor.greenColor(), UIColor.cyanColor()]
    let yellowColors = [UIColor.yellowColor(), UIColor.orangeColor()]
    let redColors = [UIColor.redColor(), UIColor.orangeColor()]
    
    let animationLength = 0.3
    let buttonPlaySize = 44
    let verticaButtonlOffset = 60.0

    let buttonPlayOffsetX = 30
    
    let smallProgressSize = 220
    let bigProgressSize = 340
    let roundsProgressSize = 100
    
    let verticalTabateOffset = 40.0
    let verticalInfoOffset = -60.0
    // UI items
    var progressTimer: KDCircularProgress!
    var progressRounds: KDCircularProgress!
    var progressCircles: KDCircularProgress!
    
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var labelTime = UILabel()
    lazy var labelInfo = UILabel()
    lazy var labelClock = UILabel()
    
    var timerConfig: TimerConfig!
    var timerModel: TimerModel!
    weak var clockTimer: NSTimer? = nil
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
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
        
        updateTime()
    }
    
    override func viewWillDisappear(animated: Bool) {
        clockTimer?.invalidate()
        clockTimer = nil
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
            make.centerY.equalTo(self.view).offset(verticalInfoOffset - getTimerVerticalOffset)
            
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        labelTime.textColor = colorPause
        labelTime.font = Constants.Fonts.TimeLabelFontSize
        labelTime.textAlignment = .Center
        self.view.addSubview(labelTime)
        labelTime.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        progressTimer = KDCircularProgress(frame: CGRectZero)
        progressTimer.startAngle = -90
        progressTimer.progressThickness = 0.2
        progressTimer.trackThickness = 0.1
        progressTimer.clockwise = false
        progressTimer.gradientRotateSpeed = 2
        progressTimer.roundedCorners = false
        progressTimer.glowMode = .Constant
        progressTimer.glowAmount = 0.9
        progressTimer.trackColor = UIColor.darkGrayColor()
        progressTimer.setColorsArray(greenColors)
        self.view.addSubview(progressTimer)
        progressTimer.snp_makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(bigProgressSize)
        }
        
        progressRounds = KDCircularProgress(frame: CGRectZero)
        progressRounds.startAngle = -90
        progressRounds.progressThickness = 0.6
        progressRounds.trackThickness = 0.7
        progressRounds.clockwise = false
        progressRounds.roundedCorners = false
        progressRounds.glowMode = .Constant
        progressRounds.glowAmount = 0.9
        progressRounds.trackColor = UIColor.darkGrayColor()
        progressRounds.setColorsArray([UIColor.magentaColor()])
        self.view.addSubview(progressRounds)
        progressRounds.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self.view).offset(10)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.addTarget(self, action: #selector(CoundownViewController.clickPlayPause), forControlEvents: .TouchDown)
        self.view.addSubview(buttonPlay)
        buttonPlay.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
            make.width.height.equalTo(buttonPlaySize)
        }
        
        buttonReset.tintColor = colorButtons
        buttonReset.setImage(UIImage.getResetIcon(), forState: .Normal)
        buttonReset.addTarget(self, action: #selector(CoundownViewController.clickReset), forControlEvents: .TouchDown)
        self.view.addSubview(buttonReset)
        buttonReset.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
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
        print("deinit CountdownView")
        timerModel.stopTimer()
        
        clockTimer?.invalidate()
        clockTimer = nil
    }
    
    func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.Ended) {
            return
        }
        if timerModel.state != .Finished {
            timerModel.startStop()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
        }
        
        buttonPlay.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
        }
        
        buttonReset.snp_updateConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
        }
        
        labelInfo.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticalInfoOffset - getTimerVerticalOffset)
        }
        
        labelTime.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
        }
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
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.getPreviewValue())
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.hidden = false
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.view)
        }
        buttonPlay.enabled = true

        buttonReset.tintColor = colorButtons
        buttonReset.hidden = true
        
        progressRounds.hidden = true
        
        progressTimer.angle = 0
        progressTimer.clockwise = false
        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize * 3)
        }
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
    }
    
    func onPrepare() {
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause

        buttonPlay.tintColor = colorButtons
        buttonPlay.hidden = false

        buttonPlay.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
        }
        buttonPlay.enabled = true
        
        buttonReset.tintColor = colorButtons
        buttonReset.hidden = false
        buttonReset.enabled = false
        
        progressRounds.hidden = timerConfig.style != .Tabata
        
        progressTimer.clockwise = false
        progressTimer.setColorsArray(yellowColors)
        progressTimer.angle = 0
        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
       
    }
    
    func onWorkout() {
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPlay
            
        labelTime.textColor = colorPlay

        buttonPlay.tintColor = colorButtons
        buttonReset.tintColor = colorButtons
        
        progressRounds.hidden = timerConfig.style != .Tabata
        
        if timerConfig.style == .StopWatch {
            progressTimer.clockwise = true
        } else {
            progressTimer.clockwise = false
        }
        progressTimer.setColorsArray(greenColors)
        progressTimer.angle = degreesOnCircle
        
        buttonMenu.tintColor = colorPlay
        labelClock.textColor = colorPlay
    }
    
    func onFinished() {
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause
        
        buttonPlay.tintColor = colorPause
        buttonPlay.hidden = false
        buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        buttonPlay.snp_updateConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
        }
        buttonPlay.enabled = false
        
        buttonReset.tintColor = colorButtons
        buttonReset.hidden = false
        buttonReset.enabled = true
        
        progressTimer.setColorsArray(redColors)
        progressTimer.angle = degreesOnCircle
        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        progressTimer.clockwise = false
    }
    
    private func getProgressColors() -> [UIColor] {
        if timerModel.state == .Prepare {
            return yellowColors
        } else {
            return timerModel.isCriticalTimer ? redColors : greenColors
        }
    }
    
    private var getTimerVerticalOffset: Double {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            return 0.0
        } else {
            return timerConfig.style == .Tabata ? verticalTabateOffset : 0.0
        }
    }

    private var getRoundsVerticalOffset: Double {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            return 0.0
        } else {
            return 220.0
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
        case .Finished:
            onFinished()
        }
    }
    
    func didActivityChanged() {
        labelInfo.text = timerModel.informationString

        if timerModel.isPaused {
            buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
            buttonReset.enabled = true
            
            labelInfo.textColor = colorPause
            labelTime.textColor = colorPause
            buttonMenu.tintColor = UIColor.yellowColor()
            progressTimer.setColorsArray(yellowColors)
            labelClock.textColor = UIColor.yellowColor()
        } else {
            buttonPlay.setImage(UIImage.getPauseIcon(), forState: .Normal)
            buttonReset.enabled = false

            if timerModel.state != .Prepare {
                labelInfo.textColor = colorPlay
                labelTime.textColor = colorPlay
                progressTimer.setColorsArray(getProgressColors())
                buttonMenu.tintColor = UIColor.greenColor()
                labelClock.textColor = UIColor.greenColor()
            }
        }
    }
    
    func didTickTimer() {
        labelTime.text = Utilites.secondsToTimer( Int(timerModel.secondsToShow) )
        progressTimer.angle = timerModel.progressToShow
        progressTimer.setColorsArray(getProgressColors())
        
        progressRounds.angle = timerModel.progressRoundsToShow
    }
}

extension CoundownViewController: UIGestureRecognizerDelegate {
    
}