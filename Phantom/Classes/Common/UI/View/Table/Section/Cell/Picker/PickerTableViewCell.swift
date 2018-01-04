//
//  PickerTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class PickerTableViewCell: TableViewCell {

    typealias OnChangeClosure = ((Conf, Pickerable) -> Void)?

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var picker: Picker!
    @IBOutlet weak var explainLabel: Label!

    fileprivate var onChange: OnChangeClosure?

    class Conf: TableCellConf {

        weak var cell: TextFieldTableViewCell?

        var title: String?
        var selected: Pickerable?
        var options: [Pickerable]
        var placeholder: String?
        var onChange: OnChangeClosure?

        var explain: String? {
            didSet {
                cell?.explainLabel.text = explain
            }
        }

        init(
            title: String? = nil,
            selected: Pickerable? = nil,
            options: [Pickerable] = [],
            placeholder: String? = nil,
            explain: String? = nil,
            onChange: OnChangeClosure = nil
        ) {
            self.title = title
            self.selected = selected
            self.options = options
            self.placeholder = placeholder
            self.explain = explain
            self.onChange = onChange
            super.init(
                identifier: "PickerCell",
                nib: UINib(nibName: "PickerTableViewCell", bundle: nil)
            )
            self.estimatedHeight = 115
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        picker.backgroundColor = Color.white
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }

        titleLabel.text = conf.title
        picker.placeholder = conf.placeholder
        picker.selectedOption = conf.selected
        picker.options = conf.options
        picker.onSelected = { selected in
            conf.onChange??(conf, selected)
        }
        explainLabel.text = conf.explain
        picker.onBecomeFirstResponder = { [weak self] in
            self?.selectItself()
        }
    }

}
