import UIKit
import MapKit

class MapViewController: BaseViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    var artworks: [Artwork] = []
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 6000
    
    // MARK: - Search
    
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearch.Request!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearch.Response!
    
    // MARK: - Map variables
    
    fileprivate var annotation: MKAnnotation!
    fileprivate var locationManager: CLLocationManager =  CLLocationManager()
    fileprivate var isCurrentLocation: Bool = false
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardNErrorTapAround()
        // set initial location
        self.currentLocationBtnAction(UIButton())
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(ArtworkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData()
        mapView.addAnnotations(artworks)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidAppear(animated)
        self.checkLocationAuthorizationStatus()
    }
    
    // MARK: - Actions
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @IBAction func currentLocationBtnAction(_ sender: UIButton) {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - Helper methods
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadInitialData() {
        // 1
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            // 2
            let json = try? JSONSerialization.jsonObject(with: data),
            // 3
            let dictionary = json as? [String: Any],
            // 4
            let works = dictionary["data"] as? [[Any]]
            else { return }
        // 5
        let parkingPlaces = works.compactMap { ParkingPlaceModel(json: $0) }
        
        let parkingAnotations = parkingPlaces.compactMap{Artwork(parkingPlace: $0)}
        
        artworks.append(contentsOf: parkingAnotations)
    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.alpha = 0.5
        renderer.lineWidth = 4.0
        return renderer
    }
    
    //   1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        // 2
        let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
        var view: ArtworkView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? ArtworkView { // 3
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 4
            view = ArtworkView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        //    let location = view.annotation as! Artwork
        //    let launchOptions = [MKLaunchOptionsDirectionsModeKey:
        //      MKLaunchOptionsDirectionsModeDriving]
        //    location.mapItem().openInMaps(launchOptions: launchOptions)
        
        // clear all routes
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let location = view.annotation as! Artwork
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        let sourcePlaceMark = MKPlacemark(coordinate: locValue)
        let destinationPlaceMark = MKPlacemark(coordinate: location.coordinate)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}

