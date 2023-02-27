//
//  MapViewController.swift
//  MyFirstProject
//
//  Created by Alexandr on 25.02.2023.
//

import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем координаты для 5 точек
        let coordinates = [CLLocationCoordinate2D(latitude: 41.640608, longitude: 41.626929),
                           CLLocationCoordinate2D(latitude: 41.639108, longitude: 41.623811),
                           CLLocationCoordinate2D(latitude: 41.637988, longitude: 41.625788),
                           CLLocationCoordinate2D(latitude: 41.638332, longitude: 41.627871),
                           CLLocationCoordinate2D(latitude: 41.640263, longitude: 41.628344)]

        var annotations = [MKPointAnnotation]()
        for coordinate in coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        let region = MKCoordinateRegion(center: coordinates[0], latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
    }
}
