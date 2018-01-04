//
//  TagsTableViewCell.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import WSTagsField

class TagsTableViewCell: TableViewCell {

    struct Tag {
        let id: String
        let name: String
    }

    typealias OnTagChangeClosure = ((Conf, [Tag]) -> Void)?

    @IBOutlet weak var titleLabel: Label!
     @IBOutlet weak private var tagsField: WSTagsField!
    private var suggestionsBar: UIToolbar!
    private var possibleTags: [Tag] = []

    class Conf: TableCellConf {

        weak var cell: TextViewTableViewCell?

        var title: String?
        var onTagsChange: OnTagChangeClosure
        var currentTags: [Tag]
        var possibleTags: [Tag]

        init(
            title: String? = nil,
            onTagsChange: OnTagChangeClosure = nil,
            currentTags: [Tag] = [],
            possibleTags: [Tag] = []
        ) {
            self.title = title
            self.onTagsChange = onTagsChange
            self.currentTags = currentTags
            self.possibleTags = possibleTags

            super.init(
                identifier: "TagsViewCell",
                nib: UINib(nibName: "TagsTableViewCell", bundle: nil)
            )
            self.showSelection = false
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tagsField.placeholder = ""

        tagsField.backgroundColor = .white
        tagsField.layer.cornerRadius = 4.0
        tagsField.layer.masksToBounds = true
        tagsField.layer.borderWidth = 1.0
        tagsField.layer.borderColor = Color.border.cgColor
        tagsField.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        tagsField.spaceBetweenTags = 5.0
        tagsField.font = UIFont.preferredFont(forTextStyle: .body)
        tagsField.tintColor = Color.tint
        tagsField.textColor = Color.white
        tagsField.fieldTextColor = .darkText
        tagsField.selectedColor = Color.darkGrey
        tagsField.selectedTextColor = Color.white
        tagsField.onDidChangeText = { _, text in
            self.reloadSuggestions(text: text ?? "")
        }
    }

    override func configure(with configuration: TableCellConf) {
        super.configure(with: configuration)
        guard let conf = configuration as? Conf else {
            // Add a warning
            return
        }
        titleLabel.text = conf.title
        suggestionsBar = UIToolbar()
        suggestionsBar.isTranslucent = false
        possibleTags = conf.possibleTags
        for currentTag in conf.currentTags {
            tagsField.addTag(currentTag.name)
        }
        reloadSuggestions()
        tagsField.onDidChangeHeightTo = { _, height in
            self.refreshHeight?()
        }
        tagsField.onDidAddTag = { tagsField, _ in
            self.changeTags(wsTags: tagsField.tags, conf: conf)
        }
        tagsField.onDidRemoveTag = tagsField.onDidAddTag
    }

    private func reloadSuggestions(text: String = "") {
        let suggestions = getSuggestions(forText: text)
        var items = generateBarButtonItems(forSuggestions: suggestions)
        if !text.isEmpty {
            let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTag))
            items.append(flex)
            items.append(add)
        }
        suggestionsBar.items = items
        suggestionsBar.sizeToFit()
        var frame = suggestionsBar.frame
        frame.size.height = 44
        suggestionsBar.frame = frame
        tagsField.inputFieldAccessoryView = suggestionsBar
    }

    private func getSuggestions(forText text: String) -> [Tag] {
        let toSuggest = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var suggestions = possibleTags.filter { tag -> Bool in
            return !self.tagsField.tags.contains(where: { wsTag -> Bool in
                return tag.name == wsTag.text
            })
        }
        if !toSuggest.isEmpty {
            suggestions = suggestions.filter { suggestion -> Bool in
                return suggestion.name.contains(toSuggest)
            }
        }
        return [Tag](suggestions.reversed().suffix(4))
    }

    private func generateBarButtonItems(forSuggestions suggestions: [Tag]) -> [UIBarButtonItem] {
        var items: [UIBarButtonItem] = []
        for possibleTag in suggestions {
            let item = UIBarButtonItem(
                title: possibleTag.name,
                style: .plain,
                target: self,
                action: #selector(selectTag(_:))
            )
            item.tintColor = .darkText
            items.append(item)
        }
        return items
    }

    private func changeTags(wsTags: [WSTag], conf: Conf) {
        let possibleTags = self.possibleTags
        let tags = wsTags.map { wsTag -> Tag in
            let t = possibleTags.filter { $0.name == wsTag.text }
            switch t.count {
            case 0: return Tag(id: "", name: wsTag.text)
            case 0...: return t.first!
            default:
                fatalError() // Count should be positive
            }
        }
        conf.onTagsChange?(conf, tags)
    }

    @objc private func selectTag(_ buttonItem: UIBarButtonItem) {
        tagsField.addTag(buttonItem.title!)
    }

    @objc private func addTag() {
        tagsField.acceptCurrentTextAsTag()
    }

}
