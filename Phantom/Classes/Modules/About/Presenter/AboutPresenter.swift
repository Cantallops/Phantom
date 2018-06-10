//
//  AboutPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import MessageUI

class AboutPresenter: Presenter<AboutView> {

    private let worker: Worker
    private let getAboutGhost: Interactor<Any?, AboutGhost>
    private let acknowledgementsFactory: Factory<UIViewController>

    private var aboutGhost: AboutGhost?

    private var canSendFeedback: Bool {
        return MFMailComposeViewController.canSendMail()
    }

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
        let task = Task(loaders: [self], qos: .userInitiated, task: { [unowned self] in
            return self.getAboutGhost.execute(args: nil)
        }, completion: { [weak self] result in
            switch result {
            case .success(let about):
                self?.aboutGhost = about
                self?.setUpSections(aboutGhost: about)
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
            getMoreSection()
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
            header: SimpleTableSectionHeaderConf(title: "About Ghost"),
            cells: cells,
            footer: EmptyTableSectionFooterConf(height: 20)
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
            header: SimpleTableSectionHeaderConf(title: "About \(bundle.appName)"),
            cells: cells,
            footer: EmptyTableSectionFooterConf(height: 20)
        )
    }

    private func getMoreSection() -> UITableView.Section {
        var cells: [TableCellConf] = []
        if canSendFeedback {
            let feedbackCellConf = BasicTableViewCell.Conf(
                text: "Feedback",
                image: #imageLiteral(resourceName: "ic_table_feedback")
            )
            feedbackCellConf.onSelect = { [unowned self] in
                self.openFeedback()
            }
            feedbackCellConf.deselect = true
            cells.append(feedbackCellConf)
        }
        let acknowledgementsCellConf = BasicTableViewCell.Conf(
            text: "Acknowledgements",
            image: #imageLiteral(resourceName: "ic_table_acknowledge")
        )
        acknowledgementsCellConf.onSelect = { [unowned self] in
            self.openAcknowledgements()
        }
        acknowledgementsCellConf.deselect = true
        acknowledgementsCellConf.accessoryType = .disclosureIndicator
        cells.append(acknowledgementsCellConf)

        return UITableView.Section(
            id: "More",
            header: EmptyTableSectionHeaderConf(height: 20),
            cells: cells,
            footer: EmptyTableSectionFooterConf(height: 20)
        )
    }

    private func openAcknowledgements() {
        let acknowledgementsView = acknowledgementsFactory.build()
        view.navigationController?.pushViewController(acknowledgementsView, animated: true)
    }

    private func openFeedback() {
        if canSendFeedback {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients(["iosphantomeditor@gmail.com"])
            mailComposer.setSubject("Feedback Report")
            let bundle = Bundle.main
            var body = """
            \n\n
            \(bundle.appName):
            Version: \(bundle.versionNumber)
            Build: \(bundle.buildNumber)
            Device: \(UIDevice.current.model)
            OS Version: \(UIDevice.current.systemVersion)
            """
            if let aboutGhost = aboutGhost {
                body += """
                \n
                Ghost:
                \(aboutGhost.getMailReport())
                """
            }

            mailComposer.setMessageBody(body, isHTML: false)
            mailComposer.mailComposeDelegate = view

            view.present(mailComposer, animated: true, completion: nil)
        }
    }
}

private extension AboutGhost {
    func getMailReport() -> String {
        return """
        Version: \(version)
        Environment: \(environment)
        Database: \(database)
        Mail: \(mail)
        """
    }
}

extension AboutView: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print("Error: \(error)")
        }

        switch result {
        case .failed: print("Bug report send failed.")
        case .sent: print("Bug report sent!")
        default: break
        }

        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
