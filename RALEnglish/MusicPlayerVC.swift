//
//  MusicPlayerVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-01.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import Firebase
import DKChainableAnimationKit

class MusicPlayerVC: UIViewController, DFPlayerDelegate, DFPlayerDataSource {

    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var cdImageView: UIImageView!
    @IBOutlet weak var sliderBlockerView: UIView!
    @IBOutlet weak var buttonBlockerLeftView: UIView!
    @IBOutlet weak var buttonBlockerRightView: UIView!
    @IBOutlet weak var sleepTimePlayButton: UIButton!
    @IBOutlet weak var sleepTimeStopButton: UIButton!
    @IBOutlet weak var sleepTimeButtonStackView: UIStackView!
    @IBOutlet weak var musicTimeButtonContainerView: UIView!
    @IBOutlet weak var playerModeOptionButton: UIButton!
    @IBOutlet weak var backgroupView: UIView!

    let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
    var dfplayer: DFPlayer!
    var playerModels: [DFPlayerModel]!
    var contentList = [MusicContent]()
    var dfplayerControlManager: DFPlayerControlManager!
    var currentContentID: Int!
    var selectedContent: Content!
    var selectedPlayerModel: DFPlayerModel!
    var selectedSubCategory: String!
    var currentTime = 0.0
    var viewAnimator: UIViewPropertyAnimator!
    var animationIsRunning = false
    var playerState = Enum().MUSIC_PLAYER_INACTIVE
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cdImageView.heightCircleView()
        customizeUI()
//        setupViewAnimator()
        
        if selectedSubCategory == Enum().MUSIC_SLEEP_TIME {
            self.initSleepTimePlayer()
            downloadSleepMusic { (playerModelsResult) in
                self.playerModels = playerModelsResult
                print(self.playerModels)
                self.playStory()
            }
        } else {
            self.title = selectedContent.title
            initPlayer()
            playStory()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dfplayer.df_audioStop()
        playerState = Enum().MUSIC_PLAYER_INACTIVE
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dfplayer.df_audioStop()
        playerState = Enum().MUSIC_PLAYER_INACTIVE
    }
    
    func customizeUI() {
        if selectedSubCategory == Enum().MUSIC_MUSIC_TIME {
            sleepTimeButtonStackView.removeFromSuperview()
        } else {
            sliderBlockerView.isHidden = false
            bottomStackView.removeFromSuperview()
        }
    }
    
    func downloadSleepMusic(completion: @escaping ([DFPlayerModel]) -> Void) {
        if playerModels == nil {
            playerModels = [DFPlayerModel]()
        }
        DataService.ds.REF_MUSIC.child("Sleep Time").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for i in 0..<snapShot.count {
                    let contentID = i
                    let data = snapShot[i].value as! Dictionary<String, Any>
                    let content = MusicContent(contentID: contentID, contentData: data)
                    self.contentList.append(content)
                    let model = DFPlayerModel()
                    model.audioId = UInt(NSInteger(content.contentID))
                    model.audioUrl = NSURL(string: content.contentURL) as! URL
                    self.playerModels.append(model)
                }
                completion(self.playerModels)
            }
        })
    }
    
    func initPlayer() {
        dfplayer = DFPlayer.shareInstance()
        dfplayer.df_initPlayer(withUserId: nil)
        dfplayer.delegate = self
        dfplayer.dataSource = self
        dfplayer.category = DFPlayerAudioSessionCategory.playback
        dfplayer.isObserveWWAN = true
        
        dfplayer.df_reloadData()
        
        dfplayerControlManager = DFPlayerControlManager.shareInstance()
        dfplayerControlManager.df_slider(withFrame: sliderView.frame, minimumTrackTintColor: .cyan, maximumTrackTintColor: .brown, trackHeight: 15, thumbSize: CGSize(width: 26, height: 26), superView: self.view)
        dfplayerControlManager.df_currentTimeLabel(withFrame: CGRect(x: startTimeLabel.frame.origin.x, y: startTimeLabel.frame.origin.y, width: startTimeLabel.frame.width, height: startTimeLabel.frame.height), superView: self.view)
        dfplayerControlManager.df_totalTimeLabel(withFrame: CGRect(x: endTimeLabel.frame.origin.x, y: endTimeLabel.frame.origin.y, width: endTimeLabel.frame.width, height: endTimeLabel.frame.height), superView: self.view)
        
        let imageWidth = playPauseButton.frame.size.height - 20
        dfplayerControlManager.df_playPauseBtn(withFrame: CGRect(x: playPauseButton.frame.midX - imageWidth/2, y: playPauseButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            if self.playerState == Enum().MUSIC_PLAYER_INACTIVE {
                self.rotateView(view: self.cdImageView, fromValue: 0.0)
                self.animationIsRunning = true
                self.playerState = Enum().MUSIC_PLAYER_ACTIVE
            } else if self.playerState == Enum().MUSIC_PLAYER_ACTIVE {
                if self.animationIsRunning == true {
                    self.pauseLayer(layer: self.cdImageView.layer)
                    self.animationIsRunning = false
                } else {
                    self.resumeLayer(layer: self.cdImageView.layer)
                    self.animationIsRunning = true
                }
            } else {
                self.stopAnimationForView(self.cdImageView)
                self.playerState = Enum().MUSIC_PLAYER_INACTIVE
                self.animationIsRunning = false
            }
        })
        dfplayerControlManager.df_typeControlBtn(withFrame: CGRect(x: playerModeOptionButton.frame.minX, y: playerModeOptionButton.frame.minY, width: playerModeOptionButton.frame.size.width, height: playerModeOptionButton.frame.size.height), superView: backgroupView, block: nil)
        
        dfplayerControlManager.df_nextAudioBtn(withFrame: CGRect(x: nextButton.frame.midX - imageWidth/2, y: nextButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            self.dfplayer.df_audioStop()
            self.cdImageView.stopAnimating()
            self.currentContentID = self.currentContentID + 1
            if self.currentContentID > self.contentList.count - 1 {
                self.currentContentID = self.currentContentID - 1
                self.sendAlertWithoutHandler(alertTitle: "It's the last of the list", alertMessage: "", actionTitle: ["OK"])
            } else {
                self.updateTitle()
                self.rotateView(view: self.cdImageView, fromValue: 0.0)
            }
        })
        dfplayerControlManager.df_lastAudioBtn(withFrame: CGRect(x: previousButton.frame.midX - imageWidth/2, y: previousButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            self.dfplayer.df_audioStop()
            self.currentContentID = self.currentContentID - 1
            if self.currentContentID < 0 {
                self.currentContentID = self.currentContentID + 1
                self.sendAlertWithoutHandler(alertTitle: "It's the beginning of the list", alertMessage: "", actionTitle: ["OK"])
            } else {
                self.updateTitle()
                self.rotateView(view: self.cdImageView, fromValue: 0.0)
            }
        })
        
        dfplayer.df_setPlayerWithPreviousAudioModel()
    }
    
    func initSleepTimePlayer() {
        dfplayer = DFPlayer.shareInstance()
        dfplayer.df_initPlayer(withUserId: nil)
        dfplayer.delegate = self
        dfplayer.dataSource = self
        dfplayer.category = DFPlayerAudioSessionCategory.playback
        dfplayer.isObserveWWAN = true
        dfplayer.playMode = .shuffleCycle
        
        dfplayer.df_reloadData()
        
        dfplayerControlManager = DFPlayerControlManager.shareInstance()
        
        let imageWidth = sleepTimePlayButton.frame.size.height
        dfplayerControlManager.df_playPauseBtn(withFrame: CGRect(x: sleepTimePlayButton.frame.midX - imageWidth/2, y: sleepTimePlayButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: buttonBlockerLeftView, block: {
            if self.playerState == Enum().MUSIC_PLAYER_INACTIVE {
                self.rotateView(view: self.cdImageView, fromValue: 0.0)
                self.animationIsRunning = true
                self.playerState = Enum().MUSIC_PLAYER_ACTIVE
            } else if self.playerState == Enum().MUSIC_PLAYER_ACTIVE {
                if self.animationIsRunning == true {
                    self.pauseLayer(layer: self.cdImageView.layer)
                    self.animationIsRunning = false
                } else {
                    self.resumeLayer(layer: self.cdImageView.layer)
                    self.animationIsRunning = true
                }
            } else {
                self.stopAnimationForView(self.cdImageView)
                self.playerState = Enum().MUSIC_PLAYER_INACTIVE
                self.animationIsRunning = false
            }
        })
        dfplayer.df_setPlayerWithPreviousAudioModel()
    }

    func playStory() {
        dfplayer.df_reloadData()
        if selectedSubCategory == Enum().MUSIC_SLEEP_TIME {
            currentContentID = Int(arc4random_uniform(UInt32(playerModels.count - 1)))
        }
        let model = playerModels[currentContentID]
        dfplayer.df_playerPlay(withAudioId: model.audioId)
        rotateView(view: cdImageView, fromValue: 0.0)
        playerState = Enum().MUSIC_PLAYER_ACTIVE
        animationIsRunning = true
    }
    
    func df_playerDidPlay(toEndTime player: DFPlayer!) {
        if selectedSubCategory == Enum().MUSIC_MUSIC_TIME {
            currentContentID = currentContentID + 1
            if currentContentID > contentList.count - 1 {
                currentContentID = 0
            } else {
                self.updateTitle()
                self.rotateView(view: cdImageView, fromValue: 0.0)
            }
        }
    }
    
    func df_playerModelArray() -> [DFPlayerModel]! {
        return playerModels
    }
    
    func df_playerAudioInfoModel(_ player: DFPlayer!) -> DFPlayerInfoModel! {
        let infoModel = DFPlayerInfoModel()
        return infoModel;
    }
    
    func updateTitle() {
        let content = contentList[Int(dfplayer.currentAudioModel.audioId)]
        self.title = content.title
    }
    
    func rotateView(view: UIView, fromValue: Double) {
//        let content = contentList[id]
//        let totalTime = content.contentLength
        UIView.animate(withDuration: TimeInterval(9999999)) {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = fromValue
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = TimeInterval(30)
            rotationAnimation.repeatCount = 999999
            
            view.layer.add(rotationAnimation, forKey: self.kRotationAnimationKey)
        }
    }
    
    func stopAnimationForView(_ myView: UIView) {
        
        //Get the current transform from the layer's presentation layer
        //(The presentation layer has the state of the "in flight" animation)
//        let transform = myView.layer.presentation()?.transform
        
        //Set the layer's transform to the current state of the transform
        //from the "in-flight" animation
//        myView.layer.transform = transform!
        
        //Now remove the animation
        //and the view's layer will keep the current rotation
        myView.layer.removeAllAnimations()
    }
    
    func stopAnimation(layer: CALayer) {
        layer.speed = 0.0
        layer.timeOffset = CFTimeInterval(0)
    }
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        dfplayer.df_audioStop()
        playerState = Enum().MUSIC_PLAYER_INACTIVE
        animationIsRunning = false
//        stopAnimationForView(cdImageView)
        stopAnimation(layer: self.cdImageView.layer)
    }
    
}

