//
//  SwitchTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SwitchTableViewCell: TableViewCell {

    typealias OnSwitch = (Bool) -> Void

    var onSwitch: OnSwitch?

    class Conf: TableCellConf {
        var text: String?
        var image: UIImage?
        var onSwitch: OnSwitch?
        var isOn: Bool

        init(
            text: String? = nil,
            image: UIImage? = nil,
            onSwitch: OnSwitch?,
            isOn: Bool = false
        ) {
            self.text = text
            self.image = image
            self.onSwitch = onSwitch
            self.isOn = isOn
            super.init(
                identifier: "SwitchCell",
                nib: UINib(nibName: "SwitchTableViewCell", bundle: nil)
            )
            self.canSelect = false
            self.estimatedHeight = 44
            self.height = 44
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        textLabel?.text = conf.text
        imageView?.image = conf.image
        onSwitch = { isOn in
            conf.isOn = isOn
            conf.onSwitch?(isOn)
        }
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(change(switchView:)), for: .valueChanged)
        switchView.isOn = conf.isOn
        accessoryView = switchView
    }

    @objc private func change(switchView: UISwitch) {
        onSwitch?(switchView.isOn)
    }
}
