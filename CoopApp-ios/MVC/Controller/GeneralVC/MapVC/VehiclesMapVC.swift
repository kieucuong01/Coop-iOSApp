//
//  VehiclesMapVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/22/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
import Mapbox

class VehiclesMapVC: BaseViewController {
    var mapView : MGLMapView = MGLMapView()
    weak var delegate : MapVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.title = NSLocalizedString("VỊ TRÍ XE", comment: "")
        
        self.mapView.frame = view.bounds
        self.mapView.showsUserLocation = true
        self.mapView.showsScale = true
        self.mapView.attributionButton.isHidden = true
        self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(self.mapView)
        
        // Setup gpsview
        let gpsView = UIButton(frame: CGRect(x: view.frame.width - 60, y: view.frame.height - 110, width: 40, height: 40))
        gpsView.setImage(UIImage(named: "ic_gps"), for: .normal)
        gpsView.addTarget(self, action: #selector(self.gpsBtnAction), for: .touchUpInside)
        gpsView.backgroundColor = .white
        view.addSubview(gpsView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        self.mapView.delegate = self
    }
    
    func initData() {
        // Remove old data
        if let anotations = self.mapView.annotations {
            self.mapView.removeAnnotations(anotations)
        }
        
        self.callAPIVehicleList(completionHandler: {transportsInfo in
            for transportInfo in transportsInfo {
                if let status = transportInfo.vehicle!.status  {
                    // Declare the marker `hello` and set its coordinates, title, and subtitle.
                    let hello = MGLPointAnnotation()
                    hello.coordinate = CLLocationCoordinate2D(latitude: status.lat, longitude: status.lon)
                    hello.title = String(format: "%@ %@", "Biển số: ", transportInfo.vehicle!.plate_number)
                    hello.subtitle = String(format: "%@ %@", "Mã VC: ", transportInfo.code)
                    // Add marker `hello` to the map.
                    self.mapView.addAnnotation(hello)
                }
            }
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: transportsInfo.last?.vehicle?.status?.lat ?? 10.803068 , longitude: transportsInfo.last?.vehicle?.status?.lon ?? 106.695568), zoomLevel: 12, animated: false)
        })
    }
    
    // MARK: CALL API
    
    private func callAPIVehicleList(completionHandler: @escaping ([Transport2Model]) -> ()) {
        // Call API SUPPLIER
        if GlobalQuick.userLogin?.rule ==  UserRole.Supplier.rawValue {
            let params = ["supplier_id" : GlobalQuick.userLogin?.supplier_id ?? 0] as [String : Any]
            APIBase.sharedInstance()?.callAPITransportLocation(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error, completionHandler: {transportsInfo in
                    completionHandler(transportsInfo)
                })
            })
        }
            // CALL API WAREHOUSE
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue {
            let params = [:] as [String : Any]
            APIBase.sharedInstance()?.callAPIWarehouseTransportLocation(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPIVehicleList(result: result, error: error, completionHandler: {transportsInfo in
                    completionHandler(transportsInfo)
                })
            })
        }
    }
    
    private func completionAPIVehicleList(result : NSDictionary?, error : NSError?, completionHandler: @escaping ([Transport2Model]) -> ()) {
        if error == nil && result != nil{
            // Success
            let dics : Array<Dictionary<String,Any>> = result?["list_transports"] as! Array<Dictionary<String, Any>>
            var transportsInfo : [Transport2Model] = []
            for dic in dics {
                transportsInfo.append( Transport2Model(dict: dic))
            }
            completionHandler(transportsInfo)
        }
        else {
            // Call API Fail
            Util.showAlert("Đã có lỗi xảy ra. Vui lòng thử lại!")
        }
    }
    
    // MARK: - Action
    @objc func gpsBtnAction() {
        if (CLLocationManager.authorizationStatus() != .denied) {
            if let userLocation = self.mapView.userLocation {
                self.mapView.setCenter(userLocation.coordinate, animated: true)
            }
            self.mapView.locationManager.delegate = self
            self.mapView.locationManager.startUpdatingLocation()
            
        }
        else {
            self.mapView.locationManager.requestAlwaysAuthorization()
        }
    }
}

extension VehiclesMapVC : MGLMapViewDelegate {
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
}

extension VehiclesMapVC : MGLLocationManagerDelegate {
    func locationManagerShouldDisplayHeadingCalibration(_ manager: MGLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: MGLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: MGLLocationManager, didUpdate locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.mapView.setCenter(center, animated: true)
            
            self.mapView.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: MGLLocationManager, didUpdate newHeading: CLHeading) {
    }
}
