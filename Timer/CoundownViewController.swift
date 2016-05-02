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
    let degreesOnCircle = 360.0
    // UI items
    var progressView: KDCircularProgress!
    lazy var buttonPlay = UIButton(type: .System)
    lazy var buttonReset = UIButton(type: .System)
    lazy var buttonMenu = UIButton(type: .System)
    lazy var labelTime = UILabel()
    var timerConfig: TimerConfig!
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
    func initPrepare() {
        labelTime.textColor = colorPause
        labelTime.text = Utilites.secondsToTimer(timerConfig.presets[1].seconds)
        buttonPlay.tintColor = colorPause
        buttonReset.tintColor = colorPause
        
        progressView.setColors(UIColor.yellowColor(), UIColor.orangeColor())
        progressView.angle = degreesOnCircle
        
        buttonMenu.tintColor = UIColor.yellowColor()
    }
    
    func initWorkout() {
        labelTime.textColor = colorPlay
        labelTime.text = Utilites.secondsToTimer(timerConfig.presets[1].seconds)
        buttonPlay.tintColor = colorPlay
        buttonReset.tintColor = colorPlay
        
        progressView.setColors(UIColor.cyanColor(), UIColor.greenColor())
        progressView.angle = degreesOnCircle
        
        buttonMenu.tintColor = UIColor.cyanColor()
    }
    
}

extension CoundownViewController: TimerModelProtocol{
    func didStateChanged() {
        if timerModel.state == .Prepare {
            initPrepare()
        } else {
            initWorkout()
        }
        
        
    }
    
    func didActivityChanged() {
        if !timerModel.isPaused {
            buttonPlay.setImage(UIImage.getPauseIcon(), forState: .Normal)
        } else {
            buttonPlay.setImage(UIImage.getPlayIcon(), forState: .Normal)
        }
    }
    
    func didTickTimer() {
        labelTime.text = Utilites.secondsToTimer( Int(ceil(timerModel.timerCoundownValue)) )
        progressView.angle = degreesOnCircle * ( timerModel.timerCoundownValue / Double(timerModel.timerMaxValue) )
    }
}
