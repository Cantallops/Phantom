//
//  AboutPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AboutPresenter: Presenter<AboutView> {

    private let worker: Worker
    private let getAboutGhost: Interactor<Any?, AboutGhost>
    private let acknowledgementsFactory: Factory<UIViewController>

    init(
        worker: Worker = AsyncWorker(),
        getAboutGhost: Interactor<Any?, AboutGhost> = GetAboutGhostConfigurationInteractor(),
        acknowledgementsFactory: Factory<UIViewController> = AcknowledgementsFactory()
    ) {
        self.worker = worker
        self.getAboutGhost = getAboutGhost
        self.acknowledgementsFactory = acknowledgementsFactory
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadSections()
    }

    private func loadSections() {
        guard let account = Account.current, account.loggedIn else {
            setUpSections()
            return
        }
        let task = Task(loaders: [self], task: { [unowned self] in
            return self.getAboutGhost.execute(args: nil)
        }, completion: { [weak self] result in
            switch result {
            case .success(let about): self?.setUpSections(aboutGhost: about)
            case .failure(let error):
                self?.setUpSections()
                self?.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    private func setUpSections(aboutGhost: AboutGhost? = nil) {
        if let aboutGhost = aboutGhost {
            view.sections = getSections(aboutGhost: aboutGhost)
        } else {
            view.sections = getAppSections()
        }
    }

    private func getSections(aboutGhost: AboutGhost) -> [UITableView.Section] {
        var sections: [UITableView.Section] = [
            getAboutGhostSection(aboutGhost)
        ]
        sections.append(contentsOf: getAppSections())
        return sections
    }

    private func getAppSections() -> [UITableView.Section] {
        return [
            getAboutApp(Bundle.main),
            getAcknowledgementsSection()
        ]
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
            id: "About",
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
            id: "About \(bundle.appName)",
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
            id: "Acknowledgements",
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
