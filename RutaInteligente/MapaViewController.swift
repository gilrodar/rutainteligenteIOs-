//
//  MapaViewController.swift
//  RutaInteligente
//
//  Created by Yepes on 30/07/16.
//  Copyright © 2016 yepes. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import AlamofireImage
import CoreLocation

class MapaViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    let locationManager = CLLocationManager()
    var latituduser = 19.45688
    var longituduser = -99.14915
    var latituduser1 = 19.44695
    var longituduser1 = -99.15302
    var latituduser2 = 19.45966
    var longituduser2 = -99.14651
    var IdCercano: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
//        self.latituduser = locationManager.location!.coordinate.latitude
//        self.longituduser = locationManager.location!.coordinate.longitude
        
        
        //Trae la estacion mas cerca a tu ubicacion!
        
//        let params = ["lat": self.latituduser!,"lon": self.longituduser!]
//        
//        Alamofire.request(.GET,"http://192.168.119.180:8080/json/closest", parameters:params).responseJSON{ response in
//            print(response.description)
//            //print(response.data)
//            do{
//                //Dictionaty<String.AnyObject>    Asi trabaja los JSON xCode
//                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
//                print(json)
//                self.IdCercano = json["id"] as! Int
//                
//                print(self.IdCercano)
//                
//            }catch{
//                print("Error al convertir a JSON")
//            }
//            
//        }
        
        
//        Alamofire.request(.GET,"http://192.168.119.180:8080/json/stations").responseJSON{ response in
//            print (response.data)
//            
//            do{
//                
//                
//                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
//
//                
//                let estaciones = json["stations"] as! [Dictionary <String, AnyObject>]
//                for est in estaciones{
//                    
//                    let id = est["id"] as! Int
//                    print(id)
//                    
//                    if (self.IdCercano == id){
//                        
//                        self.latitudEstacion = est["latitude"] as! Double
//                        self.longitudEstacion = est["longitude"] as! Double
//                        
//                    }
//                    
//                }
//                
//            }catch{
//                print("Error al leer el JSON")
//            }
//        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let center = CLLocationCoordinate2DMake(self.latituduser, self.longituduser)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.map.setRegion(region, animated: true)
        
        //self.map.removeAnnotations(map.annotations)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latituduser, self.longituduser) 
        
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Manuel González"
        self.map.addAnnotation(objectAnnotation)
        
        let pinLocation1 : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latituduser1, self.longituduser1)
        let objectAnnotation1 = MKPointAnnotation()
        objectAnnotation1.coordinate = pinLocation1
        objectAnnotation1.title = "Buenavista"
        self.map.addAnnotation(objectAnnotation1)

        let pinLocation2 : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latituduser2, self.longituduser2)
        let objectAnnotation2 = MKPointAnnotation()
        objectAnnotation2.coordinate = pinLocation2
        objectAnnotation2.title = "San Simon"
        self.map.addAnnotation(objectAnnotation2)
        
        
    }
    
    
}
