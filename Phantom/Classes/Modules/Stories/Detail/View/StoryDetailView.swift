//
//  StoryDetailView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import WebKit

class StoryDetailView: ViewController {

    @IBOutlet private weak var titleTextView: TextView!
    @IBOutlet private weak var contentTextView: TextView!
    @IBOutlet private weak var previewView: WKWebView!
    @IBOutlet weak var topTitleTextViewConstraint: NSLayoutConstraint!

    var onWriteContent: TextView.OnWriteClosure = { _ in } {
        didSet {
            contentTextView?.onWrite = onWriteContent
        }
    }
    var onWriteTitle: TextView.OnWriteClosure = { _ in } {
        didSet {
            titleTextView?.onWrite = onWriteTitle
        }
    }
    var onStoryAction: (() -> Void)?
    var onStorySettings: (() -> Void)?
    var onBack: (() -> Void)?
    var onInsertImage: (() -> Void)?

    override var title: String? {
        didSet {
            titleTextView.text = title
        }
    }
    var markdown: String = "" {
        didSet {
            contentTextView?.text = markdown
        }
    }
    var html: Story.HTML? {
        didSet {
            previewView?.loadHTMLString(html?.getFull() ?? "", baseURL: nil)
        }
    }
    var status: String? {
        didSet {
            setUpTootlbar()
        }
    }
    var storyAction: String? {
        didSet {
            setUpStoryAction()
        }
    }

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        tabBarItem.image = #imageLiteral(resourceName: "ic_tab_stories")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollToViewWhenKeyboardShows = false
        setUpContentToolbar()
        setUpTextViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentTextView.textContainerInset = UIEdgeInsets(
            top: titleTextView.frame.height + 10,
            left: 10,
            bottom: 10,
            right: 10
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setUpTextViews() {
        titleTextView.text = title
        titleTextView.placeholder = "Post title"
        titleTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        titleTextView.layer.borderWidth = 0
        titleTextView.layer.cornerRadius = 0
        titleTextView.onWrite = onWriteTitle
        titleTextView.backgroundColor = .clear
        titleTextView.onEnter = { [unowned self] in
            self.contentTextView.selectedRange = NSRange(location: 0, length: 0)
            self.contentTextView.contentOffset = .zero
            _ = self.titleTextView.resignFirstResponder()
            self.contentTextView.becomeFirstResponder()
            return false
        }
        contentTextView.text = markdown
        contentTextView.placeholder = "Begin writing your story..."
        contentTextView.layer.borderWidth = 0
        contentTextView.layer.cornerRadius = 0
        contentTextView.onWrite = onWriteContent
        contentTextView.onScroll = { [unowned self] scroll in
            self.topTitleTextViewConstraint.constant = -scroll.contentOffset.y
        }
    }

    override func setUpNavigation() {
        navigationItem.titleView = UIView()
        navigationItem.largeTitleDisplayMode = .never
        setUpTootlbar()
        setUpStoryAction()
    }

    private func setUpStoryAction() {
        navigationItem.hidesBackButton = true
        if let storyAction = storyAction {
            let action = UIBarButtonItem(
                title: storyAction,
                style: .plain,
                target: self,
                action: #selector(tapStoryAction)
            )
            let conf = UIBarButtonItem(
                image: #imageLiteral(resourceName: "ic_nav_cog").withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(tapSettings)
            )
            conf.accessibilityIdentifier = "storySettings"

            navigationItem.rightBarButtonItems = [conf, action]
        } else {
            navigationItem.rightBarButtonItems = []
        }

        let status = UIBarButtonItem(title: self.status, style: .plain, target: nil, action: nil)
        status.isEnabled = false
        status.tintColor = Color.darkGrey
        navigationItem.leftBarButtonItem = status
    }

    // FIXME: Reenable preview
    private func setUpTootlbar() {
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        /*let preview = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_post_preview").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(tapPreview)
        )*/
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapBack))

        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        navigationController?.toolbar.isTranslucent = false
        toolbarItems = [done, flex/*, preview*/]
    }

    private func setUpContentToolbar() {
        let contentToolbar = UIToolbar()
        contentToolbar.isTranslucent = false
        contentToolbar.tintColor = UIColor.darkText
        contentToolbar.barStyle = .default

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let bold = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_bold"), style: .plain, target: self, action: #selector(tapBold))
        let italics = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_italic"), style: .plain, target: self, action: #selector(tapItalic))
        let header = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_header"), style: .plain, target: self, action: #selector(tapHeader))
        let quote = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_quote"), style: .plain, target: self, action: #selector(tapQuote))
        let list = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_bullet_list"), style: .plain, target: self, action: #selector(tapList))
        let numeredList = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_numered_list"), style: .plain, target: self, action: #selector(tapNumeredList))
        let link = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_link"), style: .plain, target: self, action: #selector(tapLink))
        let image = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_post_image"), style: .plain, target: self, action: #selector(tapImage))

        let items = [bold, italics, header, flex, quote, list, numeredList, flex, link, image]
        for item in items {
            item.image = item.image?.withRenderingMode(.alwaysOriginal)
        }
        contentToolbar.items = items
        contentToolbar.sizeToFit()
        contentTextView.inputAccessoryView = contentToolbar
    }

    @objc func tapBack() {
        onBack?()
    }

    @objc func tapStoryAction() {
        onStoryAction?()
    }

    @objc func tapPreview() {
        previewView.scrollView.setContentOffset(.zero, animated: true)
        contentTextView.setContentOffset(.zero, animated: true)
        previewView.isHidden = !previewView.isHidden
    }
    @objc func tapSettings() {
        onStorySettings?()
    }

    @objc func tapBold() {
        contentTextView.wrap(selectedTextWith: "**")
    }

    @objc func tapItalic() {
        contentTextView.wrap(selectedTextWith: "*")
    }

    @objc func tapHeader() {
        contentTextView.wrap(selectedLineWith: "# ", wrapperRight: "", max: 6)
    }

    @objc func tapQuote() {
        contentTextView.wrap(selectedLineWith: "> ", wrapperRight: "", max: 1)
    }

    @objc func tapList() {
        contentTextView.wrap(selectedLineWith: "* ", wrapperRight: "", max: 1)
    }

    @objc func tapNumeredList() {
        contentTextView.wrap(selectedLineWith: "1. ", wrapperRight: "", max: 1)
    }

    @objc func tapLink() {
        contentTextView.wrap(selectedTextWith: "[", wrapperRight: "](https://)")
    }

    @objc func tapImage() {
        onInsertImage?()
    }

    func insert(imageWithUri uri: String) {
        guard let selectedTextRange = contentTextView.selectedTextRange else {
            return
        }
        contentTextView.replace(selectedTextRange, withText: "![image](\(uri))")
        contentTextView.becomeFirstResponder() // Return the focus
    }
}

extension StoryDetailView: Loader {
    var isLoading: Bool {
        return toolbarItems?.first?.customView is UIActivityIndicatorView
    }

    func start() {
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        toolbarItems?.removeFirst()
        var newToolbarItems = [UIBarButtonItem(customView: uiBusy)]
        newToolbarItems.append(contentsOf: toolbarItems ?? [])
        toolbarItems = newToolbarItems
    }

    func stop() {
        setUpTootlbar()
    }
}
