//
//  CoundownViewController.swift
//  Timer
//
//  Created by Maslov Sergey on 17.04.16.
//  Copyright © 2016 Home. All rights reserved.
//

import UIKit


let logoLink = "http://www.steelwod.ru"

class CoundownViewController: UIViewController {
    let colorPause = UIColor.yellowColor()
    let colorPlay = UIColor.greenColor()
    let colorButtons = UIColor.whiteColor()
    let colorRounds = UIColor.greenColor()
    let colorCycles = UIColor.cyanColor()
    
    let greenColors = [UIColor.greenColor(), UIColor.cyanColor()]
    let yellowColors = [UIColor.yellowColor(), UIColor.orangeColor()]
    let redColors = [UIColor.redColor(), UIColor.orangeColor()]
    let blueColors = [UIColor.blueColor(), UIColor.cyanColor()]
    
    let animationLength = 0.3
    let buttonPlaySize = 44
    let verticaButtonlOffset = 60.0

    let buttonPlayOffsetX = 30
    
    let smallProgressSize = 220
    let bigProgressSize = 340
    let roundsProgressSize = 120
    
    let verticalTabateOffset = 40.0
    let verticalInfoOffset = -60.0
    let progressCircleThickness: CGFloat = 0.5
    let progressCircleOffsetX = 30
    
    // UI items
    var progressTimer: KDCircularProgress!
    var progressRounds: KDCircularProgress!
    var progressCycles: KDCircularProgress!
    
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var buttonLogo = UIButton(type: .Custom)
    lazy var labelTime = UILabel()
    lazy var labelInfo = UILabel()
    lazy var labelClock = UILabel()
    lazy var labelRounds = UILabel()
    lazy var labelCycles = UILabel()
    
    
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
        
        labelRounds.textColor = colorRounds
        labelRounds.font = Constants.Fonts.RoundsLabelFontSize
        labelRounds.textAlignment = .Center
        self.view.addSubview(labelRounds)
        labelRounds.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self.view).offset(progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        
        labelCycles.textColor = colorCycles
        labelCycles.font = Constants.Fonts.RoundsLabelFontSize
        labelCycles.textAlignment = .Center
        self.view.addSubview(labelCycles)
        labelCycles.snp_makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
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
        progressRounds.progressThickness = progressCircleThickness
        progressRounds.trackThickness = progressCircleThickness
        progressRounds.clockwise = false
        progressRounds.roundedCorners = false
        progressRounds.glowMode = .NoGlow
        progressRounds.glowAmount = 1.0
        progressRounds.trackColor = UIColor.darkGrayColor()
        progressRounds.setColorsArray([colorRounds])
        self.view.addSubview(progressRounds)
        progressRounds.snp_makeConstraints {
            (make) -> Void in
            make.left.equalTo(self.view).offset(progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        progressRounds.hidden = true

        
        progressCycles = KDCircularProgress(frame: CGRectZero)
        progressCycles.startAngle = -90
        progressCycles.progressThickness = progressCircleThickness
        progressCycles.trackThickness = progressCircleThickness
        progressCycles.clockwise = false
        progressCycles.roundedCorners = false
        progressCycles.glowMode = .NoGlow
        progressCycles.glowAmount = 1.0
        progressCycles.trackColor = UIColor.darkGrayColor()
        progressCycles.setColorsArray([colorCycles])
        self.view.addSubview(progressCycles)
        progressCycles.snp_makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        progressCycles.hidden = true
        
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
        
        buttonLogo.alpha = 0
        buttonLogo.contentMode = .ScaleAspectFit
        buttonLogo.setImage(UIImage(named:"SteelwodLogo"), forState: .Normal)
        buttonLogo.addTarget(self, action: #selector(CoundownViewController.clickLogo), forControlEvents: .TouchDown)
        self.view.addSubview(buttonLogo)
        buttonLogo.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(20)
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
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            clickPlayPause()
        }
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
        
        progressRounds.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }

        progressCycles.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }
        
        labelRounds.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }
        
        labelCycles.snp_updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
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
        Utilites.vibrate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickLogo() {
        if let requestUrl = NSURL(string: logoLink) {
            UIApplication.sharedApplication().openURL(requestUrl)
        }
    }
    
    // Mark: Private
    func onReset() {
        

        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.getPreviewValue())
        
        labelRounds.hidden = true
        labelCycles.hidden = true
        
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
        progressCycles.hidden = true
        
        progressTimer.angle = 0
        progressTimer.clockwise = false
        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize * 3)
        }
        self.buttonLogo.alpha = 1
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        
        Utilites.showWithAnimation(buttonLogo)
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
        
        if timerConfig.style == .Tabata {
            progressRounds.hidden = false
            progressRounds.sectorsCount = timerConfig.presets[roundsIndex].value
            progressCycles.hidden = false
            progressCycles.sectorsCount = timerConfig.presets[cyclesIndex].value
            
            labelRounds.hidden = false
            labelCycles.hidden = false

        }
        
        progressTimer.clockwise = false
        progressTimer.setColorsArray(yellowColors)
        progressTimer.angle = 0
        progressTimer.snp_updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        self.buttonLogo.alpha = 0
        UIView.animateWithDuration(animationLength, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        
    }
    
    func onWorkout() {
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = getProgressColor()
            
        labelTime.textColor = getProgressColor()

        buttonPlay.tintColor = colorButtons
        buttonReset.tintColor = colorButtons
        
        progressRounds.hidden = timerConfig.style != .Tabata
        progressCycles.hidden = timerConfig.style != .Tabata
        
        if timerConfig.style == .StopWatch {
            progressTimer.clockwise = true
        } else {
            progressTimer.clockwise = false
        }
        progressTimer.setColorsArray(getProgressColors())
        progressTimer.angle = degreesOnCircle
        
        buttonMenu.tintColor = getProgressColor()
        labelClock.textColor = getProgressColor()
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
            if timerModel.isCriticalTimer {
                return redColors
            } else {
                if timerConfig.style != .Tabata {
                    return greenColors
                } else {
                    return timerModel.isWork ? greenColors : blueColors
                }
            }
        }
    }
    
    private func getProgressColor() -> UIColor {
        if timerModel.state == .Prepare {
            return UIColor.yellowColor()
        } else {
            if timerModel.isCriticalTimer {
                return UIColor.greenColor()
            } else {
                if timerModel.isPaused {
                    return UIColor.yellowColor()
                }
                
                if timerConfig.style != .Tabata {
                    return UIColor.greenColor()
                } else {
                    return timerModel.isWork ? UIColor.greenColor() : UIColor.cyanColor()
                }
            }
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
            return 180.0
        }
    }

}

extension CoundownViewController: TimerModelProtocol{
    func didStateChanged() {
        Utilites.vibrate()
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
        Utilites.vibrate()
        labelInfo.text = timerModel.informationString

        if timerModel.isPaused {
            buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
            buttonReset.enabled = true
            
            labelInfo.textColor = getProgressColor()
            labelTime.textColor = getProgressColor()
            buttonMenu.tintColor = getProgressColor()
            progressTimer.setColorsArray(yellowColors)
            labelClock.textColor = getProgressColor()
        } else {
            buttonPlay.setImage(UIImage.getPauseIcon(), forState: .Normal)
            buttonReset.enabled = false

            if timerModel.state != .Prepare {
                labelInfo.textColor = getProgressColor()
                labelTime.textColor = getProgressColor()
                progressTimer.setColorsArray(getProgressColors())
                buttonMenu.tintColor = getProgressColor()
                labelClock.textColor = getProgressColor()
            }
        }
    }
    
    func didTickTimer() {
        labelTime.text = Utilites.secondsToTimer( Int(timerModel.secondsToShow) )
        progressTimer.angle = timerModel.progressToShow
        progressTimer.setColorsArray(getProgressColors())
        labelInfo.text = timerModel.informationString
        
        if timerConfig.style == .Tabata {
            labelRounds.text = String(timerModel.roundsValue)
            labelCycles.text = String(timerModel.circleValue)
            progressRounds.angle = timerModel.progressRoundsToShow
            progressCycles.angle = timerModel.progressCyclesToShow
        }
    }
}

extension CoundownViewController: UIGestureRecognizerDelegate {
    
}