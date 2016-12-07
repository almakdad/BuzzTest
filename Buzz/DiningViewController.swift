//
//  DiningViewController.swift
//  Buzz
//
//  Created by Laurence Andersen on 12/4/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit
import MapKit

class DiningViewController: UIViewController, AccessoryContainerViewContent {
    
    var scrollView: UIScrollView = UIScrollView()
    var stackView: UIStackView = UIStackView()
    
    let restaurantInfoView: RestaurantInfoView = RestaurantInfoView()
    let locationView: LocationView = LocationView()
    var dishesView: UIStackView? = nil
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    var reservation: Reservation?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    func configureView () {
        title = "Reservation"
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        loadModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.cyan
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(restaurantInfoView)
        stackView.addArrangedSubview(locationView)
        
        scrollView.addSubview(stackView)
        
        installConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateForContent()
    }
    
    func installConstraints () {        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func loadModel () {
        let jsonURL = Bundle.main.url(forResource: "FullReservation", withExtension: "json")
        
        do {
            let jsonData = try! Data(contentsOf:jsonURL!)
            if let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] {
                let assembler = ReservationAssembler()
                reservation = assembler.createReservation(jsonObject)
            }
        }
    }
    
    func titleForPullView() -> String {
        if let name = reservation?.restaurant.name {
            return name
        }
        
        return ""
    }
    
    func updateForContent() {
        guard let res = reservation else {
            return
        }
        
        restaurantInfoView.nameLabel.text = res.restaurant.name
        restaurantInfoView.partySizeLabel.text = "Party Size: \(res.partySize)"
        restaurantInfoView.timeLabel.text = dateFormatter.string(from: res.localDate)
        
        if let imageURLString = reservation?.restaurant.profile?.urlForSize(desiredSize: restaurantInfoView.imageView.bounds.size), let imageURL = URL(string: imageURLString) {
            restaurantInfoView.imageView.setImageWith(imageURL)
        }
        
        locationView.addressLabel.text = "\(res.restaurant.street) \(res.restaurant.city) \(res.restaurant.state) \(res.restaurant.zip)"
        locationView.mapView.region = MKCoordinateRegion(center: res.restaurant.location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        if let dv = dishesView {
            stackView.removeArrangedSubview(dv)
            dv.removeFromSuperview()
        }
        
        if res.restaurant.dishes.count < 1 {
            return
        }
        
        dishesView = UIStackView()
        dishesView!.axis = .vertical
        dishesView!.spacing = 20.0
        dishesView!.translatesAutoresizingMaskIntoConstraints = false
        
        let dishHeadingLabel = UILabel()
        dishHeadingLabel.textAlignment = .center
        dishHeadingLabel.text = "Popular Dishes"
        dishesView!.addArrangedSubview(dishHeadingLabel)
        
        let dishesMax = (res.restaurant.dishes.count > 3) ? 3 : res.restaurant.dishes.count
        
        for index in 1...dishesMax {
            let dishView = DishView()

            let dish = res.restaurant.dishes[index - 1]
            if let dishImageURLString = dish.photos.first?.urlForSize(desiredSize: dishView.imageView.bounds.size), let dishImageURL = URL(string:dishImageURLString) {
                dishView.imageView.setImageWith(dishImageURL)
            }
            
            dishView.headingLabel.text = dish.name
            dishView.setDescriptionTextWithSnippet(snippet: dish.snippet)

            dishesView!.addArrangedSubview(dishView)
            
        }
        
        stackView.addArrangedSubview(dishesView!)
    }
}

class RestaurantInfoView: UIView {
    let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let partySizeLabel = UILabel()
    
    override func layoutSubviews() {
        backgroundColor = UIColor.lightGray
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.blue
        
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.0).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        partySizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(partySizeLabel)
        
        partySizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20.0).isActive = true
        partySizeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timeLabel)
        
        timeLabel.topAnchor.constraint(equalTo: partySizeLabel.bottomAnchor, constant: 20.0).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20.0).isActive = true
    }
}

class LocationView: UIView {
    let cardLabel: UILabel = UILabel()
    let addressLabel: UILabel = UILabel()
    let mapView: MKMapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    func configureViews () {
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cardLabel)
        
        cardLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.0).isActive = true
        cardLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cardLabel.text = "Map"
        
        backgroundColor = UIColor.lightGray
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(addressLabel)
        
        addressLabel.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 20.0).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
        
        mapView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20.0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20.0).isActive = true
    }
}

class DishView: UIView {
    let imageView = UIImageView()
    let headingLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    func configureViews () {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
    }
    
    func setDescriptionTextWithSnippet (snippet: Snippet) {
        let descriptionText = NSMutableAttributedString(string:snippet.content)
    
        for currentHighlightRange in snippet.highlights {
            descriptionText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: descriptionLabel.font.pointSize), range: currentHighlightRange)
        }
        
        descriptionLabel.attributedText = descriptionText.attributedSubstring(from: snippet.range)
        
    }
    
    override func layoutSubviews() {
        backgroundColor = UIColor.lightGray
        
        imageView.backgroundColor = UIColor.blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headingLabel)
        
        headingLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: headingLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.0).isActive = true
    }
}
