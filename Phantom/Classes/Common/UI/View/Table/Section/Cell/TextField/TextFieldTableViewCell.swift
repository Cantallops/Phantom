//
//  TextFieldTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 29/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: TableViewCell {

    typealias OnWriteClosure = ((Conf, String?) -> Void)?
    typealias OnChangeDateClosure = ((Conf, Date?) -> Void)?

    @IBOutlet weak var titleLabel: Label!
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var explainLabel: Label!
    @IBOutlet weak var countLabel: Label!

    fileprivate var onChangeDate: ((Date?) -> Void)?

    class Conf: TableCellConf {

        weak var cell: TextFieldTableViewCell?

        var title: String?
        var textFieldText: String?
        var textFieldPlaceholder: String?
        var onWrite: OnWriteClosure
        var onChangeDate: OnChangeDateClosure
        var explain: String? {
            didSet {
                cell?.explainLabel.text = explain
            }
        }
        var countMode: CountMode
        var inputMode: InputMode

        enum InputMode {
            case normal
            case fullDate(current: Date?, max: Date?, min: Date?)
        }
        enum CountMode {
            case none
            case max(Int)
            case min(Int)
            case minMax(Int, Int)
        }

        init(
            title: String? = nil,
            textFieldText: String? = nil,
            textFieldPlaceholder: String? = nil,
            explain: String? = nil,
            onWrite: OnWriteClosure = nil,
            countMode: CountMode = .none,
            inputMode: InputMode = .normal
        ) {
            self.title = title
            self.textFieldText = textFieldText
            self.textFieldPlaceholder = textFieldPlaceholder
            self.explain = explain
            self.onWrite = onWrite
            self.countMode = countMode
            self.inputMode = inputMode
            super.init(
                identifier: "TextFieldCell",
                nib: UINib(nibName: "TextFieldTableViewCell", bundle: nil)
            )
            self.estimatedHeight = 115
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.backgroundColor = Color.white
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
        textField.text = conf.textFieldText
        textField.placeholder = conf.textFieldPlaceholder
        textField.onWrite = { text in
            conf.textFieldText = text
            conf.onWrite?(conf, text)
            self.updateCount(mode: conf.countMode, text: text)
        }
        textField.onBecomeFirstResponder = { [weak self] in
            self?.selectItself()
        }
        updateCount(mode: conf.countMode, text: conf.textFieldText)
        switch conf.inputMode {
        case .normal:
            textField.inputView = nil
            textField.disableActionsEditing = false
        case .fullDate(let current, let max, let min):
            makeDatePicker(current: current, max: max, min: min)
            textField.disableActionsEditing = true
            onChangeDate = { date in
                conf.onChangeDate?(conf, date)
            }
        }
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

extension TextFieldTableViewCell {
    func makeDatePicker(current: Date?, max: Date?, min: Date?) {
        let datePicker = UIDatePicker()
        datePicker.date = current ?? Date()
        datePicker.maximumDate = max
        datePicker.minimumDate = min
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.text = datePicker.date.formated()
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        textField.text = sender.date.formated()
        onChangeDate?(sender.date)
    }
}
