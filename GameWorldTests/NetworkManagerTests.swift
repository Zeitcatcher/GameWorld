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
    
    func testFetchGamesFailurDecodingError() {
        mockNetworking.shouldReturnError = true
        
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
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }
    
    func testFetchGameSuccess() {
        let expectation = self.expectation(description: "FetchGame")
        let expectedData: [Game]? = loadGames(fromResource: "GamesResponse")
        mockNetworking.mockedGames = expectedData
        
        var actualData: [Game]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGame(gameName: "Grand Theft Auto V") { result in
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
        XCTAssertEqual(actualData, expectedData, "The actual data does not match the expected data.")
    }
    
    func testFetchGameFailureNoData() {
        mockNetworking.mockedGames = []
        
        var actualData: [Game]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGame(gameName: "Grand Theft Auto V") { result in
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
    
    func testFetchGameFailureDecodingError() {
        mockNetworking.shouldReturnError = true
        
        var actualData: [Game]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGame(gameName: "Grand Theft Auto V") { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error as? NetworkError
            }
        }
        
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }
    
    func testFetchPlatformsSuccess() {
        let expectation = self.expectation(description: "FetchPlatform")
        let expectedData: [Platform]? = loadPlatforms(fromResource: "PlatformResponse")
        mockNetworking.mockedPlatforms = expectedData
        
        var actualData: [Platform]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchPlatforms { result in
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
        XCTAssertEqual(actualData, expectedData, "The actual data does not match the expected data.")
    }
    
    func testFetchPlatformsFailureNoData() {
        mockNetworking.mockedPlatforms = []
        
        var actualData: [Platform]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchPlatforms { result in
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
    
    func testFetchPlatformsFailureDecodingError() {
        mockNetworking.shouldReturnError = true
        
        var actualData: [Platform]?
        var receivedError: NetworkError?
        
        mockNetworking.fetchPlatforms { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error as? NetworkError
            }
        }
            
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }
    
    func testFetchGameDescriptionSuccess() {
        let expectation = self.expectation(description: "FetchGameDescription")
        let expectedData: Game? = loadGameDescription(fromResource: "GameDescriptionResponce")
        mockNetworking.mockedGameDescription = expectedData
        
        var actualData: Game?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGameDescription(gameID: 1) { result in
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
        XCTAssertEqual(actualData, expectedData, "The actual data does not match the expected data.")
    }
    
    func testFetchGameDescriptionFailureNoData() {
        var actualData: Game?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGameDescription(gameID: 1) { result in
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
    
    func testFetchGameDescriptionFailureDecodingError() {
        mockNetworking.shouldReturnError = true
        
        var actualData: Game?
        var receivedError: NetworkError?
        
        mockNetworking.fetchGameDescription(gameID: 1) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                receivedError = error as? NetworkError
            }
        }
                
        XCTAssertNotNil(receivedError)
        XCTAssert(receivedError == NetworkError.decodingError, "The error received \(String(describing: receivedError)) is different from the NetworkError.decodingError")
        XCTAssertNil(actualData)
    }
    
    func loadGameDescription(fromResource resource: String) -> Game? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let game = try decoder.decode(Game.self, from: jsonData)
            return game
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }
    
    func loadPlatforms(fromResource resource: String) -> [Platform]? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let platforms = try decoder.decode([Platform].self, from: jsonData)
            return platforms
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
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
    
    func loadGames(fromResource resource: String) -> [Game]? {
        guard let url = Bundle(for: type(of: self)).url(forResource: resource, withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let game = try decoder.decode([Game].self, from: jsonData)
            print("loadGame response: \(game)")
            return game
        } catch {
            print("Error decoding the JSON: \(error)")
            return nil
        }
    }
}
