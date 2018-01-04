//
//  TeamListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TeamListPresenter: Presenter<TeamListView> {

    let getMemberListInteractor: Interactor<Meta?, Paginated<[TeamMember]>>
    var meta: Meta?
    var users: [TeamMember] = []

    init(
        getMemberListInteractor: Interactor<Meta?, Paginated<[TeamMember]>> = GetMembers()
    ) {
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
        async(loaders: loaders, background: { [unowned self] in
            return self.getMemberListInteractor.execute(args: self.meta)
        }, main: { [weak self] result in
            switch result {
            case .success(let paginated): self?.process(paginated: paginated)
            case .failure(let error):
                self?.view.sections = []
                self?.process(error: error)
            }
        })
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
            // FIXME: Remove when develop teammember's detail module
            conf.accessoryType = .none
            conf.canSelect = false
            // End fixme
            conf.deselect = true
            switch user.status {
            case .active:
                activeCells.append(conf)
            case .inactive:
                inactiveCells.append(conf)
            }
        }
        var activeSection = UITableView.Section(
            header: SimpleTableSectionHeader(title: "Active users"),
            cells: activeCells,
            footer: EmptyTableSectionFooter(height: 20)
        )
        if inactiveCells.isEmpty {
            activeSection.header = nil
            return [activeSection]
        }
        let inactiveSection = UITableView.Section(
            header: SimpleTableSectionHeader(title: "Suspended users"),
            cells: inactiveCells,
            footer: EmptyTableSectionFooter(height: 20)
        )
        return [activeSection, inactiveSection]
    }
}
