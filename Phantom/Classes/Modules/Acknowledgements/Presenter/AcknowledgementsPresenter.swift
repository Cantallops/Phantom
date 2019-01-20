//
//  AcknowledgementsPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AcknowledgementsPresenter: Presenter<AcknowledgementsView> {

    let getAcknowledgements: Interactor<Any?, [Acknowledgement]>

    init(
        getAcknowledgements: Interactor<Any?, [Acknowledgement]> = GetAcknowledgementsInteractor()
    ) {
        self.getAcknowledgements = getAcknowledgements
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadSections()
    }

    private func loadSections() {
        let acknowledgements = getAcknowledgements.execute(args: nil)
        var sections: [UITableView.Section] = []

        let iconConf = AttributedTableViewCell.Conf(text: getIconText())
        iconConf.showSelection = false
        let uiIconsConf = AttributedTableViewCell.Conf(text: getUIIconsText())
        uiIconsConf.showSelection = false
        let iconSection = UITableView.Section(
            id: "Icons",
            header: SimpleTableSectionHeaderConf(title: "Icons"),
            cells: [iconConf, uiIconsConf],
            footer: EmptyTableSectionFooterConf(height: 20)
        )
        sections.append(iconSection)

        for acknowledgement in acknowledgements.value! {
            let cellConf = BasicTableViewCell.Conf(
                text: acknowledgement.text,
                textColor: Color.darkGrey,
                textFont: UIFont.systemFont(ofSize: 15)
            )
            cellConf.canSelect = false
            let section = UITableView.Section(
                id: acknowledgement.name,
                header: SimpleTableSectionHeaderConf(title: acknowledgement.name),
                cells: [cellConf],
                footer: EmptyTableSectionFooterConf(height: 20)
            )
            sections.append(section)
        }
        view.sections = sections
    }

    private func getIconText() -> NSAttributedString {
        let author = "Dimitry Miroliubov"
        let web = "www.flaticon.com"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: Color.darkGrey
        ]
        let text = NSMutableAttributedString(
            string: "App Icon made by \(author) from \(web)",
            attributes: attrs
        )
        text.setAsLink(textToFind: web, linkURL: "https://www.flaticon.com/")
        text.setAsLink(textToFind: author, linkURL: "https://www.flaticon.com/authors/dimitry-miroliubov")
        return text
    }

    private func getUIIconsText() -> NSAttributedString {
        let web = "Icons8"
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: Color.darkGrey
        ]
        let text = NSMutableAttributedString(string: "UI Icons by \(web)", attributes: attrs)
        text.setAsLink(textToFind: web, linkURL: "https://icons8.com/")
        return text
    }
}

private extension NSMutableAttributedString {
    @discardableResult
    func setAsLink(textToFind: String, linkURL: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
