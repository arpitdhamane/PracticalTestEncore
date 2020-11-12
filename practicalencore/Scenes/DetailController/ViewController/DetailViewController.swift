//
//  DemoViewController.swift
//  practicalencore
//
//  Created by Mac Mini on 12/11/20.
//
//

import UIKit
import AVFoundation

final class DetailViewController: BaseViewController {

    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var imageAlbum: UIImageView!
    @IBOutlet weak var btnPlayPauseOutlet: UIButton!
    
    var viewModel = DetailViewModel()
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

    }

    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        self.lblSongTitle.text = self.viewModel.selectedAlbum!.value(forKeyPath: "title") as? String
        let strImageURL = self.viewModel.selectedAlbum!.value(forKeyPath: "image") as? String ?? ""
        self.imageAlbum.downloaded(from: strImageURL)
        let strAudioURL = self.viewModel.selectedAlbum!.value(forKeyPath: "link") as? String ?? ""

        let url = URL.init(string: strAudioURL)

        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player!)

        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        player.play()
        self.btnPlayPauseOutlet.setTitle("Pause", for: .normal)

    }

    @IBAction func btnPlayPauseAction(_ sender: Any) {
        if btnPlayPauseOutlet.currentTitle == "Pause" {
            self.btnPlayPauseOutlet.setTitle("Play", for: .normal)
            player.pause()
        } else {
            self.btnPlayPauseOutlet.setTitle("Pause", for: .normal)
            player.play()
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player.seek(to: CMTime.zero)
        self.btnPlayPauseOutlet.setTitle("Play", for: .normal)
        player.pause()
    }
}
