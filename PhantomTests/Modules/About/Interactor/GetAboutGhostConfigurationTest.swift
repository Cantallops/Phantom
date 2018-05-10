//
//  GetAboutGhostConfigurationTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetAboutGhostConfigurationTest: XCTestCase {

    fileprivate var interactor: GetAboutGhostConfigurationInteractor!
    fileprivate var aboutDataSource: MockDataSource<Any?, AboutGhost>!
    fileprivate let about = AboutGhost(
        version: "About-Version",
        environment: "About-Environment",
        database: "About-Database",
        mail: "About-Mail"
    )

    override func setUp() {
        super.setUp()
        aboutDataSource = MockDataSource<Any?, AboutGhost>(
            result: Result.success(about)
        )
        interactor = GetAboutGhostConfigurationInteractor(getAboutConfiguration: aboutDataSource)
    }

    func testShouldReturnAboutIfDataSourceReturnAbout() {
        aboutDataSource.result = Result.success(about)
        let result = interactor.execute(args: nil)
        XCTAssertEqual(result.value?.version, about.version)
        XCTAssertEqual(result.value?.environment, about.environment)
        XCTAssertEqual(result.value?.database, about.database)
        XCTAssertEqual(result.value?.mail, about.mail)
    }

}
