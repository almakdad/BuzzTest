//
//  BuzzTests.swift
//  BuzzTests
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import Buzz

class BuzzTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAssembler() {
		let url = Bundle.main.url(forResource: "api.v1.user.reservation.GET", withExtension:"json")
		let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
		let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
		
		guard let reservation = ReservationAssembler().createReservation(json) else {
			XCTFail("reservation was not built")
			return
		}
		
		XCTAssertNotNil(reservation.restaurant.profile)
		XCTAssertNotEqual(reservation.restaurant.dishes.count, 0)
		
		let firstDish = reservation.restaurant.dishes[0]
		XCTAssertNotEqual(firstDish.photos.count, 0)
		XCTAssertNotEqual(firstDish.snippet.highlights.count, 0)
    }
	
}
