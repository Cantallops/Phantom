//
//  TextViewTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TextViewTableViewCell: TableViewCell {

    typealias OnWriteClosure = ((Conf, String?) -> Void)?

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var explainLabel: Label!
    @IBOutlet weak var countLabel: Label!

    class Conf: TableCellConf {

        weak var cell: TextViewTableViewCell?

        var title: String?
        var textViewText: String?
        var textViewPlaceholder: String?
        var onWrite: OnWriteClosure
        var explain: String? {
            didSet {
                cell?.explainLabel.text = explain
            }
        }
        var countMode: CountMode

        enum CountMode {
            case none
            case max(Int)
            case min(Int)
            case minMax(Int, Int)
        }

        init(
            title: String? = nil,
            textViewText: String? = nil,
            textViewPlaceholder: String? = nil,
            explain: String? = nil,
            onWrite: OnWriteClosure = nil,
            countMode: CountMode = .none
        ) {
            self.title = title
            self.textViewText = textViewText
            self.textViewPlaceholder = textViewPlaceholder
            self.explain = explain
            self.onWrite = onWrite
            self.countMode = countMode

            super.init(
                identifier: "TextViewCell",
                nib: UINib(nibName: "TextViewTableViewCell", bundle: nil)
            )

            self.estimatedHeight = 200
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.backgroundColor = Color.white
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        conf.cell = self
        titleLabel.text = conf.title
        explainLabel.text = conf.explain
        textView.text = conf.textViewText
        textView.placeholder = conf.textViewPlaceholder
        textView.onWrite = { [unowned self] text in
            conf.textViewText = text
            conf.onWrite?(conf, text)
            self.updateCount(mode: conf.countMode, text: text)
        }
        textView.onBecomeFirstResponder = { [weak self] in
            self?.selectItself()
        }
        updateCount(mode: conf.countMode, text: conf.textViewText)
    }

    private func updateCount(mode: Conf.CountMode, text: String?) {
        let number = text?.count ?? 0
        countLabel.text = "\(number)"
        switch mode {
        case .none: countLabel.text = nil
        case .max(let max): updateCountLabel(valid: number <= max)
        case .min(let min): updateCountLabel(valid: number >= min)
        case .minMax(let min, let max): updateCountLabel(valid: number >= min && number <= max)
        }
    }

    private func updateCountLabel(valid: Bool) {
        countLabel.textColor = valid ? Color.green : Color.red
    }
}
