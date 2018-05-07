//
//  StoryDetailPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import ToastSwiftFramework

class StoryDetailPresenter: Presenter<StoryDetailView> {

    private var autoSaveDebounce: Debounce!

    let createInteractor: Interactor<Story, Story>
    let editInteractor: Interactor<Story, Story>
    let deleteInteractor: Interactor<Story, Story>
    let publisherBuilder: Builder<PublisherArg, UIViewController>
    let settingsBuilder: Builder<StorySettingsArg, UIViewController>

    private var imageUploader: ImageUploader!

    var loadById: Bool = false
    var id: String?

    var story: Story
    var initialStory: Story

    init(
        story: Story?,
        createInteractor: Interactor<Story, Story>,
        editInteractor: Interactor<Story, Story>,
        deleteInteractor: Interactor<Story, Story>,
        publisherBuilder: Builder<PublisherArg, UIViewController>,
        settingsBuilder: Builder<StorySettingsArg, UIViewController>
    ) {
        self.initialStory = story.mutated
        self.story = story.mutated
        self.createInteractor = createInteractor
        self.editInteractor = editInteractor
        self.deleteInteractor = deleteInteractor
        self.publisherBuilder = publisherBuilder
        self.settingsBuilder = settingsBuilder
        super.init()
    }

    init(
        id: String,
        createInteractor: Interactor<Story, Story>,
        editInteractor: Interactor<Story, Story>,
        deleteInteractor: Interactor<Story, Story>,
        publisherBuilder: Builder<PublisherArg, UIViewController>,
        settingsBuilder: Builder<StorySettingsArg, UIViewController>
    ) {
        self.loadById = true
        self.id = id
        let story: Story? = nil
        self.initialStory = story.mutated
        self.story = story.mutated
        self.createInteractor = createInteractor
        self.editInteractor = editInteractor
        self.deleteInteractor = deleteInteractor
        self.publisherBuilder = publisherBuilder
        self.settingsBuilder = settingsBuilder
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        setUpView()
        view.onWriteTitle = changeTitle
        view.onWriteContent = changeContent
        view.onStoryAction = publishAction
        view.onStorySettings = settingsAction
        view.onBack = askToSaveIfNecessaryBeforeDismiss
        view.onInsertImage = uploadImage
        view.onTitleResignFirstResponder = saveIfIsNewStory
        view.onPreview = preview
        imageUploader = ImageUploader(
            onResult: { [weak self] result, _ in
                switch result {
                case .success(let uri): self?.onImageUploaded(uri: uri)
                case .failure(let error): self?.handle(error: error)
                }
            }
        )
        autoSaveDebounce = Debounce(delay: 5) { [weak self] in
            self?.save(auto: true)
        }
    }

    override func willAppear() {
        super.willAppear()
        if let id = self.id, loadById {
            loadById = false
            load(byID: id)
        }
    }

    override func didDisappear() {
        super.didDisappear()
        autoSaveDebounce.invalidate()
    }

    private func setUpView(firstSave: Bool = false) {
        view?.title = story.title
        // Avoid to change the text when user is typing
        if !firstSave {
            view?.markdown = story.markdown
        }
        view?.status = story.status.rawValue.capitalized
        var actionText: String? = nil
        switch story.status {
        case .published:
            actionText = "Update"
        case .draft:
            actionText = "Publish"
        case .scheduled:
            actionText = "Scheduled"
        }
        if story.isNew {
            actionText = nil
        }
        view?.storyAction = actionText
    }

    private func autoSave() {
        autoSaveDebounce.call()
    }

    private func saveIfIsNewStory() {
        if story.isNew {
            autoSaveDebounce.invalidate()
            save()
        }
    }

    private func save(auto: Bool = false, onSave: (() -> Void)? = nil) {
        if story == initialStory || story.status == .published || story.status == .scheduled {
            autoSave()
            return
        }
        if story.isNew {
            async(loaders: [view], background: { [unowned self] in
                return self.createInteractor.execute(args: self.story)
            }, main: { [weak self] result in
                switch result {
                case .success(let story):
                    self?.saveSucceed(story: story)
                    onSave?()
                case .failure(let error):
                    if !auto {
                        self?.handle(error: error)
                    }
                    self?.autoSave()
                }
            })
        } else {
            update(story: story, loaders: [view]) { [weak self] result in
                switch result {
                case .success(let story):
                    self?.saveSucceed(story: story)
                    onSave?()
                case .failure(let error):
                    if !auto {
                        self?.handle(error: error)
                    }
                    self?.autoSave()
                }
            }
        }
    }

    private func delete() {
        autoSaveDebounce.invalidate()
        async(loaders: [view], background: { [unowned self] in
            return self.deleteInteractor.execute(args: self.story)
        }, main: { [weak self] result in
            switch result {
            case .success: self?.deleteSucceed()
            case .failure(let error):
                self?.handle(error: error)
                self?.autoSave()
            }
        })
    }

    private func saveSucceed(story: Story) {
        let firstSave = self.story.isNew
        self.story = story
        self.initialStory = story
        setUpView(firstSave: firstSave)
        autoSave()
    }

    private func deleteSucceed() {
        view.dismiss(animated: true)
    }

    private func settingsAction() {
        let onEdit: OnEditStoryAction = { [unowned self] story in
            self.story = story
            self.autoSave()
        }
        let onDelete: OnDeleteStoryAction = { [unowned self] _ in
            self.delete()
        }
        let storySettingsArg: StorySettingsArg = (story, onEdit, onDelete)
        let settingView = settingsBuilder.build(arg: storySettingsArg)
        view.navigationController?.pushViewController(settingView, animated: true)
    }

    private func publishAction() {
        let publisherAction: OnPublishAction = publish
        let publisherArg: PublisherArg = (story, publisherAction)
        let publisher = publisherBuilder.build(arg: publisherArg)
        view.present(publisher, animated: true)
    }

    private func handle(error: Error) {
        self.show(error: error)
    }

    private func changeContent(_ text: String?) {
        let text: String = text ?? ""
        story.markdown = text
        autoSave()
        if !text.isEmpty && !view.isLoading {
            saveIfIsNewStory()
        }
    }

    private func changeTitle(_ text: String?) {
        story.title = text ?? ""
        autoSave()
    }

    private func update(story: Story, loaders: [Loader]?, onResult: @escaping (Result<Story>) -> Void ) {
        async(loaders: loaders,
              background: { [unowned self] in
                return self.editInteractor.execute(args: story)
              }, main: { result in
                  onResult(result)
              })
    }

    private func publish(
        publishAction: PublishAction,
        loaders: [Loader]?,
        resultAction: @escaping (Result<Story>) -> Void
    ) {
        var story = self.story
        switch publishAction {
        case .none: break
        case .publish, .update: story.publish()
        case .unschedule, .unpublish: story.setDraft()
        case .schedule(let date): story.schedule(forDate: date)
        }
        update(story: story, loaders: loaders, onResult: { [weak self] result in
            switch result {
            case .success(let story): self?.saveSucceed(story: story)
            case .failure: break
            }
            resultAction(result)
        })
    }

    private func preview() {
        if needToBeSaved(story: story) {
            var text = "You should save the post before preview it correctly"
            if story.status == .draft {
                text = "Saving, when it finishes you will see the preview"
                save(auto: true) { [weak self] in
                    self?.goToPreview()
                    self?.view.view.hideToast()
                    self?.view.view.hideToastActivity()
                }
                view.view.makeToastActivity(.center)
            }
            view.view.makeToast(text, duration: 3.0, position: .top)
            return
        }
        goToPreview()
    }

    private func goToPreview() {
        let webView = StoryPreview()
        webView.load(story: story)
        view.navigationController?.pushViewController(webView, animated: true)
    }

    private func askToSaveIfNecessaryBeforeDismiss() {
        guard let nav = view.navigationController else { return }
        if !needToBeSaved(story: story) {
            nav.dismiss(animated: true)
            return
        }
        autoSaveDebounce.invalidate()
        let alert = UIAlertController(
            title: "Are you sure you want to leave?",
            // swiftlint:disable:next line_length
            message: "Hey there! It looks like you're in the middle of writing something and you haven't saved all of your content.",
            preferredStyle: .alert
        )
        if story.status == .draft {
            alert.addAction(UIAlertAction(title: "Save and leave", style: .default, handler: { _ in
                self.save {
                    nav.dismiss(animated: true)
                }
            }))
        }
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { _ in
            nav.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Stay", style: .cancel, handler: { [weak self] _ in
            self?.autoSaveDebounce.reset()
        }))
        nav.present(alert, animated: true, completion: nil)
    }

    private func needToBeSaved(story: Story) -> Bool {
        return story.isNew || story != initialStory
    }

    private func uploadImage() {
        imageUploader.show(in: view)
    }

    private func onImageUploaded(uri: String) {
        view.insert(imageWithUri: uri)
    }
}

extension StoryDetailPresenter {
    func load(byID id: String) {
        async(loaders: [self], background: {
            return GetStoriesList().execute(args: nil)
        }, main: { result in
            switch result {
            case .success(let stories):
                let story = stories.object.filter({ $0.id == self.id }).first!
                self.story = story
                self.initialStory = story
                self.setUpView(firstSave: false)
            case .failure(let error): self.show(error: error)
            }
        })
    }
}

extension Optional where Wrapped==Story {
    var mutated: Story {
        return Story(
            id: self?.id ?? "",
            uuid: self?.uuid ?? "",
            title: self?.title ?? "",
            slug: self?.slug,
            featureImage: self?.featureImage,
            featured: self?.featured ?? false,
            page: self?.page ?? false,
            author: self?.author,
            mobiledoc: self?.mobiledoc ?? "",
            html: self?.html,
            plaintext: self?.plaintext,
            status: self?.status ?? .draft,
            excerpt: self?.excerpt,
            tags: self?.tags ?? [],
            updatedAt: self?.updatedAt ?? Date(),
            publishedAt: self?.publishedAt,
            metaTitle: self?.metaTitle,
            metaDescription: self?.metaDescription
        )
    }
}
