//
//  TagsListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagsListPresenter: Presenter<TagsListView> {

    private let tagInternalNotificationCenter: InternalNotificationCenter<Tag>
    private var tagObservers: [NSObjectProtocol] = []

    private let getTagsListInteractor: Interactor<Meta?, Paginated<[Tag]>>
    private let tagDetailBuilder: Builder<Tag?, UIViewController>
    private var meta: Meta?
    private var tags: [Tag] = []

    init(
        tagInternalNotificationCenter: InternalNotificationCenter<Tag>,
        getTagsListInteractor: Interactor<Meta?, Paginated<[Tag]>> = GetTagList(),
        tagDetailBuilder: Builder<Tag?, UIViewController> = TagDetailBuilder()
    ) {
        self.tagInternalNotificationCenter = tagInternalNotificationCenter
        self.getTagsListInteractor = getTagsListInteractor
        self.tagDetailBuilder = tagDetailBuilder
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadTagObservers()
        view.addTagAction = addTag
        view.refreshAction = loadTagList
        loadTagList()
    }

    private func loadTagObservers() {
        let newTagObserver = tagInternalNotificationCenter.addObserver(forType: .TagNew) { [unowned self] _ in
            self.loadTagList()
        }

        let deleteTagObserver = tagInternalNotificationCenter.addObserver(forType: .TagDelete) { [unowned self] tag in
            self.onDelete(tag: tag)
        }

        let editTagObserver = tagInternalNotificationCenter.addObserver(forType: .TagEdit) { [unowned self] tag in
            self.onEdit(tag: tag)
        }

        tagObservers = [newTagObserver, editTagObserver, deleteTagObserver]
    }

    private func loadTagList() {
        var loaders: [Loader] = [self]
        if let meta = meta, !meta.pagination.isFirst {
            loaders = []
        }
        async(loaders: loaders, background: { [unowned self] in
            return self.getTagsListInteractor.execute(args: self.meta)
        }, main: { [weak self] result in
            switch result {
            case .success(let paginated): self?.process(paginated: paginated)
            case .failure(let error):
                self?.view.sections = []
                self?.process(error: error)
            }
        })
    }

    private func process(paginated: Paginated<[Tag]>) {
        meta = paginated.meta
        tags = paginated.object
        show(tags: tags)
    }

    private func process(error: Error) {
        show(error: error)
    }

    private func show(tags: [Tag]) {
        if tags.isEmpty {
            view.sections = []
        } else {
            view.sections = [parse(tags: tags)]
        }
    }

    private func parse(tags: [Tag]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for tag in tags {
            var rightText = ""
            if let count = tag.count {
                rightText = "\(count.posts)"
            }
            let conf = RightDetailTableViewCell.Conf(
                text: tag.name,
                rightText: rightText
            )
            conf.deselect = true
            conf.onSelect = { [weak self] in
                self?.goToTagDetail(with: tag)
            }
            cells.append(conf)
        }
        return UITableView.Section(id: "Tags", cells: cells)
    }

    private func addTag() {
        goToTagDetail()
    }

    private func goToTagDetail(with tag: Tag? = nil) {
        let tagView = tagDetailBuilder.build(arg: tag)
        tagView.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(tagView, animated: true)
    }

    private func onDelete(tag deletedTag: Tag) {
        guard let index = self.tags.index(where: { $0.id == deletedTag.id }) else {
            loadTagList()
            return
        }
        tags.remove(at: index)
        show(tags: tags)
    }

    private func onEdit(tag editedTag: Tag) {
        guard let index = self.tags.index(where: { $0.id == editedTag.id }) else {
            loadTagList()
            return
        }
        let currentTag = tags[index]
        var editedTag = editedTag
        editedTag.count = currentTag.count
        tags[index] = editedTag
        show(tags: tags)
    }

    deinit {
        for observer in tagObservers {
            tagInternalNotificationCenter.remove(observer: observer)
        }
        tagObservers.removeAll()
    }
}
