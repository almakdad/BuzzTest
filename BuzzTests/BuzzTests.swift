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
    
    func testFullReservation() {
		let url = Bundle.main.url(forResource: "FullReservation", withExtension:"json")
		let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
		let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
		
		guard let reservation = ReservationAssembler().createReservation(json) else {
			XCTFail("reservation was not built")
			return
		}
		
		XCTAssertNotNil(reservation.restaurant.profile)
		XCTAssertTrue(reservation.restaurant.dishes.count == 3)
		
		let firstDish = reservation.restaurant.dishes[0]
		XCTAssertNotEqual(firstDish.photos.count, 0)
		XCTAssertNotEqual(firstDish.snippet.highlights.count, 0)
    }
	
	func testTwoDishes() {
		let url = Bundle.main.url(forResource: "2dishes", withExtension:"json")
		let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
		let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
		
		guard let reservation = ReservationAssembler().createReservation(json) else {
			XCTFail("reservation was not built")
			return
		}
		
		XCTAssertNotNil(reservation.restaurant.profile)
		XCTAssertEqual(reservation.restaurant.dishes.count, 2)
		
		let firstDish = reservation.restaurant.dishes[0]
		XCTAssertNotEqual(firstDish.photos.count, 0)
		XCTAssertNotEqual(firstDish.snippet.highlights.count, 0)
	}
	
	func testPartialReservation() {
		let url = Bundle.main.url(forResource: "PartialReservation", withExtension:"json")
		let data = try! Data(contentsOf:url!, options: Data.ReadingOptions.uncached)
		let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
		
		guard let reservation = ReservationAssembler().createReservation(json) else {
			XCTFail("reservation was not built")
			return
		}
		
		XCTAssertNotNil(reservation.restaurant.profile)
		XCTAssertEqual(reservation.restaurant.dishes.count, 0)
	}

	
}
