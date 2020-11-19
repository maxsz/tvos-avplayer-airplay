//
//  ViewController.swift
//  AirPlayTest
//
//  Created by Maximilian Szengel on 17.11.20.
//

import UIKit
import AVKit

class ViewController: UIViewController {


	var routePickerView: AVRoutePickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func playVideo(_ sender: UIButton) {
//		playUsingAVPlayerViewController()
		playUsingAVPlayer()
    }

    var playerViewController: AVPlayerViewController?

	func playUsingAVPlayerViewController() {
		let player = createPlayer()

  		let pvc = AVPlayerViewController()
    	pvc.modalPresentationStyle = .fullScreen
    	self.playerViewController = pvc
  		pvc.player = player
		present(pvc, animated: true) {
            pvc.player?.play()
        }
    }


	var playerView: PlayerView?

    func playUsingAVPlayer() {
        let pv = PlayerView()
  		playerView = pv
    	view.addSubview(pv)
     	pv.translatesAutoresizingMaskIntoConstraints = false
     	view.leadingAnchor.constraint(equalTo: pv.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: pv.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: pv.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: pv.bottomAnchor).isActive = true

		let player = createPlayer()
        self.enableAirPlay()
		pv.player = player
        player.play()
//        self.enableAirPlay()
    }

    func enableAirPlay() {
    	player?.allowsExternalPlayback = true
    	player?.usesExternalPlaybackWhileExternalScreenIsActive = true

        let audioSession = AVAudioSession.sharedInstance()
  		do {
//    		try audioSession.setCategory(.playback, mode: .moviePlayback)
            try audioSession.setCategory(.playback, mode: .default, policy: .default, options: [])
            try audioSession.setActive(true)
        } catch {
        	print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }

	var player: AVPlayer?

    func createPlayer() -> AVPlayer {
        let url = URL(string: "http://ndrfs-lh.akamaihd.net/i/ndrfs_hh@430231/master.m3u8?b=320-4000")!
//  		let url = URL(string: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4")!
		let player = AVPlayer(url: url)

        self.player = player
		return player
    }
}

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
