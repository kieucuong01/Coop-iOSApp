//
//  MapVC.swift
//  CoopApp-ios
//
//  Created by MAC on 3/20/19.
//  Copyright © 2019 Minerva. All rights reserved.
//

import UIKit
import Mapbox
import RMQClient

protocol MapVCDelegate : class {
    func updatedStatusVehicle(statusID : VehicleStatus)
}

class MapVC: BaseViewController {
    var vehicle : VehicleModel?
    var mapView : MGLMapView = MGLMapView()
    weak var delegate : MapVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        self.send()
    }
    // MARK: - Private func
    private func initView() {
        self.title = NSLocalizedString("VỊ TRÍ XE", comment: "")
        
        self.vehicle = self.data["vehicleModel"] as? VehicleModel
        if let statusVehicle = self.vehicle!.status {
            // Setup mapview
            self.mapView.frame = view.bounds
            self.mapView.showsUserLocation = true
            self.mapView.attributionButton.isHidden = true
            self.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Set the map’s center coordinate and zoom level.
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: statusVehicle.lat, longitude: statusVehicle.lon), zoomLevel: 12, animated: false)

            view.addSubview(self.mapView)

            // Setup gpsview
            let gpsView = UIButton(frame: CGRect(x: view.frame.width - 60, y: view.frame.height - 60, width: 40, height: 40))
            gpsView.setImage(UIImage(named: "ic_gps"), for: .normal)
            gpsView.addTarget(self, action: #selector(self.gpsBtnAction), for: .touchUpInside)
            gpsView.backgroundColor = .white
            view.addSubview(gpsView)
            
            // Setup reportView
            if self.vehicle?.transport != nil {
                let reportView = UIButton(frame: CGRect(x: view.frame.width - 60, y: view.frame.height - 105 , width: 40, height: 40))
                reportView.setImage(UIImage(named: "ic_problem"), for: .normal)
                reportView.addTarget(self, action: #selector(self.problemBtnAction), for: .touchUpInside)
                reportView.backgroundColor = .white
                view.addSubview(reportView)
            }

            // Set the delegate property of our map view to `self` after instantiating it.
            self.mapView.delegate = self

            // Declare the marker `hello` and set its coordinates, title, and subtitle.
            let hello = MGLPointAnnotation()
            hello.coordinate = CLLocationCoordinate2D(latitude: statusVehicle.lat, longitude: statusVehicle.lon)
            hello.title = String(format: "%@ %d", "Tốc độ: ", statusVehicle.speed)
            //            hello.subtitle = String(statusVehicle.speed)
            
            // Add marker `hello` to the map.
            self.mapView.addAnnotation(hello)
        }
    }
    
    // MARK: - RabbitMQ
    private func send() {
        print("Attempting to connect to RabbitMQ broker")
        let delegate = RMQConnectionDelegateLogger()
        let conn = RMQConnection(uri: "amqp://coopmart:coopmart@118.69.82.125:5672/coopmart", delegate: delegate)
        conn.start()
        let ch = conn.createChannel()
        let q = ch.queue("coopmart", options: .durable)
        
        ch.defaultExchange().publish("coopmart".data(using: .utf8), routingKey: q.name)
        print("Sent 'Hello World!'")
//        conn.close()
    }
    
    
    // MARK: - API
    private func callAPITransactionStatus(transportId: Int, statusId : VehicleStatus){
        // Call API
        let params = ["transport_id" : transportId,
                      "status_id": statusId.rawValue] as [String : Any]
        
        if GlobalQuick.userLogin?.rule == UserRole.Supplier.rawValue {
            APIBase.sharedInstance()?.callAPITransportStatus(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionStatus(result: result, error: error, statusId: statusId)
            })
        }
        else if GlobalQuick.userLogin?.rule == UserRole.Warehouse.rawValue{
            APIBase.sharedInstance()?.callAPIWarehouseTransportStatus(isShowHUD: true, params: params, completionHandler: { (result, error) in
                self.completionAPITransactionStatus(result: result, error: error, statusId: statusId)
            })
        }
    }
    
    private func completionAPITransactionStatus(result : NSDictionary?, error : NSError?, statusId : VehicleStatus) {
        if error == nil {
            self.delegate?.updatedStatusVehicle(statusID: statusId)
            // Success
            Util.showAlert("Thành công")
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
    
    @objc func problemBtnAction() {
        if self.vehicle?.transport?.status_id == VehicleStatus.STATUS_START.rawValue {
            Util.showConfirmAlert("THÔNG BÁO GẶP SỰ CỐ ", yesCompletion: {
                self.callAPITransactionStatus(transportId: self.vehicle?.transport?.id ?? 0, statusId: VehicleStatus.STATUS_BROKEN)
            })
        }
        else {
            Util.showConfirmAlert("THÔNG BÁO KẾT THÚC SỰ CỐ", yesCompletion: {
                self.callAPITransactionStatus(transportId: self.vehicle?.transport?.id ?? 0, statusId: VehicleStatus.STATUS_START)
            })
        }
    }
}

extension MapVC : MGLMapViewDelegate {
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}

extension MapVC : MGLLocationManagerDelegate {
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
