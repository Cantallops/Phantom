//
//  CodeInjectionFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class CodeInjectionFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = CodeInjectionPresenter()
        let view = CodeInjectionView(presenter: presenter)
        presenter.view = view
        return view
    }
}
