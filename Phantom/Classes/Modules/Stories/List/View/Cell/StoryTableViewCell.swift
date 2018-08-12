//
//  StoryTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoryTableViewCell: TableViewCell {

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var statusBadge: BadgeView!
    @IBOutlet weak var authorLabel: Label!
    @IBOutlet weak var timeLabel: Label!

    class Conf: TableCellConf {
        var story: Story

        init(
            story: Story
        ) {
            self.story = story
            super.init(
                identifier: "StoryCell",
                nib: UINib(nibName: "StoryTableViewCell", bundle: nil)
            )
        }

        override func isEqual(_ object: Any?) -> Bool {
            return story == (object as? Conf)?.story
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        blockSelectChangeColor = [statusBadge]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
        authorLabel.text = ""
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        titleLabel.text = conf.story.title
        configure(badgeWith: conf)
        configure(authorWith: conf)
        configure(timeWith: conf)
        self.contentView.alpha = conf.story.editedWithKoeingEditor ? 0.5 : 1.0
    }

    private func configure(badgeWith conf: Conf) {
        statusBadge.showBorder = false
        statusBadge.text = conf.story.status.rawValue.capitalized
        statusBadge.color = conf.story.status.backgroundColor
        statusBadge.textColor = conf.story.status.textColor
        if conf.story.page && conf.story.status != .draft {
            statusBadge.text = "Page"
            statusBadge.color = UIColor.black
            statusBadge.textColor = Color.white
        }
    }

    private func configure(authorWith conf: Conf) {
        authorLabel.text = ""
        let authors = conf.story.getAuthors()
        if !authors.isEmpty {
            authorLabel.text = "by \(authors.compactMap({ $0.name }).joined(separator: ", "))"
        }
    }

    private func configure(timeWith conf: Conf) {
        let updatedAt = conf.story.updatedAt
        if conf.story.status == .draft, let colloquial = updatedAt.colloquial() {
            timeLabel.text = "— Last edited \(colloquial)"
        } else if let publishedAt = conf.story.publishedAt {
            if let colloquial = publishedAt.colloquial() {
                timeLabel.text = "— \(colloquial)"
            }
        }
    }
}

fileprivate extension Story.Status {
    var textColor: UIColor {
        switch self {
        case .published:
            return UIColor.darkText
        case .draft:
            return Color.white
        case .scheduled:
            return Color.white
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .published:
            return Color.lighterGrey
        case .draft:
            return Color.red
        case .scheduled:
            return Color.green
        }
    }
}
