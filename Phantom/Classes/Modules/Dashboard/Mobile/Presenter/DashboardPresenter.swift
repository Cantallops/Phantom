//
//  DashboardPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class DashboardPresenter: Presenter<DashboardView> {

    private let worker: Worker
    private let getDashboardSections: Interactor<Any?, [Dashboard.Section]>
    private let sessionFactory: Factory<UIViewController>
    private let getFavIconImage: Interactor<Any?, UIImage>

    private var sections: [Dashboard.Section]?
    private var observers: [NSObjectProtocol] = []

    init(
        worker: Worker = AsyncWorker(),
        getDashboardSections: Interactor<Any?, [Dashboard.Section]> = GetDashboardSectionsInteractor(),
        sessionFactory: Factory<UIViewController> = SessionFactory(),
        getFavIconImage: Interactor<Any?, UIImage> = GetFavIconImageInteractor()
    ) {
        self.worker = worker
        self.getDashboardSections = getDashboardSections
        self.sessionFactory = sessionFactory
        self.getFavIconImage = getFavIconImage
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        let signOutObserver = sessionNotificationCenter.addObserver(forType: .signOut) { [weak self] _ in
            self?.signOut()
        }
        let signInObserver = sessionNotificationCenter.addObserver(forType: .signIn) { [weak self] _ in
            self?.signIn()
        }
        observers = [signOutObserver, signInObserver]
    }

    fileprivate func signIn() {
        loadSections()
    }

    fileprivate func signOut() {
        let sessionView = sessionFactory.build()
        view.present(sessionView, animated: true) {
            self.view.viewControllers?.removeAll()
        }
    }

    func go(to kind: Dashboard.Section.Kind) {
        guard let sections = sections,
            let idx = sections.index(where: { section -> Bool in
                return section.kind == kind
            }) else {
            return
        }
        view.selectedIndex = idx
    }

    private func loadSections() {
        let task = Task(qos: .userInitiated, task: { [unowned self] in
            return self.getDashboardSections.execute(args: nil)
        }, completion: { [unowned self] result in
            switch result {
            case .success(let sections):
                self.sections = sections
                self.process(sections: sections)
            case .failure(let error): self.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    private func process(sections: [Dashboard.Section]) {
        var viewControllers: [UIViewController] = []
        for section in sections {
            var view: UIViewController = section.factory.build()
            if section.nav {
                view = NavigationController(rootViewController: view)
            }
            view.tabBarItem.image = section.icon.withRenderingMode(.alwaysOriginal)
            view.tabBarItem.selectedImage = section.selectedIcon?.withRenderingMode(.alwaysOriginal)
            view.tabBarItem.title = section.name
            viewControllers.append(view)
        }
        view.viewControllers = viewControllers
        loadProfile()
    }

    private func loadProfile() {
        let task = Task(qos: .userInitiated, task: {
            return self.getFavIconImage.execute(args: nil)
        }, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.addProfile(withImage: image.resize(withSize: CGSize(width: 25, height: 25)))
            case .failure:
                self?.addProfile(withImage: nil)
            }
        })
        worker.execute(task: task)
    }

    private func addProfile(withImage image: UIImage?) {
        let imageNotTinted = (image ?? #imageLiteral(resourceName: "ic_tab_team")).rounded(withCornerRadius: 4).withRenderingMode(.alwaysOriginal)
        for viewController in view.viewControllers ?? [] {
            if let nav = viewController as? UINavigationController {
                let button = UIBarButtonItem(
                    image: imageNotTinted,
                    style: .plain,
                    target: self,
                    action: #selector(goMoreSection)
                )
                nav.viewControllers.first?.navigationItem.leftBarButtonItem = button
            }
        }
    }

    @objc private func goMoreSection() {
        go(to: .more)
    }

    deinit {
        for observer in observers {
            sessionNotificationCenter.remove(observer: observer)
        }
        observers.removeAll()
    }
}
