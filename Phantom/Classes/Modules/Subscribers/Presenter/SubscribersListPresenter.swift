//
//  SubscribersListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SubscribersListPresenter: Presenter<SubscribersListView> {

    private let worker: Worker
    private let getSubscribers: Interactor<Meta?, Paginated<[Subscriber]>>
    private var meta: Meta?
    private var subscribers: [Subscriber] = []

    init(
        worker: Worker = AsyncWorker(),
        getSubscribers: Interactor<Meta?, Paginated<[Subscriber]>> = GetSubscribersInteractor()
    ) {
        self.worker = worker
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
        let task = Task(loaders: loaders, qos: .userInitiated, task: { [unowned self] in
            return self.getSubscribers.execute(args: self.meta)
        }, completion: { [weak self] result in
                switch result {
                case .success(let paginated):
                    self?.process(paginated: paginated)
                case .failure(let error):
                    self?.view.sections = []
                    self?.process(error: error)
                }
        })
        worker.execute(task: task)
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
