//
//  AboutPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AboutPresenter: Presenter<AboutView> {

    private let getAboutGhost: Interactor<Any?, AboutGhost>
    private let acknowledgementsFactory: Factory<UIViewController>

    init(
        getAboutGhost: Interactor<Any?, AboutGhost> = GetAboutGhostConfiguration(),
        acknowledgementsFactory: Factory<UIViewController> = AcknowledgementsFactory()
    ) {
        self.getAboutGhost = getAboutGhost
        self.acknowledgementsFactory = acknowledgementsFactory
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadSections()
    }

    private func loadSections() {
        async(loaders: [self], background: { [unowned self] in
            return self.getAboutGhost.execute(args: nil)
        }, main: { [weak self] result in
            switch result {
            case .success(let about): self?.setUpSections(aboutGhost: about)
            case .failure(let error): self?.show(error: error)
            }
        })
    }

    private func setUpSections(aboutGhost: AboutGhost) {
        view.sections = getSections(aboutGhost: aboutGhost)
    }

    private func getSections(aboutGhost: AboutGhost) -> [UITableView.Section] {
        let sections: [UITableView.Section] = [
            getAboutGhostSection(aboutGhost),
            getAboutApp(Bundle.main),
            getAcknowledgementsSection()
        ]
        return sections
    }

    private func getAboutGhostSection(_ aboutGhost: AboutGhost) -> UITableView.Section {
        let versionConf = RightDetailTableViewCell.Conf(
            text: "Version",
            rightText: aboutGhost.version
        )
        versionConf.canSelect = false
        let envConf = RightDetailTableViewCell.Conf(
            text: "Environment",
            rightText: aboutGhost.environment
        )
        envConf.canSelect = false
        let dbConf = RightDetailTableViewCell.Conf(
            text: "Database",
            rightText: aboutGhost.database
        )
        dbConf.canSelect = false
        let mailConf = RightDetailTableViewCell.Conf(
            text: "Mail",
            rightText: aboutGhost.mail
        )
        mailConf.canSelect = false
        let cells: [TableCellConf] = [versionConf, envConf, dbConf, mailConf]
        return UITableView.Section(
            header: SimpleTableSectionHeader(title: "About Ghost"),
            cells: cells,
            footer: EmptyTableSectionFooter(height: 20)
        )
    }

    private func getAboutApp(_ bundle: Bundle) -> UITableView.Section {
        let versionConf = RightDetailTableViewCell.Conf(
            text: "Version",
            rightText: bundle.versionNumber
        )
        versionConf.canSelect = false
        let buildConf = RightDetailTableViewCell.Conf(
            text: "Build",
            rightText: bundle.buildNumber
        )
        buildConf.canSelect = false
        let cells: [TableCellConf] = [
            versionConf,
            buildConf
        ]
        return UITableView.Section(
            header: SimpleTableSectionHeader(title: "About \(bundle.appName)"),
            cells: cells,
            footer: EmptyTableSectionFooter(height: 20)
        )
    }

    private func getAcknowledgementsSection() -> UITableView.Section {
        let acknowledgementsCellConf = BasicTableViewCell.Conf(text: "Acknowledgements")
        acknowledgementsCellConf.onSelect = { [unowned self] in
            self.openAcknowledgements()
        }
        acknowledgementsCellConf.deselect = true
        acknowledgementsCellConf.accessoryType = .disclosureIndicator
        return UITableView.Section(
            header: EmptyTableSectionHeader(height: 20),
            cells: [acknowledgementsCellConf],
            footer: EmptyTableSectionFooter(height: 20)
        )
    }

    private func openAcknowledgements() {
        let acknowledgementsView = acknowledgementsFactory.build()
        view.navigationController?.pushViewController(acknowledgementsView, animated: true)
    }
}
