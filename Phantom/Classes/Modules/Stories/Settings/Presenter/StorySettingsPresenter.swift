//
//  StorySettingsPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

typealias OnEditStoryAction = (Story) -> Void
typealias OnDeleteStoryAction = (Story) -> Void

class StorySettingsPresenter: Presenter<StorySettingsView> {

    private let worker: Worker
    private var story: Story
    private let onEdit: OnEditStoryAction
    private let onDelete: OnDeleteStoryAction
    private let getTags: Interactor<Meta?, Paginated<[Tag]>>
    private let getMembers: Interactor<Meta?, Paginated<[TeamMember]>>
    private let getMe: Interactor<Any?, TeamMember>
    private let metaDataBuilder: Builder<MetaDataArg, UIViewController>
    private let getTemplates: Interactor<Any?, [Theme.Template]>

    private var me: TeamMember?
    private var showAuthors: Bool {
        if let me = me {
            return me.role != .author
        }
        return false
    }
    private var authors: [Story.Author] = []
    private var tags: [Tag] = []
    private var templates: [Theme.Template] = []

    init(
        worker: Worker = AsyncWorker(),
        story: Story,
        onEdit: @escaping OnEditStoryAction,
        onDelete: @escaping OnDeleteStoryAction,
        getTags: Interactor<Meta?, Paginated<[Tag]>>,
        getMembers: Interactor<Meta?, Paginated<[TeamMember]>>,
        getMe: Interactor<Any?, TeamMember>,
        metaDataBuilder: Builder<MetaDataArg, UIViewController>,
        getTemplates: Interactor<Any?, [Theme.Template]>
    ) {
        self.worker = worker
        self.story = story
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.getTags = getTags
        self.getMembers = getMembers
        self.getMe = getMe
        self.metaDataBuilder = metaDataBuilder
        self.getTemplates = getTemplates
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.title = "Post settings"
        loadTags()
        loadAuthors()
        loadTemplates()
    }

    private func loadTags() {
        let task = Task(task: { [unowned self]  () -> Result<Paginated<[Tag]>> in
            let meta = Meta(pagination: Meta.Pagination.all)
            return self.getTags.execute(args: meta)
        }, completion: {  [weak self] result in
            switch result {
            case .success(let paginatedTag): self?.tags = paginatedTag.object
            case .failure(let error): self?.show(error: error)
            }
            self?.showSections()
        })
        worker.execute(task: task)
    }

    private func loadAuthors() {
        let task = Task(task: { [unowned self] () -> Result<(Paginated<[TeamMember]>, TeamMember)> in
            let meta = Meta(pagination: Meta.Pagination.all)
            let result = self.getMembers.execute(args: meta).combined(result: self.getMe.execute(args: nil))
            return result
        }, completion: { [weak self] result in
            switch result {
            case .success(let paginatedMembers, let me):
                self?.authors = paginatedMembers.object.map({ $0.author })
                self?.me = me
            case .failure(let error): self?.show(error: error)
            }
            self?.showSections()
        })
        worker.execute(task: task)
    }

    private func loadTemplates() {
        let task = Task(task: { [unowned self] () -> Result<[Theme.Template]> in
            return self.getTemplates.execute(args: nil)
            }, completion: { [weak self] result in
                switch result {
                case .success(let templates): self?.templates = templates
                case .failure(let error): self?.show(error: error)
                }
                self?.showSections()
        })
        worker.execute(task: task)
    }

    private func showSections() {
        view.sections = getSections(
            withTags: tags,
            authors: authors,
            showAuthors: showAuthors,
            templates: templates
        )
    }

    private func askToDelete() {
        let storyTitle = story.title
        let alert = UIAlertController(
            title: "Are you sure you want to delete this post?",
            message: "You're about to delete \"\(storyTitle)\". This is permanent! We warned you, ok?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.delete()
        }))
        view.present(alert, animated: true, completion: nil)
    }

    private func delete() {
        onDelete(story)
    }

    private func handle(error: Error) {
        self.show(error: error)
    }

    private func getSections(
        withTags tags: [Tag],
        authors: [Story.Author],
        showAuthors: Bool,
        templates: [Theme.Template]
    ) -> [UITableView.Section] {
        let spaceCellConf = SpaceTableViewCell.Conf(height: 20)

        var cells: [TableCellConf] = [
            getUploadImageCellConf(),
            getUrlFieldCellConf(),
            getPreviewCellConf(),
            getTagsTextViewCellConf(withTags: tags),
            getExcerptTextViewCellConf()
        ]
        if showAuthors {
            cells.append(getAuthorPickerCellConf(withAuthors: authors))
        }
        cells.append(spaceCellConf)
        cells.append(contentsOf: getMetaDataSection())
        if !templates.isEmpty {
            cells.append(spaceCellConf)
            cells.append(getTemplateSection(with: templates))
        }
        cells.append(contentsOf: [
            spaceCellConf,
            getIsPageCellConf(),
            getIsFeaturedCellConf(),
            spaceCellConf,
            getDeleteCellConf(),
            spaceCellConf
        ])

        let section = UITableView.Section(id: "Settings", cells: cells)
        return [section]
    }

    private func edited(story: Story) {
        onEdit(story)
    }
}

private extension StorySettingsPresenter {
    func getUploadImageCellConf() -> TableCellConf {
        var featuredImageUrl = story.featureImage
        if let blogurl = Account.current?.blogUrl,
            let featureImage = story.featureImage, featureImage.starts(with: "/") {
            featuredImageUrl = "\(blogurl)\(featureImage)".replacing("//", "/")
        }
        let uploadImageCellConf = ImageUploaderTableViewCell.Conf(
            urlString: featuredImageUrl,
            onUploadImage: { [weak self]  (url, _) in
                self?.story.featureImage = url
                if let story = self?.story {
                    self?.edited(story: story)
                }
            },
            onRemoveImage: { [unowned self] in
                self.story.featureImage = ""
                self.edited(story: self.story)
            },
            viewToPresent: view
        )
        return uploadImageCellConf
    }

    func getUrlFieldCellConf() -> TableCellConf {
        func postURI(text: String?) -> String {
            let slug: String = text ?? ""
            var uri = "/"
            if !slug.isEmpty {
                uri.append(slug)
                uri.append("/")
            }
            return uri
        }
        let urlFieldCellConf = TextFieldTableViewCell.Conf(
            title: "URL",
            textFieldText: story.slug,
            explain: postURI(text: story.slug),
            onWrite: { [unowned self] conf, text in
                conf.explain = postURI(text: text)
                self.story.slug = text
                self.edited(story: self.story)
            }
        )
        return urlFieldCellConf
    }

    func getPreviewCellConf() -> TableCellConf {
        let previewCellConf = BasicTableViewCell.Conf(
            text: "Preview",
            textColor: UIColor.darkText,
            textFont: UIFont.preferredFont(forTextStyle: .footnote)
        )
        previewCellConf.deselect = true
        previewCellConf.onSelect = { [unowned self] in
            let webView = StoryPreview()
            webView.load(story: self.story)
            self.view.navigationController?.pushViewController(webView, animated: true)
        }
        return previewCellConf
    }

    func getTagsTextViewCellConf(withTags tags: [Tag]) -> TableCellConf {
        let tagsTextViewCellConf = TagsTableViewCell.Conf(
            title: "Tags",
            onTagsChange: { [unowned self] _, tags in
                self.story.tags = tags.getTags()
                self.edited(story: self.story)
            },
            currentTags: story.tags.getCellTags(),
            possibleTags: tags.getCellTags()
        )
        return tagsTextViewCellConf
    }

    func getExcerptTextViewCellConf() -> TableCellConf {
        let excerptTextViewCellConf = TextViewTableViewCell.Conf(
            title: "Excerpt",
            textViewText: story.excerpt,
            onWrite: { [unowned self] _, text in
                self.story.excerpt = text
                self.edited(story: self.story)
            }
        )
        return excerptTextViewCellConf
    }

    func getAuthorPickerCellConf(withAuthors authors: [Story.Author]) -> TableCellConf {
        let authorPickerConf = TagsTableViewCell.Conf(
            title: "Author",
            onTagsChange: { [unowned self] _, tags in
                self.story.authors = tags.map({ Story.Author(id: $0.id, name: $0.name) })
                self.edited(story: self.story)
            },
            currentTags: story.getAuthors().map({ TagsTableViewCell.Tag(id: $0.id, name: $0.name) }),
            possibleTags: authors.map({ TagsTableViewCell.Tag(id: $0.id, name: $0.name) }),
            canAddNewTags: false
        )
        return authorPickerConf
    }

    func getMetaDataSection() -> [TableCellConf] {
        let metaDataInfoCellConf = SubtitleTableViewCell.Conf(
            text: "Meta Data",
            subtitle: "Extra content for SEO and social media"
        )
        metaDataInfoCellConf.onSelect = openMetaDataEditor
        metaDataInfoCellConf.deselect = true
        metaDataInfoCellConf.accessoryType = .disclosureIndicator
        return [metaDataInfoCellConf]
    }

    func getIsPageCellConf() -> TableCellConf {
        let isPageCellConf = SwitchTableViewCell.Conf(
            text: "Turn this post into a page",
            onSwitch: { [unowned self] isPage in
                self.story.page = isPage
                self.edited(story: self.story)
            },
            isOn: story.page
        )
        return isPageCellConf
    }

    func getIsFeaturedCellConf() -> TableCellConf {
        let isFeaturedCellConf = SwitchTableViewCell.Conf(
            text: "Feature this post",
            onSwitch: { [unowned self] isFeatured in
                self.story.featured = isFeatured
                self.edited(story: self.story)
            }, isOn: story.featured
        )
        return isFeaturedCellConf
    }

    func getTemplateSection(with templates: [Theme.Template]) -> TableCellConf {
        let defaultTemplate = Theme.Template(name: "Default", filename: "default")
        var allTemplates = [defaultTemplate]
        allTemplates.append(contentsOf: templates)
        let templatesPickerConf = PickerTableViewCell.Conf(
            title: "Template",
            selected: allTemplates.first(where: { $0.filename == self.story.customTemplate }) ?? defaultTemplate,
            options: allTemplates,
            placeholder: "Choose a template",
            explain: nil) { _, pickerable in
                guard let template = pickerable as? Theme.Template else { return }
                self.story.customTemplate = (template == defaultTemplate) ? nil : template.filename
                self.edited(story: self.story)
        }
        return templatesPickerConf
    }

    func getDeleteCellConf() -> TableCellConf {
        let deleteCellConf = BasicTableViewCell.Conf(
            text: "Delete post",
            textColor: Color.red,
            textFont: UIFont.preferredFont(forTextStyle: .footnote)
        )
        deleteCellConf.deselect = true
        deleteCellConf.onSelect = { [unowned self] in
            self.askToDelete()
        }
        return deleteCellConf
    }

    func openMetaDataEditor() {
        let onEdit: OnEditMetaDataAction = { [unowned self] metaData in
            self.story.metaData = metaData
            self.edited(story: self.story)
        }
        let args: MetaDataArg = (story.metaData, onEdit)
        let metaDataView = metaDataBuilder.build(arg: args)
        view.navigationController?.pushViewController(metaDataView, animated: true)
    }
}

extension TagsTableViewCell.Tag {
    init(fromTag tag: Tag) {
        id = tag.id
        name = tag.name
    }
}

extension Array where Element==TagsTableViewCell.Tag {
    func getTags() -> [Tag] {
        return map({
            Tag(
                id: $0.id,
                name: $0.name,
                slug: "",
                description: nil,
                featureImage: nil,
                metaTitle: nil,
                metaDescription: nil,
                count: nil
            )
        })
    }
}

extension Array where Element==Tag {
    func getCellTags() -> [TagsTableViewCell.Tag] {
        return map({ TagsTableViewCell.Tag(fromTag: $0) })
    }
}

extension Theme.Template: Pickerable {
    var id: String {
        return name
    }
}

extension TeamMember: Pickerable {
}
