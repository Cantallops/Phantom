//
//  StoriesListPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoriesListPresenter: Presenter<StoriesListView> {

    private let storyInternalNotificationCenter: InternalNotificationCenter<Story>
    private var storyObservers: [NSObjectProtocol] = []
    private let tagInternalNotificationCenter: InternalNotificationCenter<Tag>
    private var tagObservers: [NSObjectProtocol] = []
    private var filters = StoryFilters() {
        didSet {
            loadList()
        }
    }
    private let getStoriesListInteractor: Interactor<Meta?, Paginated<[Story]>>
    private let filterStories: Interactor<([Story], StoryFilters), [Story]>
    private let storyDetailBuilder: Builder<Story?, ViewController>
    private var meta: Meta?
    private var stories: [Story] = []

    init(
        storyInternalNotificationCenter: InternalNotificationCenter<Story>,
        tagInternalNotificationCenter: InternalNotificationCenter<Tag>,
        getStoriesListInteractor: Interactor<Meta?, Paginated<[Story]>> = GetStoriesList(),
        storyDetailBuilder: Builder<Story?, ViewController> = StoryDetailBuilder(),
        filterStories: Interactor<([Story], StoryFilters), [Story]> = FilterStories()
    ) {
        self.storyInternalNotificationCenter = storyInternalNotificationCenter
        self.tagInternalNotificationCenter = tagInternalNotificationCenter
        self.getStoriesListInteractor = getStoriesListInteractor
        self.storyDetailBuilder = storyDetailBuilder
        self.filterStories = filterStories
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadStoryObservers()
        loadTagObservers()
        view.newStoryAction = newStory
        view.refreshAction = loadList
        view.searchAction = filter
        loadList()
    }

    private func loadList() {
        var loaders: [Loader] = [self]
        if let meta = meta, !meta.pagination.isFirst {
            loaders = []
        }
        async(loaders: loaders, background: { [unowned self] in
                return self.getStoriesListInteractor.execute(args: self.meta)
        }, main: { [weak self] result in
            switch result {
            case .success(let paginated): self?.process(paginated: paginated)
            case .failure(let error):
                self?.view.sections = []
                self?.process(error: error)
            }
        })
    }

    private func process(paginated: Paginated<[Story]>) {
        meta = paginated.meta
        stories = paginated.object
        let result = filterStories.execute(args: (stories, filters))
        show(stories: result.value ?? [])
    }

    private func show(stories: [Story]) {
        if stories.isEmpty {
            view.sections = []
        } else {
            view.sections = [parse(stories: stories)]
        }
    }

    private func process(error: Error) {
        show(error: error)
    }

    private func parse(stories: [Story]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for story in stories {
            let conf = StoryTableViewCell.Conf(
                story: story
            )
            conf.deselect = true
            conf.onSelect = { [weak self] in
                self?.goToStoryDetail(with: story)
            }
            cells.append(conf)
        }
        return UITableView.Section(id: "Stories", cells: cells)
    }

    private func newStory() {
        goToStoryDetail()
    }

    private func goToStoryDetail(with story: Story? = nil) {
        let storyView = storyDetailBuilder.build(arg: story)
        let nav = NavigationController(rootViewController: storyView)
        view.present(nav, animated: true)
    }

    deinit {
        removeStoryObservers()
        removeTagObservers()
    }
}

extension StoriesListPresenter {
    private func loadStoryObservers() {
        let nc = storyInternalNotificationCenter
        let newStoryObserver = nc.addObserver(forType: .StoryNew) { [unowned self] _ in
            self.loadList()
        }
        let deleteStoryObserver = nc.addObserver(forType: .StoryDelete) { [unowned self] story in
            self.onDelete(story: story)
        }
        let editStoryObserver = nc.addObserver(forType: .StoryEdit) { [unowned self] story in
            self.onEdit(story: story)
        }
        storyObservers = [newStoryObserver, editStoryObserver, deleteStoryObserver]
    }

    private func removeStoryObservers() {
        for observer in storyObservers {
            storyInternalNotificationCenter.remove(observer: observer)
        }
        storyObservers.removeAll()
    }

    private func onDelete(story: Story) {
        guard let index = stories.index(where: { $0.uuid == story.uuid}) else {
            loadList()
            return
        }
        stories.remove(at: index)
        show(stories: stories)
    }

    private func onEdit(story: Story) {
        guard let index = stories.index(where: { $0.uuid == story.uuid}) else {
            loadList()
            return
        }
        stories[index] = story
        show(stories: stories)
    }

    func filter(by filters: StoryFilters) {
        self.filters = filters
    }
}

extension StoriesListPresenter {
    private func loadTagObservers() {
        let deleteTagObserver = tagInternalNotificationCenter.addObserver(forType: .TagDelete) { [unowned self] tag in
            self.onDelete(tag: tag)
        }
        let editTagObserver = tagInternalNotificationCenter.addObserver(forType: .TagEdit) { [unowned self] tag in
            self.onEdit(tag: tag)
        }

        tagObservers = [editTagObserver, deleteTagObserver]
    }

    private func onDelete(tag: Tag) {
        onChange(tag: tag) { (story, tagIdx) -> Story in
            var editedStory = story
            editedStory.tags.remove(at: tagIdx)
            return editedStory
        }
    }

    private func onEdit(tag: Tag) {
        onChange(tag: tag) { (story, tagIdx) -> Story in
            var editedStory = story
            editedStory.tags[tagIdx] = tag
            return editedStory
        }
    }

    private func onChange(tag: Tag, _ tagClosure: (Story, Int) -> Story) {
        var editedStories = stories
        var edited = false
        for (idx, story) in stories.enumerated() {
            guard let index = story.tags.index(where: { $0.id == tag.id }) else {
                continue
            }
            editedStories[idx] = tagClosure(story, index)
            edited = true
        }
        if !edited {
            return
        }
        stories = editedStories
        show(stories: stories)
    }

    private func removeTagObservers() {
        for observer in tagObservers {
            tagInternalNotificationCenter.remove(observer: observer)
        }
        tagObservers.removeAll()
    }
}

extension StoriesListPresenter {
    func filter(text: String) {
        filters.text = text
    }
}
