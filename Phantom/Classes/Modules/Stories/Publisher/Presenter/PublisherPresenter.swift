//
//  PublisherPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import PopupDialog

enum PublishAction {
    case none
    case publish
    case update
    case unpublish
    case schedule(Date)
    case unschedule
}

typealias OnPublishAction = (PublishAction, [Loader]?, @escaping (Result<Story>) -> Void) -> Void

class PublisherPresenter: Presenter<PublisherView> {

    private var story: Story
    private var publishDate: Date?
    private var publishAction: PublishAction = .none
    private let onPublishAction: OnPublishAction
    private let openRateAppNativeInteractor: Interactor<Account, Any?>

    init(
        story: Story,
        onPublishAction: @escaping OnPublishAction,
        openRateAppNativeInteractor: Interactor<Account, Any?> = OpenRateAppNativeInteractor()
    ) {
        self.story = story
        self.onPublishAction = onPublishAction
        self.openRateAppNativeInteractor = openRateAppNativeInteractor
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.onAccept = accept
        setUpView()
    }

    override func willAppear() {
        super.willAppear()
        view.presentingViewController?.view.isUserInteractionEnabled = false
    }

    override func willDisappear() {
        super.willDisappear()
        view.presentingViewController?.view.isUserInteractionEnabled = true
    }

    private func accept() {
        onPublishAction(publishAction, [view.acceptLoader], handleResult)
    }

    private func handleResult(_ result: Result<Story>) {
        switch result {
        case .success(let story):
            self.story = story
            view.dismiss(animated: true)
            askForRating()
        case .failure(let error):
            view.setError(error.localizedDescription)
        }
    }

    private func getActionTitle(forPusblishAction publishAction: PublishAction) -> String {
        switch publishAction {
        case .none: return ""
        case .publish: return "Publish"
        case .update: return "Update"
        case .unpublish: return "Unpublish"
        case .schedule: return "Schedule"
        case .unschedule: return "Unschedule"
        }
    }
    private func change(toPublishAction publishAction: PublishAction) {
        self.publishAction = publishAction
        view.acceptTitle = getActionTitle(forPusblishAction: publishAction)
    }

    private func setUpView() {
        var cells: [TableCellConf] = []
        publishDate = story.publishedAt

        let separator = SpaceTableViewCell.Conf(height: 10)

        switch story.status {
        case .published:
            view.title = "Update post status"
            let published = getPublished()
            published.initialySelected = true
            cells = [separator, getRevertToDraft(), separator, published]
        case .draft:
            view.title = "Ready to publish your post?"
            let publishNow = getPublishNow()
            publishNow.initialySelected = true
            cells = [separator, publishNow, separator, getScheduleCellConf()]
        case .scheduled:
            view.title = "Will be published"
            if let publishedAt = story.publishedAt, let colloquial = publishedAt.colloquial() {
                view.title = "Will be published \(colloquial)"
            }
            let schedule = getScheduleCellConf()
            schedule.initialySelected = true
            cells = [
                separator,
                getRevertToDraftFromScheduleCellConf(),
                separator,
                schedule
            ]
        }

        for cell in cells {
            cell.behaveAsRadioButton = true
            cell.showSelection = false
        }
        separator.behaveAsRadioButton = false

        let section = UITableView.Section(id: "Publisher", cells: cells)
        let sections = [section]
        view.sections = sections
    }

    private func getScheduleCellConf() -> TableCellConf {
        let schedule = TextFieldTableViewCell.Conf(
            title: "Schedule for later",
            textFieldPlaceholder: "",
            explain: "Set automatic future publish date",
            inputMode: .fullDate(current: story.publishedAt, max: nil, min: Date())
        )
        schedule.onChangeDate = { [weak self] _, date in
            self?.publishDate = date
            self?.change(toPublishAction: .schedule(date ?? .init()))
        }
        return schedule
    }

    private func getRevertToDraftFromScheduleCellConf() -> TableCellConf {
        let revertToDraftFromSchedule = SubtitleTableViewCell.Conf(text: "Revert to draft", subtitle: "Do not publish")
        revertToDraftFromSchedule.onSelect = { [weak self] in
            self?.change(toPublishAction: .unschedule)
        }
        return revertToDraftFromSchedule
    }

    private func getRevertToDraft() -> TableCellConf {
        let revertToDraft = SubtitleTableViewCell.Conf(text: "Unpublished",
                                                       subtitle: "Revert this post to a private draft")
        revertToDraft.onSelect = { [weak self] in
            self?.change(toPublishAction: .unpublish)
        }
        return revertToDraft
    }

    private func getPublishNow() -> TableCellConf {
        let publishNow = SubtitleTableViewCell.Conf(text: "Set it live now", subtitle: "Publish this post immediately")
        publishNow.onSelect = { [weak self] in
            self?.change(toPublishAction: .publish)
        }
        return publishNow
    }

    private func getPublished() -> TableCellConf {
        let published = SubtitleTableViewCell.Conf(text: "Published", subtitle: "Display this post publicly")
        published.onSelect = { [weak self] in
            self?.change(toPublishAction: .update)
        }
        return published
    }

    private func askForRating() {
        if let account = Account.current {
            openRateAppNativeInteractor.execute(args: account)
        }
    }
}
