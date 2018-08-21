
//  ContentPlayerVC.swift
//  EnglishCollection
//
//  Created by Grandon Lin on 2018-08-02.
//  Copyright © 2018 Grandon Lin. All rights reserved.
//

import UIKit
import AVFoundation

class ContentPlayerVC: UIViewController, AVAudioPlayerDelegate, DFPlayerDelegate, DFPlayerDataSource {

    @IBOutlet weak var containerView: UIScrollView!
    @IBOutlet weak var lastButtonView: UIView!
    @IBOutlet weak var playPauseButtonView: UIView!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
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
        dfplayer.df_audioPause()
    }
    
    func initialize() {
        self.title = selectedContent.title
        UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
        
        initPlayer()
        initializeUI()
        playStory()
    }
    
    func initializeUI() {
        lyricTableView = dfplayerControlManager?.df_lyricTableView(withFrame: containerView.frame, contentInset: UIEdgeInsetsMake(0, 0, 120, 0), cellRowHeight: 60, cellBackgroundColor: UIColor.clear, currentLineLrcForegroundTextColor: UIColor.purple, currentLineLrcBackgroundTextColor: .lightGray, otherLineLrcBackgroundTextColor: .lightGray, currentLineLrcFont: UIFont.init(name: "Chalkboard SE", size: 16)!, otherLineLrcFont: UIFont(name: "Chalkboard SE", size: 16)!, superView: containerView, click: {(IndexPath) -> Void in
        })
        
        containerView.addSubview(lyricTableView!)
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    func convertToSubtitle(content: String) {
        subtitles = content.components(separatedBy: "^")
    }
    
    func df_playerModelArray() -> [DFPlayerModel]! {
        return playerModels
    }
    
    func df_playerAudioInfoModel(_ player: DFPlayer!) -> DFPlayerInfoModel! {
//        let infoModel = DFPlayerInfoModel()
//        do {
//            infoModel.audioLyric = try String(contentsOfFile: Bundle.main.path(forResource: "lyric", ofType: "lrc")!, encoding: String.Encoding.utf8)
//            print(infoModel.audioLyric!)
//        } catch let err as NSError {
//            print(err)
//        }
//
//        return infoModel;
        
        let infoModel = DFPlayerInfoModel()
        infoModel.audioLyric = contentList[Int(dfplayer.currentAudioModel.audioId)].lyric
        print(infoModel.audioLyric!)
        
        return infoModel;
    }
    
    func df_playerAudioWillAdd(toPlayQueue player: DFPlayer!) {
        lyricTableView.reloadData()
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
//        dfplayerControlManager.df_bufferProgressView(withFrame: progressSlider.frame, trackTintColor: .green, progressTintColor: .red, superView: self.view!)
        dfplayerControlManager.df_slider(withFrame: sliderView.frame, minimumTrackTintColor: .cyan, maximumTrackTintColor: .brown, trackHeight: 15, thumbSize: CGSize(width: 26, height: 26), superView: self.view)
        dfplayerControlManager.df_currentTimeLabel(withFrame: CGRect(x: startTimeLabel.frame.origin.x, y: startTimeLabel.frame.origin.y, width: startTimeLabel.frame.width, height: startTimeLabel.frame.height), superView: self.view)
        dfplayerControlManager.df_totalTimeLabel(withFrame: CGRect(x: endTimeLabel.frame.origin.x, y: endTimeLabel.frame.origin.y, width: endTimeLabel.frame.width, height: endTimeLabel.frame.height), superView: self.view)
        
        let imageWidth = playButton.frame.size.height - 20
        dfplayerControlManager.df_playPauseBtn(withFrame: CGRect(x: playButton.frame.midX - imageWidth/2, y: playButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: nil)
        dfplayerControlManager.df_nextAudioBtn(withFrame: CGRect(x: nextButton.frame.midX - imageWidth/2, y: nextButton.frame.midY - imageWidth/2, width: imageWidth, height: imageWidth), superView: bottomStackView, block: {
            self.dfplayer.df_audioStop()
            self.currentContentID = self.currentContentID + 1
            if self.currentContentID > self.contentList.count - 1 {
                self.currentContentID = self.currentContentID - 1
                self.sendAlertWithoutHandler(alertTitle: "It's the last of the list", alertMessage: "", actionTitle: ["OK"])
            } else {
                self.updateTitle()
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
            }
        })
        
        dfplayer.df_setPlayerWithPreviousAudioModel()
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
        let model = playerModels[currentContentID]
        dfplayer.df_playerPlay(withAudioId: model.audioId)
    }
    
    @IBAction func stopBtnPressed(_ sender: UIButton) {
        dfplayer.df_audioStop()
    }
    
}
