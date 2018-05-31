//
//  TeamListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TeamListPresenter: Presenter<TeamListView> {

    private let worker: Worker
    private let getMemberListInteractor: Interactor<Meta?, Paginated<[TeamMember]>>
    private var meta: Meta?
    private var users: [TeamMember] = []

    init(
        worker: Worker = AsyncWorker(),
        getMemberListInteractor: Interactor<Meta?, Paginated<[TeamMember]>> = GetMembersInteractor()
    ) {
        self.worker = worker
        self.getMemberListInteractor = getMemberListInteractor
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.refreshAction = loadList
        loadList()
    }

    private func loadList() {
        var loaders: [Loader] = [self]
        if let meta = meta, !meta.pagination.isFirst {
            loaders = []
        }
        let task = Task(loaders: loaders, qos: .userInitiated, task: { [unowned self] in
            return self.getMemberListInteractor.execute(args: self.meta)
        }, completion: { [weak self] result in
                switch result {
                case .success(let paginated): self?.process(paginated: paginated)
                case .failure(let error):
                    self?.view.sections = []
                    self?.process(error: error)
                }
        })
        worker.execute(task: task)
    }

    private func process(paginated: Paginated<[TeamMember]>) {
        meta = paginated.meta
        users = paginated.object
        show(users: users)
    }

    private func process(error: Error) {
        show(error: error)
    }

    private func show(users: [TeamMember]) {
        view.sections = parse(users: users)
    }

    private func parse(users: [TeamMember]) -> [UITableView.Section] {
        var activeCells: [TableCellConf] = []
        var inactiveCells: [TableCellConf] = []
        for user in users {
            let conf = TeamMemberTableViewCell.Conf(user: user)
            conf.accessoryType = .none
            conf.canSelect = false
            conf.deselect = true
            if user.status.isActiveStatus() {
                activeCells.append(conf)
            } else {
                inactiveCells.append(conf)
            }
        }
        var activeSection = UITableView.Section(
            id: "ActiveUsers",
            header: SimpleTableSectionHeader(title: "Active users"),
            cells: activeCells,
            footer: EmptyTableSectionFooter(height: 20)
        )
        if inactiveCells.isEmpty {
            activeSection.header = nil
            return [activeSection]
        }
        let inactiveSection = UITableView.Section(
            id: "InactiveUsers",
            header: SimpleTableSectionHeader(title: "Suspended users"),
            cells: inactiveCells,
            footer: EmptyTableSectionFooter(height: 20)
        )
        return [activeSection, inactiveSection]
    }
}
