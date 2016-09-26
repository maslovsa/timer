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
    let colorPause = UIColor.yellow
    let colorPlay = UIColor.green
    let colorButtons = UIColor.white
    let colorRounds = UIColor.green
    let colorCycles = UIColor.cyan
    
    let greenColors = [UIColor.green, UIColor.cyan]
    let yellowColors = [UIColor.yellow, UIColor.orange]
    let redColors = [UIColor.red, UIColor.orange]
    let blueColors = [UIColor.blue, UIColor.cyan]
    
    let animationLength = 0.3
    let buttonPlaySize = 50
    let verticaButtonlOffset = 70.0

    let buttonPlayOffsetX = 35
    
    let smallProgressSize = 220
    let bigProgressSize = 340
    let roundsProgressSize = 120
    
    let verticalTabateOffset = 40.0
    let verticalInfoOffset = -60.0
    let progressCircleThickness: CGFloat = 0.5
    let progressCircleOffsetX = 30
    let lastAngle: Double = 0.0
    // UI items
    var progressTimer: KDCircularProgress!
    var progressRounds: KDCircularProgress!
    var progressCycles: KDCircularProgress!
    
    lazy var buttonPlay = UIButton(type: .system)
    lazy var buttonReset = UIButton(type: .system)
    lazy var buttonMenu = UIButton(type: .system)
    lazy var buttonLogo = UIButton(type: .custom)
    lazy var labelTime = UILabel()
    lazy var labelInfo = UILabel()
    lazy var labelClock = UILabel()
    lazy var labelRounds = UILabel()
    lazy var labelCycles = UILabel()
    
    
    var timerConfig: TimerConfig!
    var timerModel: TimerModel!
    weak var clockTimer: Foundation.Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dcgr = UITapGestureRecognizer(target: self, action: #selector(CoundownViewController.handleLongPress(_:)))
//        dcgr.delegate = self
//        dcgr.numberOfTapsRequired = 1
//        self.view.addGestureRecognizer(dcgr)
//        self.view.userInteractionEnabled = true
        
        timerModel = TimerModel(timerConfig: timerConfig)
        timerModel.delegate = self
        
        initUI()
        onReset()
        clockTimer = Foundation.Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CoundownViewController.updateTime), userInfo: nil, repeats: true)
        
        updateTime()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clockTimer?.invalidate()
        clockTimer = nil
    }
    
    func updateTime() {
        DispatchQueue.main.async {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.labelClock.text = dateFormatter.string(from: Date())
        }
    }
    
    func initUI(){
        
        labelClock.textColor = colorPause
        labelClock.font = Constants.Fonts.ClockLabelFontSize
        labelClock.textAlignment = .right
        self.view.addSubview(labelClock)
        labelClock.snp.makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(17)
            
            make.width.equalTo(150)
            make.height.equalTo(35)
        }
        
        
        labelInfo.textColor = colorPause
        labelInfo.font = Constants.Fonts.TimeLabelInfoFontSize
        labelInfo.textAlignment = .center
        self.view.addSubview(labelInfo)
        labelInfo.snp.makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(verticalInfoOffset - getTimerVerticalOffset)
            
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        labelTime.textColor = colorPause
        labelTime.font = Constants.Fonts.TimeLabelFontSize
        labelTime.textAlignment = .center
        self.view.addSubview(labelTime)
        labelTime.snp.makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(70)
        }
        
        labelRounds.textColor = colorRounds
        labelRounds.font = Constants.Fonts.RoundsLabelFontSize
        labelRounds.textAlignment = .center
        self.view.addSubview(labelRounds)
        labelRounds.snp.makeConstraints {
            (make) -> Void in
            make.left.equalTo(self.view).offset(progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        
        labelCycles.textColor = colorCycles
        labelCycles.font = Constants.Fonts.RoundsLabelFontSize
        labelCycles.textAlignment = .center
        self.view.addSubview(labelCycles)
        labelCycles.snp.makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        
        progressTimer = KDCircularProgress(frame: CGRect.zero)
        progressTimer.startAngle = -90
        progressTimer.progressThickness = 0.2
        progressTimer.trackThickness = 0.1
        progressTimer.clockwise = false
        progressTimer.gradientRotateSpeed = 2
        progressTimer.roundedCorners = false
        progressTimer.glowMode = .constant
        progressTimer.glowAmount = 0.9
        progressTimer.trackColor = UIColor.darkGray
        progressTimer.setColorsArray(greenColors)
        self.view.addSubview(progressTimer)
        progressTimer.snp.makeConstraints {
            (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
            make.width.equalTo(bigProgressSize)
            make.height.equalTo(bigProgressSize)
        }
        
        progressRounds = KDCircularProgress(frame: CGRect.zero)
        progressRounds.startAngle = -90
        progressRounds.progressThickness = progressCircleThickness
        progressRounds.trackThickness = progressCircleThickness
        progressRounds.clockwise = false
        progressRounds.roundedCorners = false
        progressRounds.glowMode = .noGlow
        progressRounds.glowAmount = 1.0
        progressRounds.trackColor = UIColor.darkGray
        progressRounds.setColorsArray([colorRounds])
        self.view.addSubview(progressRounds)
        progressRounds.snp.makeConstraints {
            (make) -> Void in
            make.left.equalTo(self.view).offset(progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        progressRounds.isHidden = true

        
        progressCycles = KDCircularProgress(frame: CGRect.zero)
        progressCycles.startAngle = -90
        progressCycles.progressThickness = progressCircleThickness
        progressCycles.trackThickness = progressCircleThickness
        progressCycles.clockwise = false
        progressCycles.roundedCorners = false
        progressCycles.glowMode = .noGlow
        progressCycles.glowAmount = 1.0
        progressCycles.trackColor = UIColor.darkGray
        progressCycles.setColorsArray([colorCycles])
        self.view.addSubview(progressCycles)
        progressCycles.snp.makeConstraints {
            (make) -> Void in
            make.right.equalTo(self.view).offset(-progressCircleOffsetX)
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
            make.width.equalTo(roundsProgressSize)
            make.height.equalTo(roundsProgressSize)
        }
        progressCycles.isHidden = true
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.setImage(UIImage.getPlayIcon(), for: UIControlState())
        buttonPlay.addTarget(self, action: #selector(CoundownViewController.clickPlayPause), for: .touchDown)
        self.view.addSubview(buttonPlay)
        buttonPlay.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
            make.width.height.equalTo(buttonPlaySize)
        }
        
        buttonReset.tintColor = colorButtons
        buttonReset.setImage(UIImage.getResetIcon(), for: UIControlState())
        buttonReset.addTarget(self, action: #selector(CoundownViewController.clickReset), for: .touchDown)
        self.view.addSubview(buttonReset)
        buttonReset.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view).offset(buttonPlayOffsetX)
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
            make.width.equalTo(buttonPlaySize)
            make.height.equalTo(buttonPlaySize)
        }
        
        buttonMenu.tintColor = UIColor.white
        buttonMenu.contentMode = .scaleAspectFit
        buttonMenu.setImage(UIImage.getMenuIcon(), for: UIControlState())
        buttonMenu.addTarget(self, action: #selector(CoundownViewController.clickMenu), for: .touchDown)
        self.view.addSubview(buttonMenu)
        buttonMenu.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(30)
        }
        
        buttonLogo.alpha = 0
        buttonLogo.contentMode = .scaleAspectFit
        buttonLogo.setImage(UIImage(named:"SteelwodLogo"), for: UIControlState())
        buttonLogo.addTarget(self, action: #selector(CoundownViewController.clickLogo), for: .touchDown)
        self.view.addSubview(buttonLogo)
        buttonLogo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-20)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    deinit {
        print("deinit CountdownView")
        timerModel.stopTimer()
        
        clockTimer?.invalidate()
        clockTimer = nil
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            clickPlayPause()
        }
    }
    
    func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizerState.ended) {
            return
        }
        if timerModel.state != .finished {
            timerModel.startStop()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        progressTimer.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
        }
        
        progressRounds.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }

        progressCycles.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }
        
        labelRounds.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }
        
        labelCycles.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(getRoundsVerticalOffset)
        }
        
        buttonPlay.snp.updateConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
        }
        
        buttonReset.snp.updateConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticaButtonlOffset - getTimerVerticalOffset)
        }
        
        labelInfo.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(verticalInfoOffset - getTimerVerticalOffset)
        }
        
        labelTime.snp.updateConstraints {
            (make) -> Void in
            make.centerY.equalTo(self.view).offset(-getTimerVerticalOffset)
        }
        
        
    }
    
    // MARK: Buttons
    func clickPlayPause() {
        Utilites.vibrate()
        timerModel.startStop()
    }
    
    func clickReset() {
        timerModel.reset()
    }
    
    func clickMenu() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func clickLogo() {
        if let requestUrl = URL(string: logoLink) {
            UIApplication.shared.openURL(requestUrl)
        }
    }
    
    // Mark: Private
    func onReset() {
        

        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.getPreviewValue())
        
        labelRounds.isHidden = true
        labelCycles.isHidden = true
        
        buttonPlay.tintColor = colorButtons
        buttonPlay.isHidden = false
        buttonPlay.setImage(UIImage.getPlayIcon(), for: UIControlState())
        buttonPlay.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view)
        }
        buttonPlay.isEnabled = true

        buttonReset.tintColor = colorButtons
        buttonReset.isHidden = true
        
        progressRounds.isHidden = true
        progressCycles.isHidden = true
        
        progressTimer.angle = 0
        progressTimer.clockwise = false
        progressTimer.snp.updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize * 3)
        }
        self.buttonLogo.alpha = 1
        UIView.animate(withDuration: animationLength, delay: 0.0, options: UIViewAnimationOptions(), animations: {
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
        buttonPlay.isHidden = false

        buttonPlay.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
        }
        buttonPlay.isEnabled = true
        
        buttonReset.tintColor = colorButtons
        buttonReset.isHidden = false
        buttonReset.isEnabled = false
        
        if timerConfig.style == .tabata {
            progressRounds.isHidden = false
            progressRounds.sectorsCount = timerConfig.presets[roundsIndex].value
            progressCycles.isHidden = false
            progressCycles.sectorsCount = timerConfig.presets[cyclesIndex].value
            
            labelRounds.isHidden = false
            labelCycles.isHidden = false

        }
        
        progressTimer.clockwise = false
        progressTimer.setColorsArray(yellowColors)
        progressTimer.angle = degreesOnCircle
        progressTimer.snp.updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        self.buttonLogo.alpha = 0
        UIView.animate(withDuration: animationLength, delay: 0.0, options: UIViewAnimationOptions(), animations: {
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
        
        progressRounds.isHidden = timerConfig.style != .tabata
        progressCycles.isHidden = timerConfig.style != .tabata
        
        if timerConfig.style == .stopWatch {
            progressTimer.angle = 0
            progressTimer.clockwise = true
        } else {
            progressTimer.angle = degreesOnCircle
            progressTimer.animateToAngle(degreesOnCircle, duration: 0.1, completion: nil)
            progressTimer.clockwise = false
        }
        progressTimer.setColorsArray(getProgressColors())
        
        
        buttonMenu.tintColor = getProgressColor()
        labelClock.textColor = getProgressColor()
    }
    
    func onFinished() {
        labelInfo.text = timerModel.informationString
        labelInfo.textColor = colorPause
        
        labelTime.textColor = colorPause
        
        buttonPlay.tintColor = colorPause
        buttonPlay.isHidden = false
        buttonPlay.setImage(UIImage.getPlayIcon(), for: UIControlState())
        buttonPlay.snp.updateConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-buttonPlayOffsetX)
        }
        buttonPlay.isEnabled = false
        
        buttonReset.tintColor = colorButtons
        buttonReset.isHidden = false
        buttonReset.isEnabled = true
        
        progressTimer.setColorsArray(redColors)
        progressTimer.angle = degreesOnCircle
        progressTimer.snp.updateConstraints {
            (make) -> Void in
            make.width.height.equalTo(bigProgressSize)
        }
        
        UIView.animate(withDuration: animationLength, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        buttonMenu.tintColor = colorPause
        labelClock.textColor = colorPause
        progressTimer.clockwise = false
    }
    
    fileprivate func getProgressColors() -> [UIColor] {
        if timerModel.state == .prepare {
            return yellowColors
        } else {
            if timerModel.isCriticalTimer {
                return redColors
            } else {
                if timerConfig.style != .tabata {
                    return greenColors
                } else {
                    return timerModel.isWork ? greenColors : blueColors
                }
            }
        }
    }
    
    fileprivate func getProgressColor() -> UIColor {
        if timerModel.state == .prepare {
            return UIColor.yellow
        } else {
            if timerModel.isCriticalTimer {
                return UIColor.green
            } else {
                if timerModel.isPaused {
                    return UIColor.yellow
                }
                
                if timerConfig.style != .tabata {
                    return UIColor.green
                } else {
                    return timerModel.isWork ? UIColor.green : UIColor.cyan
                }
            }
        }
    }
    
    fileprivate var getTimerVerticalOffset: Double {
        if UIDevice.current.orientation.isLandscape {
            return 0.0
        } else {
            return timerConfig.style == .tabata ? verticalTabateOffset : 0.0
        }
    }

    fileprivate var getRoundsVerticalOffset: Double {
        if UIDevice.current.orientation.isLandscape {
            return 0.0
        } else {
            return 180.0
        }
    }

}

extension CoundownViewController: TimerModelProtocol{
    func didStateChanged() {
        switch  timerModel.state {
        case .reset:
            onReset()
        case .prepare:
            onPrepare()
        case .workout:
            onWorkout()
        case .finished:
            onFinished()
        }
    }
    
    func didActivityChanged() {
        labelInfo.text = timerModel.informationString

        if timerModel.isPaused {
            buttonPlay.setImage(UIImage.getPlayIcon(), for: UIControlState())
            buttonReset.isEnabled = true
            
            labelInfo.textColor = getProgressColor()
            labelTime.textColor = getProgressColor()
            buttonMenu.tintColor = getProgressColor()
            progressTimer.setColorsArray(yellowColors)
            labelClock.textColor = getProgressColor()
        } else {
            buttonPlay.setImage(UIImage.getPauseIcon(), for: UIControlState())
            buttonReset.isEnabled = false

            if timerModel.state != .prepare {
                labelInfo.textColor = getProgressColor()
                labelTime.textColor = getProgressColor()
                progressTimer.setColorsArray(getProgressColors())
                buttonMenu.tintColor = getProgressColor()
                labelClock.textColor = getProgressColor()
            }
        }
    }
    
    func didTickTimer() {
        labelTime.text = Utilites.secondsToTimer( Int(ceil(timerModel.secondsToShow)) )

//      progressTimer.angle = timerModel.progressToShow
        print(timerModel.progressToShow)
        progressTimer.animateToAngle(timerModel.progressToShow, duration: timerModel.timerTickInterval, completion: nil)
        
        progressTimer.setColorsArray(getProgressColors())
        labelInfo.text = timerModel.informationString
        
        if timerConfig.style == .tabata {
            labelRounds.text = String(timerModel.roundsValue)
            labelCycles.text = String(timerModel.circleValue)
            progressRounds.angle = timerModel.progressRoundsToShow
            progressCycles.angle = timerModel.progressCyclesToShow
        }
    }
}

extension CoundownViewController: UIGestureRecognizerDelegate {
    
}
