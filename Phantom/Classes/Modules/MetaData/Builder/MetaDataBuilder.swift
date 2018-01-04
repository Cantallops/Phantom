//
//  MetaDataBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 22/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

typealias MetaDataArg = (metaData: MetaData, onEdit: OnEditMetaDataAction)
class MetaDataBuilder: Builder<MetaDataArg, UIViewController> {
    override func build(arg: MetaDataArg) -> UIViewController {
        let presenter = MetaDataPresenter(metaData: arg.metaData, onEdit: arg.onEdit)
        let view = MetaDataView(presenter: presenter)
        presenter.view = view

        return view
    }
}
