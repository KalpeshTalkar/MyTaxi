//
//  MyTaxiAppTests.swift
//  MyTaxiAppTests
//
//  Created by Kalpesh Talkar on 20/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

import XCTest
@testable import MyTaxiApp

var sut1: MapViewModel!
var sut2: TaxiListViewModel!

class MyTaxiAppTests: XCTestCase {

    override func setUp() {
        super.setUp()
        sut1 = MapViewModel()
        sut2 = TaxiListViewModel()
    }

    override func tearDown() {
        sut1 = nil
        sut2 = nil
        super.tearDown()
    }

    func testMapViewModel() {
        let coordinate1 = Coordinate(latitude: 53.694865, longitude: 9.757589)
        let coordinate2 = Coordinate(latitude: 53.394655, longitude: 10.099891)
        
        let promise = expectation(description: "Search Taxis")
        sut1.searchTaxis(coordinate1: coordinate1, coordinate2: coordinate2) { (success, error) in
            if error != nil {
                XCTFail("Error: \(error!)")
                return
            }
            if success {
                promise.fulfill()
            } else {
                XCTFail("Error: No taxis found")
            }
            //XCTAssertEqual(success, true)
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testListViewModel() {
        sut2 = TaxiListViewModel(sut1.taxiList)
        XCTAssertEqual(sut2.taxiList, sut1.taxiList)
    }

    func testPerformanceExample() {
        self.measure {
            testMapViewModel()
        }
    }

}
