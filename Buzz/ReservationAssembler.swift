//
//  ReservationAssembler.swift
//  Buzz
//
//  Created by Olivier Larivain on 12/2/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import Foundation
import CoreLocation

let isoFormatter: DateFormatter = {
	let isoFormatter = DateFormatter()
	isoFormatter.locale = Locale(identifier: "en_US_POSIX")
	isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
	return isoFormatter
}()

let isoNoTimezoneFormatter: DateFormatter = {
	let universalFormatter = DateFormatter()
	universalFormatter.locale = Locale(identifier: "en_US_POSIX")
	universalFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
	return universalFormatter
}()

class ReservationAssembler {
	
	func createReservation(_ dto: [String : Any]?) -> Reservation? {
		guard let dto = dto,
			let utcDateString = dto["utcDateTime"] as? String,
			let utcDate = isoFormatter.date(from: utcDateString),
			let localDateString = dto["dateTime"] as? String,
			let localDate = isoNoTimezoneFormatter.date(from: localDateString),
			let partySize = dto["partySize"] as? Int,
			let restaurant = self.createRestaurant(dto["restaurant"] as? [String : Any]) else {
				return nil
		}
		let confirmationMessage = dto["confirmationMessage"] as? String
		
		return Reservation(restaurant: restaurant,
		                   utcDate: utcDate,
		                   localDate: localDate,
		                   partySize: partySize,
		                   confirmationMessage: confirmationMessage,
		                   canBeModified: true)
	}
	
	private func createRanges(_ dtos: [[String : Any]]?) -> [NSRange]? {
		guard let dtos = dtos else {
			return nil
		}
		return dtos.flatMap { return self.createRange($0) }
	}
	private func createRange(_ dto: [String : Any]?) -> NSRange? {
		guard let dto = dto,
		let location = dto["location"] as? Int,
			let length = dto["length"] as? Int else {
				return nil
		}
		
		return NSRange(location: location, length: length)
	}
	
	private func createSnippet(_ dto: [String : Any]?) -> Snippet? {
		guard let dto = dto,
			let content = dto["content"] as? String,
			let range = self.createRange(dto["range"] as? [String : Any]),
			let highlights = self.createRanges(dto["highlights"] as? [[String : Any]]) else {
				return nil
		}
		
		return Snippet(content: content, range: range, highlights: highlights)
	}
	
	private func createDishes(_ dtos: [[String : Any]]?) -> [Dish]? {
		guard let dtos = dtos else {
			return nil
		}
		
		return dtos.flatMap { (dto) -> Dish? in
			guard let id = dto["id"] as? String,
				let name = dto["name"] as? String,
				let photos = self.createPhotos(dtos: dto["photos"] as? [[String : Any]]),
				photos.count > 0,
				let snippet = self.createSnippet(dto["snippet"] as? [String : Any]) else {
					return nil
			}		
			return Dish(id: id, name: name, photos: photos, snippet: snippet)
		}
	}
	
	private func createPhotos(dtos: [[String:Any]]?) -> [Photo]? {
		guard let dtos = dtos else {
			return nil
		}
		
		return dtos.map { (dto) -> Photo? in
			return self.createPhoto(dto)
			}.flatMap {$0}
	}
	
	private func createPhoto(_ dto: [String : Any]?) -> Photo? {
		guard let dto = dto,
			dto.count > 0 else {
			return nil
		}
		
		let photoSizes = self.createPhotoSizes(dto["references"] as? [[String:AnyObject]])
		guard let photo = Photo(sizes: photoSizes) else {
			return nil
		}
		
		photo.photoId = dto["id"] as? String
		photo.name = dto["name"] as? String
		
		return photo
	}
	
	private func createPhotoSizes(_ dtos: [[String:Any]]?) -> [PhotoSize] {
		guard let dtos = dtos else {
			return []
		}
		
		return dtos.map { (dto) -> PhotoSize? in
			guard let uri = dto["uri"] as? String else {
				return nil
			}
			
			let width = dto["width"] as? Int
			let height = dto["height"] as? Int
			return PhotoSize(uri: uri, width: width, height: height)
			
			}.flatMap {$0}
		
	}

	
	private func createRestaurant(_ dto: [String : Any]?) -> Restaurant? {
		guard let dto = dto,
			let id = dto["id"] as? String,
			let name = dto["name"] as? String,
			let street = dto["street"] as? String,
			let city = dto["city"] as? String,
			let state = dto["state"] as? String,
			let zip = dto["zip"] as? String,
			let country = dto["country"] as? String,
			let latitude = dto["latitude"] as? Double,
			let longitude = dto["longitude"] as? Double,
			let dishes = self.createDishes(dto["dishes"] as? [[String : Any]]) else {
				return nil
		}
		
		let profile = self.createPhoto(dto["profilePhoto"] as? [String : Any])
		return Restaurant(id: id,
		                  name: name,
		                  street: street,
		                  city: city,
		                  state: state,
		                  zip: zip,
		                  country: country,
		                  location: CLLocation(latitude: latitude, longitude: longitude),
		                  profile: profile,
		                  dishes: dishes)
	}
}
