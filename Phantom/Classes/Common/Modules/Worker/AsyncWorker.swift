//
//  AsyncWorker.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class AsyncWorker: Worker {
    override func execute<R>(task: Task<R>) {
        let queue = DispatchQueue(label: "background-worker", attributes: [])
        task.loaders?.start()
        queue.async {
            let result = task.task()
            DispatchQueue.main.async(execute: {
                task.completion?(result)
                task.loaders?.stop()
            })

        }
    }
}
