//
//  ThreatViewController.swift
//  BlueScoreChallenge
//
//  Created by Umair Ahmad on 23/08/23.
//

import UIKit
import ConcentricProgressRingView

class ThreatViewController: UIViewController {
    @IBOutlet private var bluescoreLabel: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet private var tableView: UITableView!

    private var viewModel: ThreatViewModel!
    
    var blueScore = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ThreatViewModel()
        viewModel.bluescore = self.blueScore

        setupUI()
    }

    private func setupUI() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = threatColor(for: Int(viewModel.bluescore)).withAlphaComponent(0.4)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        scoreLabel.text = "\(Int(self.blueScore))"
        let rings = [
            ProgressRing(color: threatColor(for: Int(viewModel.bluescore)), backgroundColor: UIColor.darkGray, width: 25),
        ]

        let radius: CGFloat = 80
        let progressRingView = ConcentricProgressRingView(center: CGPoint.init(x: self.bluescoreLabel.center.x, y: self.bluescoreLabel.center.y - 30), radius: radius, margin: 0.0, rings: rings)

        bluescoreLabel.addSubview(progressRingView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            for ring in progressRingView {
                ring.setProgress(CGFloat(self.blueScore/100), duration: 0.5)
            }
        })
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0);
        tableView.register(UINib(nibName: "ThreatTableViewCell", bundle: nil), forCellReuseIdentifier: "ThreatTableViewCell")
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Determine the color based on the threat index
    private func threatColor(for threatIndex: Int) -> UIColor {
        switch threatIndex {
            case 1...20: return .systemGreen
            case 21...40: return .systemYellow
            case 41...60: return .systemOrange
            case 61...80: return .systemRed
            default: return .systemPink
        }
    }
}

extension ThreatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.threatLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreatTableViewCell", for: indexPath) as! ThreatTableViewCell

        let threatIndex = viewModel.threatLocations[indexPath.row].threatIndex
        cell.configure(threatIndex: threatIndex)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
