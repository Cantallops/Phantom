//
//  AsyncHelper.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

func async<R>(
    loaders: [Loader]? = nil,
    background: @escaping () -> R,
    main: ((_ result: R) -> Void)? = nil
) {
    let queue = DispatchQueue(label: "background-worker", attributes: [])
    loaders?.start()
    queue.async {
        let result = background()
        DispatchQueue.main.async(execute: {
            main?(result)
            loaders?.stop()
        })

    }
}
