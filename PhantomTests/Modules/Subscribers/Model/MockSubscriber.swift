//
//  MockSubscriber.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

extension Subscriber {
    static let any = Subscriber(id: "id", email: "email")
}
