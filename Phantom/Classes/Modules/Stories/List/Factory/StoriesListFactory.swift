//
//  StoriesListFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoriesListFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let view = StoriesListBuilder().build(arg: nil)
        view.navigationItem.title = "Your stories"
        return view
    }
}
