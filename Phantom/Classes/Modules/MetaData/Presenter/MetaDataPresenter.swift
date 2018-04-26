//
//  MetaDataPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 22/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

typealias OnEditMetaDataAction = (MetaData) -> Void

class MetaDataPresenter: Presenter<MetaDataView> {

    private var metaData: MetaData
    private var onEdit: OnEditMetaDataAction

    init(
        metaData: MetaData,
        onEdit: @escaping OnEditMetaDataAction
    ) {
        self.metaData = metaData
        self.onEdit = onEdit
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.sections = [UITableView.Section(id: "Meta", cells: getMetaDataFields())]
    }

    private func getMetaDataFields() -> [TableCellConf] {
        let metaTitleFieldCellConf = TextFieldTableViewCell.Conf(
            title: "Meta Title",
            textFieldText: metaData.title,
            textFieldPlaceholder: metaData.titleDefault,
            explain: "Recommended: 70 characters",
            onWrite: { [unowned self] _, text in
                self.metaData.title = text ?? ""
                self.onEdit(self.metaData)
            },
            countMode: .max(70)
        )

        let maxMetaDescriptionLenth = 156
        let metaDesc = metaData.descriptionDefault?
            .trunc(length: maxMetaDescriptionLenth-3)
            .replacing("\n", " ")
        let metaDescriptionTextViewCellConf = TextViewTableViewCell.Conf(
            title: "Meta Description",
            textViewText: metaData.description,
            textViewPlaceholder: metaDesc,
            explain: "Recommended: 156 characters",
            onWrite: { [unowned self] _, text in
                self.metaData.description = text ?? ""
                self.onEdit(self.metaData)
            },
            countMode: .max(maxMetaDescriptionLenth)
        )
        return [metaTitleFieldCellConf, metaDescriptionTextViewCellConf]
    }
}
