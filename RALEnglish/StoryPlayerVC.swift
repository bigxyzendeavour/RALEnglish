
//  StoryPlayerVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class StoryPlayerVC: UIViewController, AVAudioPlayerDelegate, DFPlayerDelegate, DFPlayerDataSource {

    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomBtnView: UIView!
    
    var selectedMainCategory: String!
    var selectedContent: Content!
    var selectedPlayerModel: DFPlayerModel!
    var currentContentID: Int! //Index
    var contentList: [Content]!
    var player = AVAudioPlayer()
    var isInMiddle = false
    var subtitles: [String]!
    var totalLengthOfAudio = ""
    var audioLength = 0.0
    var timer: Timer!
    var currentIndex: IndexPath!
    var dfplayer: DFPlayer!
    var playerModels: [DFPlayerModel]!
    var dfplayerControlManager: DFPlayerControlManager!
    var selectedPlayerInfoModel: DFPlayerInfoModel!
    var lyricTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dfplayer.df_audioStop()
    }
    
    func initialize() {
        self.title = selectedContent.title
        
        UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
        
        initPlayer()
        initializeUI()
        playStory()
    }
    
    func initializeUI() {
        let fontColor = UIColor(red: 0.0, green: 96.0 / 255.0, blue: 202.0 / 255.0, alpha: 1)
        lyricTableView = dfplayerControlManager?.df_lyricTableView(withFrame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height: containerView.frame.height), contentInset: UIEdgeInsetsMake(0, 0, 120, 0), cellRowHeight: 60, cellBackgroundColor: UIColor.clear, currentLineLrcForegroundTextColor: nil, currentLineLrcBackgroundTextColor: fontColor, otherLineLrcBackgroundTextColor: .white, currentLineLrcFont: UIFont.init(name: "Arial", size: 19)!, otherLineLrcFont: UIFont(name: "Arial", size: 19)!, superView: containerView, click: {(IndexPath) -> Void in
        })
        
        containerView.addSubview(lyricTableView!)
    }
    
    func df_playerModelArray() -> [DFPlayerModel]! {
        for model in playerModels {
            print(model.audioId)
        }
        return playerModels
    }
    
    func df_playerAudioInfoModel(_ player: DFPlayer!) -> DFPlayerInfoModel! {
        let infoModel = DFPlayerInfoModel()
        print(dfplayer.currentAudioModel.audioId)
        if let content = contentList[Int(dfplayer.currentAudioModel.audioId)] as? StoryContent {
            infoModel.audioLyric = content.lyric
        }
        
        return infoModel;
    }
    
    func initPlayer() {
        dfplayer = DFPlayer.shareInstance()
        dfplayer.df_initPlayer(withUserId: nil)
        dfplayer.delegate = self
        dfplayer.dataSource = self
        dfplayer.category = DFPlayerAudioSessionCategory.playback
        dfplayer.isObserveWWAN = true
        
//        dfplayer.df_reloadData()
        
        dfplayerControlManager = DFPlayerControlManager.shareInstance()
        
        let imageWidth = playButton.frame.size.height - 20
        dfplayerControlManager.df_playPauseBtn(withFrame: CGRect(x: playButton.frame.midX - imageWidth/2, y: playButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: nil)
        let viewFrameWidth = self.view.frame.width
        let nextBtnMidX = viewFrameWidth * (7/8)
        dfplayerControlManager.df_nextAudioBtn(withFrame: CGRect(x: nextBtnMidX - imageWidth/2, y: nextButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            self.dfplayer.df_audioStop()
            self.currentContentID = self.currentContentID + 1
            if self.currentContentID > self.contentList.count - 1 {
                self.currentContentID = self.currentContentID - 1
                self.sendAlertWithoutHandler(alertTitle: "It's the last of the list", alertMessage: "", actionTitle: ["OK"])
            } else {
                self.updateTitle()
            }
        })
        let previousBtnMidX = viewFrameWidth * (1/8)
        dfplayerControlManager.df_lastAudioBtn(withFrame: CGRect(x: previousBtnMidX - imageWidth/2, y: previousButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            self.dfplayer.df_audioStop()
            self.currentContentID = self.currentContentID - 1
            if self.currentContentID < 0 {
                self.currentContentID = self.currentContentID + 1
                self.sendAlertWithoutHandler(alertTitle: "It's the beginning of the list", alertMessage: "", actionTitle: ["OK"])
            } else {
                self.updateTitle()
            }
        })
        let sliderWidth = viewFrameWidth - 32
        dfplayerControlManager.df_slider(withFrame: CGRect(x: 16, y: self.view.frame.size.height - 151, width: sliderWidth, height: sliderView.frame.height), minimumTrackTintColor: .white, maximumTrackTintColor: .white, trackHeight: 15, thumbSize: CGSize(width: 26, height: 26), superView: self.view)
        dfplayerControlManager.df_currentTimeLabel(withFrame: CGRect(x: 8 , y: self.view.frame.maxY - 113, width: startTimeLabel.frame.width, height: startTimeLabel.frame.height), superView: self.view)
        dfplayerControlManager.df_totalTimeLabel(withFrame: CGRect(x: self.view.frame.maxX - 63, y: self.view.frame.maxY - 113, width: endTimeLabel.frame.width, height: endTimeLabel.frame.height), superView: self.view)
        
        dfplayer.df_setPlayerWithPreviousAudioModel()
    }
    
    func df_playerDidPlay(toEndTime player: DFPlayer!) {
        self.updateTitle()
    }
    
    func updateTitle() {
        let content = contentList[Int(dfplayer.currentAudioModel.audioId)]
        self.title = content.title
    }
    
    func prepareAudio() {
        dfplayer.df_reloadData()
    }
    
    func playStory() {
        prepareAudio()
        dfplayer.df_playerPlay(withAudioId: UInt(currentContentID))
    }
    
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        dfplayer.df_audioStop()
    }
    
}
