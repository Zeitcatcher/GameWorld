//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Arseniy Oksenoyt on 2/3/24.
//

import XCTest
@testable import GameWorld

final class NetworkManagerTests: XCTestCase {
    var mockNetworking: MockNetworkManager!
    
    override func setUpWithError() throws {
        super.setUp()
        mockNetworking = MockNetworkManager()
    }
    
    override func tearDownWithError() throws {
        mockNetworking = nil
        super.tearDown()
    }
    
    func testFetchGamesSuccess() {
        let expectation = self.expectation(description: "FetchGames")
        let expectedData: GamesCollection? = loadGamesCollection(fromResource: "GamesCollectionResponse")
        mockNetworking.mockedGames = expectedData?.games
        
        var actualData: [Game]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGames(platform: nil) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error as? NetworkError
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(receivedError)
        XCTAssertEqual(actualData, expectedData?.games, "The actual data does not match the expected data.")
    }
    
    func testFetchGamesFailurNoData() {
        mockNetworking.mockedGames = []
        
        var actualData: [Game]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGames(platform: nil) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error as? NetworkError
            }
        }
                
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.noData, "The error received \(String(describing: receivedError)) is different from the NetworkError.noDate")
        XCTAssertNil(actualData)
    }
    
    func loadGamesCollection(fromResource resource: String) -> GamesCollection? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let gamesCollection = try decoder.decode(GamesCollection.self, from: jsonData)
            return gamesCollection
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }
}
