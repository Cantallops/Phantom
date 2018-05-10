//
//  SubscribersListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SubscribersListPresenter: Presenter<SubscribersListView> {

    private let getSubscribers: Interactor<Meta?, Paginated<[Subscriber]>>
    private var meta: Meta?
    private var subscribers: [Subscriber] = []

    init(
        getSubscribers: Interactor<Meta?, Paginated<[Subscriber]>> = GetSubscribersInteractor()
    ) {
        self.getSubscribers = getSubscribers
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
            return self.getSubscribers.execute(args: self.meta)
            }, main: { [weak self] result in
                switch result {
                case .success(let paginated):
                    self?.process(paginated: paginated)
                case .failure(let error):
                    self?.view.sections = []
                    self?.process(error: error)
                }
        })
    }

    private func process(paginated: Paginated<[Subscriber]>) {
        meta = paginated.meta
        subscribers = paginated.object
        show(subscribers: subscribers)
    }

    private func show(subscribers: [Subscriber]) {
        if subscribers.isEmpty {
            view.sections = []
        } else {
            view.sections = [parse(subscribers: subscribers)]
        }
    }

    private func parse(subscribers: [Subscriber]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for subscriber in subscribers {
            let conf = BasicTableViewCell.Conf(text: subscriber.email)
            conf.deselect = true
            conf.canSelect = false
            cells.append(conf)
        }
        return UITableView.Section(id: "Subscribers", cells: cells)
    }

    private func process(error: Error) {
        show(error: error)
    }
}
