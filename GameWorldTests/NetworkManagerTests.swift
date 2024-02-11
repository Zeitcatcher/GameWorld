//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Arseniy Oksenoyt on 2/3/24.
//

import XCTest
@testable import GameWorld

final class NetworkManagerTests: XCTestCase {
    var sut: NetworkManagerImpl!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = NetworkManagerImpl()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testExample() throws {
    }
}
