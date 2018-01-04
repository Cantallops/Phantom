//
//  TeamMemberTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TeamMemberTableViewCell: TableViewCell {

    @IBOutlet weak var nameLabel: Label!
    @IBOutlet weak var lastSeenLabel: Label!
    @IBOutlet weak var roleView: UIView!
    @IBOutlet weak var roleLabel: Label!

    class Conf: TableCellConf {
        var user: TeamMember

        init(
            user: TeamMember
        ) {
            self.user = user
            super.init(
                identifier: "TeamMemberCell",
                nib: UINib(nibName: "TeamMemberTableViewCell", bundle: nil)
            )
            accessoryType = .disclosureIndicator
            estimatedHeight = 44
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        blockSelectChangeColor = [roleView]
        roleView.clipsToBounds = true
        roleView.layer.cornerRadius = 3
        roleView.layer.borderWidth = 0
        roleView.layer.borderColor = UIColor.clear.cgColor
        lastSeenLabel.text = ""
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        lastSeenLabel.text = ""
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        nameLabel.text = conf.user.name
        if let lastSeen = conf.user.lastSeen,
            let colloquialLastSeen = lastSeen.colloquial() {
            lastSeenLabel.text = "Last seen: \(colloquialLastSeen)"
        } else {
            lastSeenLabel.text = "Last seen: never"
        }
        roleView.backgroundColor = conf.user.role.backgroundColor
        roleLabel.textColor = conf.user.role.textColor
        roleLabel.text = conf.user.role.rawValue.capitalized
        if conf.user.role == .author {
            roleView.layer.borderWidth = 1
            roleView.layer.borderColor = Color.lightGrey.cgColor
        }
    }

}

fileprivate extension TeamMember.Role.Kind {
    var textColor: UIColor {
        if self == .author || self == .unknown {
            return Color.midGrey
        }
        return Color.white
    }
    var backgroundColor: UIColor {
        switch self {
        case .administrator: return Color.red
        case .editor: return Color.blue
        case .author: return .clear
        case .owner: return Color.black
        case .unknown: return .clear
        }
    }
}
