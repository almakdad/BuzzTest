//
//  Reservation.swift
//  Buzz
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import CoreGraphics

public class PhotoSize: NSObject {
	public let width: Int
	public let height: Int
	public let uri: String
	
	required public init?(uri: String, width: Int?, height: Int?) {
		guard uri.characters.count > 0 else {
			return nil
		}
		
		self.uri = uri
		self.height = height ?? Int.max
		self.width = width ?? Int.max
	}
}

public class Photo: NSObject {
	
	public let photoSizes: [PhotoSize]
	public var photoId: String?
	public var name: String?
	
	public required init?(sizes: [PhotoSize]) {
		guard sizes.count > 0 else {
			return nil
		}
		self.photoSizes = sizes
	}
	
	public func urlForSize(desiredSize: CGSize) -> String {
		let scale = 1.0 / UIScreen.main.scale
		let desiredWidth = scale * desiredSize.width
		for size in self.photoSizes {
			if CGFloat(size.width) >= desiredWidth {
				return size.uri
			}
		}
		
		return self.photoSizes[self.photoSizes.count - 1].uri
	}
	
}

struct Snippet {
	let content: String
	let range: NSRange
	let highlights: [NSRange]
}

struct Dish {
	let id: String
	let name: String
	
	let photos: [Photo]
	let snippet: Snippet
}

struct Restaurant {
	let id: String
	let name: String
	
	let street: String
	let city: String
	let state: String
	let zip: String
	let country: String
	
	let location: CLLocation
	
	let profile: Photo?
	let dishes: [Dish]
}

struct Reservation {
	
	let restaurant: Restaurant
	
	let utcDate: Date
	let localDate: Date
	
	let partySize: Int
	
	let confirmationMessage: String?
	
	var canBeModified: Bool = true
}
