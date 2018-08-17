
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
    
    //Test subtitles
    var contentSubs = "Once a princess found a ring in her garden,^which gave five stunning powers to her,^which only she can enjoy.^The five powers were:to sleep effortlessly,^to make fire without flint,^to make rain shower without clouds in the sky,^to grow a crop she wanted,^and to sing like an enchanted siren.^One day, a witch cast a spell all through the kingdom.^The witch took away to sleep, fire, rain, crops,^and songs from everyone in the kingdom.^All this made the princess cry for the helpless people.^She ran out to her balcony and kept singing for months together.^She sang about good and evil,^rain and fire, and so on.^She has sung for a year.^One day the princess slowly disintegrated into the wind,^and the kingdom came back to its original state.^She was never seen again but was just heard.^Every year, good people of her kingdom held a celebration for her!^"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        convertToSubtitle(content: contentSubs)
        
        initialize()
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
        dfplayerControlManager?.df_playerLyricTableviewStopUpdate()
    }
    
    func initialize() {
        self.title = selectedContent.title
        UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
        
        initPlayer()
        initializeUI()
    }
    
    func initializeUI() {
        lyricTableView = dfplayerControlManager?.df_lyricTableView(withFrame: containerView.frame, contentInset: UIEdgeInsetsMake(0, 0, 0, 0), cellRowHeight: 70, cellBackgroundColor: UIColor.clear, currentLineLrcForegroundTextColor: UIColor.purple, currentLineLrcBackgroundTextColor: .white, otherLineLrcBackgroundTextColor: .black, currentLineLrcFont: UIFont.init(name: "Chalkboard SE", size: 12)!, otherLineLrcFont: UIFont(name: "Chalkboard SE", size: 12)!, superView: containerView, click: {(IndexPath) -> Void in
        })
        containerView.addSubview(lyricTableView!)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subtitles.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let subtitle = subtitles[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell") as! SubtitleCell
//        cell.configureCell(subtitle: subtitle)
//        return cell
//    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return tableView.indexPathForSelectedRow
    }
    
    func convertToSubtitle(content: String) {
        subtitles = content.components(separatedBy: "^")
    }
    
    func df_player(_ player: DFPlayer!, bufferProgress: CGFloat, totalTime: CGFloat) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:player.currentAudioModel.audioId
//            inSection:0];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"正在缓冲%lf",bufferProgress];
//        cell.detailTextLabel.hidden = NO;
    }
    
    func df_player(_ player: DFPlayer!, progress: CGFloat, currentTime: CGFloat, totalTime: CGFloat) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:player.currentAudioModel.audioId
//            inSection:0];
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前进度%lf--当前时间%.0f--总时长%.0f",progress,currentTime,totalTime];
//        cell.detailTextLabel.hidden = NO;
    }
    
    func df_playerModelArray() -> [DFPlayerModel]! {
//        if !contentList.isEmpty || contentList != nil {
//            playerModels.removeAll()
//            for i in 0..<contentList.count {
//                let content = self.contentList[i]
//                let playerModel = DFPlayerModel()
//                playerModel.audioId = UInt(i)
//                playerModel.audioUrl = URL(string: content.contentURL)!
//                playerModels.append(playerModel)
//            }
//        }
        return playerModels
    }
    
    func df_playerAudioInfoModel(_ player: DFPlayer!) -> DFPlayerInfoModel! {
        let infoModel = DFPlayerInfoModel()
        do {
            infoModel.audioLyric = try String(contentsOfFile: Bundle.main.path(forResource: "lyric", ofType: "lrc")!, encoding: String.Encoding.utf8)
            print(infoModel.audioLyric!)
        } catch let err as NSError {
            print(err)
        }
//        infoModel.audioLyric = selectedContent.lyric
        
//        //歌词
//        NSString *lyricPath     = [[NSBundle mainBundle] pathForResource:yourModel.yourLyric ofType:nil];
//        infoModel.audioLyric    = [NSString stringWithContentsOfFile:lyricPath encoding:NSUTF8StringEncoding error:nil];

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
        dfplayerControlManager.df_bufferProgressView(withFrame: progressSlider.frame, trackTintColor: .green, progressTintColor: .red, superView: self.view!)
        dfplayerControlManager.df_slider(withFrame: progressSlider.frame, minimumTrackTintColor: .cyan, maximumTrackTintColor: .brown, trackHeight: 15, thumbSize: CGSize(width: 26, height: 26), superView: self.view)
        dfplayerControlManager.df_currentTimeLabel(withFrame: startTimeLabel.frame, superView: self.view)
        dfplayerControlManager.df_totalTimeLabel(withFrame: endTimeLabel.frame, superView: endTimeLabel)
        
        dfplayerControlManager.df_playPauseBtn(withFrame: CGRect(x: playButton.frame.origin.x, y: playButton.frame.origin.y, width: playButton.frame.width, height: playButton.frame.height), superView: playButton, block: nil)
        dfplayerControlManager.df_nextAudioBtn(withFrame: nextButton.frame, superView: nextButton, block: nil)
        dfplayerControlManager.df_lastAudioBtn(withFrame: previousButton.frame, superView: previousButton.imageView!, block: nil)
        
        dfplayer.df_setPlayerWithPreviousAudioModel()
    }
    
    func prepareAudio() {
//        player = try! AVAudioPlayer(data: self.selectedContent.contentData, fileTypeHint: "m4a")
//        player.delegate = self
//        audioLength = player.duration
//        progressSlider.maximumValue = CFloat(player.duration)
//        progressSlider.minimumValue = 0.0
//        progressSlider.value = 0.0
//        showTotalSongLength()
//        retrievePlayerProgressSliderValue()
        
        
//        selectedPlayerModel = DFPlayerModel()
//        selectedPlayerModel.audioId = UInt(currentContentID)
//        selectedPlayerModel.audioUrl = URL(string: selectedContent.contentURL)!

//        DFPlayer.shareInstance().df_setPlayerWithPreviousAudioModel()
        dfplayer.df_reloadData()
    }
    
    func playStory() {
//        player.play()
//        dfplayer.df_audioPlay()
        prepareAudio()
        let model = playerModels[currentContentID]
        dfplayer.df_playerPlay(withAudioId: model.audioId)
//        startTimer()
//        scrollUp()
//        do {
//            player.play()
//        } catch let err as NSError {
//            print(err)
//        }
//        player = AVPlayer(url: URL(string: self.selectedContent.contentURL)!)
//        player.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.delegate = self
        player.stop()
        playButton.setImage(UIImage(named: "Play"), for: .normal)
    }
    
    func retrievePlayerProgressSliderValue(){
        let progressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
        if progressSliderValue != 0 {
            progressSlider.value  = progressSliderValue
            player.currentTime = TimeInterval(progressSliderValue)
            
            let time = calculateTimeFromNSTimeInterval(player.currentTime)
            startTimeLabel.text  = "\(time.minute):\(time.second)"
            progressSlider.value = CFloat(player.currentTime)
            
        }else{
            progressSlider.value = 0.0
            player.currentTime = 0.0
            startTimeLabel.text = "00:00"
            
        }
    }
    
    func showTotalSongLength(){
        calculateSongLength()
        endTimeLabel.text = totalLengthOfAudio
    }
    
    func calculateSongLength(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        totalLengthOfAudio = "\(time.minute):\(time.second)"
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
        // let hour_   = abs(Int(duration)/3600)
        let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
        let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
        let second = second_ > 9 ? "\(second_)" : "0\(second_)"
        return (minute,second)
    }
    
    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update(_:)), userInfo: nil,repeats: true)
            timer.fire()
        }
    }
    
    func update(_ timer: Timer){
        if !player.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(player.currentTime)
        startTimeLabel.text  = "\(time.minute):\(time.second)"
        progressSlider.value = CFloat(player.currentTime)
        UserDefaults.standard.set(progressSlider.value , forKey: "playerProgressSliderValue")
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    
//    func scrollUp() {
//        let index = indexPathForPreferredFocusedView(in: tableView)
//        
//        self.delay(2){
//            self.tableView.scrollToRow(at: index!, at: .top, animated: true)
//            return self.scrollUp()
//        }
//    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
//        if player.isPlaying == true {
//            playButton.setImage(UIImage(named: "Play"), for: .normal)
//            player.pause()
//        } else {
//            playButton.setImage(UIImage(named: "Pause"), for: .normal)
//            if isInMiddle {
//                playStory()
//            } else {
//                prepareAudio()
//                playStory()
//                isInMiddle = true
//            }
////            var i = 0
////            let indexPath = IndexPath(row: i, section: 0)
////            repeat {
////                Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
////                    self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
////                    i += 1
////                })
////            } while i < subtitles.count
//            
//        }
//        dfplayer.df_playerPlay(withAudioId: UInt(currentContentID))
        playStory()
    }
    
    @IBAction func stopBtnPressed(_ sender: UIButton) {
//        isInMiddle = false
//        playButton.setImage(UIImage(named: "Play"), for: .normal)
//        UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
//        retrievePlayerProgressSliderValue()
//        player.stop()
        dfplayerControlManager?.df_playerLyricTableviewStopUpdate()
        
    }
    
    @IBAction func backwordBtnPressed(_ sender: UIButton) {
        
        if player.isPlaying == true {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            player.pause()
        }
        if currentContentID > 0 {
            selectedContent = contentList[currentContentID - 1]
            self.title = selectedContent.title
            currentContentID = currentContentID - 1
            UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
            prepareAudio()
//            selectedContent = contentList[currentContentID - 1]
//            self.title = selectedContent.title
//            currentContentID = currentContentID - 1
//            player = AVPlayer(url: URL(string: selectedContent.contentURL)!)
        } else {
            self.sendAlertWithoutHandler(alertTitle: "This is the first item", alertMessage: "", actionTitle: ["OK"])
        }
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        if player.isPlaying == true {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            player.pause()
        }
        if currentContentID == contentList.count - 1 {
            self.sendAlertWithoutHandler(alertTitle: "This is the last item", alertMessage: "", actionTitle: ["OK"])
        } else {
            selectedContent = contentList[currentContentID + 1]
            self.title = selectedContent.title
            currentContentID = currentContentID + 1
            UserDefaults.standard.set(0, forKey: "playerProgressSliderValue")
            prepareAudio()
//            selectedContent = contentList[currentContentID + 1]
//            self.title = selectedContent.title
//            currentContentID = currentContentID + 1
//            player = AVPlayer(url: URL(string: selectedContent.contentURL)!)
//            player.play()
        }
    }
    
    @IBAction func sliderTimeChanged(_ sender: UISlider) {
        player.currentTime = TimeInterval(sender.value)
        
    }
    
}
