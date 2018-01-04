//
//  Picker.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

protocol Pickerable {
    var id: String { get }
    var name: String { get }
}

class Picker: TextField {

    fileprivate var picker: UIPickerView!
    var selectedOption: Pickerable? {
        didSet {
            text = selectedOption?.name
            if let option = selectedOption {
                onSelected(option)
            }
            updateSelected()
        }
    }
    var options: [Pickerable] = [] {
        didSet {
            picker?.reloadAllComponents()
            updateSelected()
        }
    }

    var onSelected: (Pickerable) -> Void = { _ in
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        inputView = picker
        disableActionsEditing = true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        let actions = ["paste:", "cut:", "delete:"]
        if actions.contains(action.description) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    private func updateSelected() {
        if let option = selectedOption {
            if let idx = options.index(where: { option.id == $0.id }), idx != picker?.selectedRow(inComponent: 0) {
                picker?.selectRow(idx, inComponent: 0, animated: false)
            }
        }
    }
}

extension Picker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let option = options[row]
        selectedOption = option
    }
}

extension Picker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let option = options[row]
        return option.name
    }
}
