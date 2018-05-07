//
//  TagDetailPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagDetailPresenter: Presenter<TagDetailView> {

    private var tag: Tag

    private let createInteractor: Interactor<Tag, Tag>
    private let editInteractor: Interactor<Tag, Tag>
    private let deleteInteractor: Interactor<Tag, Tag>
    private let metaDataBuilder: Builder<MetaDataArg, UIViewController>
    private let postListBuilder: Builder<StoryFilters?, UIViewController>

    private var shouldEnableSave: Bool {
        return !tag.name.isEmpty
    }

    init(
        tag: Tag?,
        createInteractor: Interactor<Tag, Tag>,
        editInteractor: Interactor<Tag, Tag>,
        deleteInteractor: Interactor<Tag, Tag>,
        metaDataBuilder: Builder<MetaDataArg, UIViewController>,
        postListBuilder: Builder<StoryFilters?, UIViewController>
    ) {
        self.tag = tag.mutated
        self.createInteractor = createInteractor
        self.editInteractor = editInteractor
        self.deleteInteractor = deleteInteractor
        self.metaDataBuilder = metaDataBuilder
        self.postListBuilder = postListBuilder
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.title = tag.name
        view.onTapSave = save
        view.enableSaveButton = shouldEnableSave
        loadSections()
    }

    private func loadSections() {
        view.sections = getSections()
    }

    private func save() {
        if tag.isNew {
            async(loaders: [view], background: { [unowned self] in
                return self.createInteractor.execute(args: self.tag)
            }, main: { [weak self] result in
                switch result {
                case .success(let tag):
                    // Send notification
                    self?.tag = tag
                    self?.loadSections()
                case .failure(let error): self?.handle(error: error)
                }
            })
        } else {
            async(loaders: [view], background: { [unowned self] in
                return self.editInteractor.execute(args: self.tag)
            }, main: { [weak self] result in
                switch result {
                case .success(let tag):
                    // Send notification
                    self?.tag = tag
                    self?.loadSections()
                case .failure(let error): self?.handle(error: error)
                }
            })
        }
    }

    private func askToDelete() {
        let tagName = tag.name
        let alert = UIAlertController(
            title: "Are you sure you want to delete this tag?",
            message: "You're about to delete \"\(tagName)\". This is permanent! We warned you, ok?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.delete()
        }))
        view.present(alert, animated: true, completion: nil)
    }

    private func delete() {
        async(loaders: [view], background: { [unowned self] in
            return self.deleteInteractor.execute(args: self.tag)
        }, main: { [weak self] result in
            switch result {
            case .success:
                self?.view.navigationController?.popViewController(animated: true)
            case .failure(let error): self?.handle(error: error)
            }
        })
    }

    private func handle(error: Error) {
        show(error: error)
    }

    private func getSections() -> [UITableView.Section] {
        let spaceCellConf = SpaceTableViewCell.Conf(height: 20)

        var cells: [TableCellConf] = [
            getUploadImageCellConf(),
            getNameFieldCellConf(),
            getUrlFieldCellConf(),
            getDescriptionTextViewCellConf(),
            spaceCellConf
        ]
        cells.append(contentsOf: getMetaSection())
        cells.append(spaceCellConf)

        if !tag.isNew {
            cells.append(contentsOf: [
                    getPostListCellConf(),
                    spaceCellConf,
                    getDeleteCellConf(),
                    spaceCellConf
                ]
            )
        }

        let section = UITableView.Section(id: "Tag", cells: cells)
        return [section]
    }

    private func getUploadImageCellConf() -> TableCellConf {
        var featuredImageUrl = tag.featureImage
        if let blogurl = Account.current?.blogUrl,
            let featureImage = tag.featureImage, featureImage.starts(with: "/") {
            featuredImageUrl = "\(blogurl)\(featureImage)".replacing("//", "/")
        }
        let uploadImageCellConf = ImageUploaderTableViewCell.Conf(
            urlString: featuredImageUrl,
            onUploadImage: { [weak self] (url, _) in
                self?.tag.featureImage = url
                self?.save()
            },
            onRemoveImage: { [unowned self] in
                self.tag.featureImage = ""
                self.save()
            },
            viewToPresent: view
        )
        return uploadImageCellConf
    }

    private func getNameFieldCellConf() -> TableCellConf {
        return TextFieldTableViewCell.Conf(
            title: "Name",
            textFieldText: tag.name,
            onWrite: { [unowned self] _, text in
                self.view.title = text
                self.tag.name = text ?? ""
                self.view.enableSaveButton = self.shouldEnableSave
            }
        )
    }

    private func getUrlFieldCellConf() -> TableCellConf {
        func tagURI(text: String?) -> String {
            let slug: String = text ?? ""
            var uri = "/tag/"
            if !slug.isEmpty {
                uri.append(slug)
                uri.append("/")
            }
            return uri
        }
        let urlFieldCellConf = TextFieldTableViewCell.Conf(
            title: "URL",
            textFieldText: tag.slug,
            explain: tagURI(text: tag.slug),
            onWrite: { [unowned self] conf, text in
                conf.explain = tagURI(text: text)
                self.tag.slug = text ?? ""
            }
        )
        return urlFieldCellConf
    }

    private func getDescriptionTextViewCellConf() -> TableCellConf {
        let descriptionTextViewCellConf = TextViewTableViewCell.Conf(
            title: "Description",
            textViewText: tag.description,
            explain: "Maximum: 200 characters",
            onWrite: { [unowned self] _, text in
                self.tag.description = text
            },
            countMode: .max(200)
        )
        return descriptionTextViewCellConf
    }

    private func getMetaSection() -> [TableCellConf] {
        let metaDataInfoCellConf = SubtitleTableViewCell.Conf(
            text: "Meta Data",
            subtitle: "Extra content for SEO and social media"
        )
        metaDataInfoCellConf.onSelect = { [unowned self] in
            self.openMetaDataEditor()
        }
        metaDataInfoCellConf.deselect = true
        metaDataInfoCellConf.accessoryType = .disclosureIndicator
        return [metaDataInfoCellConf]
    }

    private func getPostListCellConf() -> TableCellConf {
        let postsCellConf = SubtitleTableViewCell.Conf(
            text: "Posts",
            subtitle: "All posts with \(tag.name) tag"
        )
        postsCellConf.accessoryType = .disclosureIndicator
        postsCellConf.onSelect = { [unowned self] in
            self.openPostList()
        }
        postsCellConf.deselect = true
        postsCellConf.accessoryType = .disclosureIndicator
        return postsCellConf
    }

    private func getDeleteCellConf() -> TableCellConf {
        let deleteCellConf = BasicTableViewCell.Conf(
            text: "Delete tag",
            textColor: Color.red,
            textFont: UIFont.preferredFont(forTextStyle: .footnote)
        )
        deleteCellConf.deselect = true
        deleteCellConf.onSelect = { [unowned self] in
            self.askToDelete()
        }
        return deleteCellConf
    }

    private func openMetaDataEditor() {
        let onEdit: OnEditMetaDataAction = { [unowned self] metaData in
            self.tag.metaData = metaData
        }
        let args: MetaDataArg = (tag.metaData, onEdit)
        let metaDataView = metaDataBuilder.build(arg: args)
        view.navigationController?.pushViewController(metaDataView, animated: true)
    }

    private func openPostList() {
        let filters = StoryFilters(tagID: tag.id, text: "")
        let postsView = postListBuilder.build(arg: filters)
        view.navigationController?.pushViewController(postsView, animated: true)
        if tag.name.hasSuffix("s") {
            postsView.navigationItem.title = "\(tag.name)' posts"
        } else {
            postsView.navigationItem.title = "\(tag.name)'s posts"
        }
    }
}

extension Optional where Wrapped==Tag {
    var mutated: Tag {
        return Tag(
            id: self?.id ?? "",
            name: self?.name ?? "",
            slug: self?.slug ?? "",
            description: self?.description,
            featureImage: self?.featureImage,
            metaTitle: self?.metaTitle,
            metaDescription: self?.metaDescription,
            count: nil
        )
    }
}
