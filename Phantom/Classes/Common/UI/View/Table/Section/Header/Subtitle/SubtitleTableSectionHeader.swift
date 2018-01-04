//
//  SubtitleTableSectionHeader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

struct SubtitleTableSectionHeader: UITableViewSectionHeader {
    var customView: UIView
    init(title: String, subtitle: String) {
        let header = SubtitleTableSectionHeaderView()
        header.title = title
        header.subtitle = subtitle
        customView = header
    }
}

class SubtitleTableSectionHeaderView: UIView {

    @IBOutlet fileprivate weak var titleLabel: Label!
    @IBOutlet fileprivate weak var subtitleLabel: Label!
    private var view: UIView!
    var title: String = "" {
        didSet {
            titleLabel?.text = title
        }
    }

    var subtitle: String = "" {
        didSet {
            subtitleLabel?.text = subtitle
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func customInit() {
        setUpXib()
    }

    private func setUpXib() {
        view = loadViewFromNib(name: "SubtitleTableSectionHeaderView")
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
}
