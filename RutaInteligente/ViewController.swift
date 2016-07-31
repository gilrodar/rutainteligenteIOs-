//
//  ViewController.swift
//  RutaInteligente
//
//  Created by Yepes on 30/07/16.
//  Copyright © 2016 yepes. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var Estacion: UILabel!
    @IBOutlet var imagenEstacion: UIImageView!
    @IBOutlet var llegada1: UILabel!
    @IBOutlet var llegada2: UILabel!    
    @IBOutlet var Ocupacion1: UILabel!
    @IBOutlet var Ocupacion2: UILabel!
    
    let manager = CLLocationManager()
    var latituduser : Double!
    var longituduser : Double!
    var IdCercano : Int!
    
    
    var counter = 268
    var counter2 = 354
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LOCALIZACION Usuario!
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startMonitoringSignificantLocationChanges()
        
        
        self.latituduser = manager.location!.coordinate.latitude
        self.longituduser = manager.location!.coordinate.longitude        
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateCounter2), userInfo: nil, repeats: true)
        
        //Buscar la estacion mas cercana a tu ubicacion.
 
        
        let params = ["lat":self.latituduser!,"lon":self.longituduser!]
        
        
        // Trae la estacion mas cerca a tu ubicacion!
        Alamofire.request(.GET,"http://192.168.119.180:8080/json/closest", parameters:params).responseJSON{ response in
            do{
                //Dictionaty<String.AnyObject>    Asi trabaja los JSON xCode
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                
                self.IdCercano = json["id"] as! Int
                
            }catch{
                print("Error al convertir a JSON")
            }
            
        }
        
        
        
        
        //Estaciones
        Alamofire.request(.GET,"http://192.168.119.180:8080/json/stations").responseJSON{ response in
            //print(response.description)
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //print(json)
                
                let estaciones = json["stations"] as! [Dictionary <String, AnyObject>]
                
                for est in estaciones{
                    
                    let ids = est["id"] as! Int
                    
                    if (self.IdCercano == ids){
                        
                        let nombre = est["name"] as! String
                        let img = est["urlimg"] as! String
                        
                        self.Estacion.text = nombre
                        
                        Alamofire.request(.GET, img).response { (request, response, data, error) in
                            self.imagenEstacion.image = UIImage(data: data!, scale:1)
                        }
                        return
                    }
                    
                }
            }catch{
                print("Error al leer el JSON")
            }
        }
        
        //Autobus
        Alamofire.request(.GET,"http://192.168.119.180:8080/json/buses").responseJSON{ response in
            //print(response.description)
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //print(json)
                
                let estaciones = json["buses"] as! [Dictionary <String, AnyObject>]
                
                for est in estaciones{
                    
                    //let latitudbus = est["latitude"] as! Float64
                    //let longitudbus = est["longitude"] as! Float64
                    
                    
                    let sig = est["nextstation"] as! Int
                    let ant = est["prevstation"] as! Int
                    
                    
                    if self.IdCercano == sig{
                        
                        if (self.IdCercano + 1 == ant){
                            //Buenavista-IndiosVerdes
                            //let idbus = est["id"] as! Int
                            let ocupacionbus = est["room"] as! Int
                            
//                            let tiempollegadabus = est["timetonextstation"] as! Int
//                            
//                            let seconds: Int = tiempollegadabus % 60
//                            let minutes: Int = (tiempollegadabus / 60) % 60
//                            let hours: Int = tiempollegadabus / 3600
                            
                            self.Ocupacion2.text = self.Ocupacion2.text! + " \(ocupacionbus)%"
                            
                            //if hours == 0{
                             //   self.llegada2.text = self.llegada2.text! + (" " + String(format: "%02d min %02d seg", minutes, seconds))
                            //}
                            //else{
                            //   self.llegada2.text = self.llegada2.text! + (" " + String(format: "%02d hor %02d min %02d seg", hours, minutes, seconds))
                            //}
                            //break
                        
                        }else if (self.IdCercano - 1 == ant){
                            // IndiosVerdes - Buenavista
                            //let idbus = est["id"] as! Int
                            let ocupacionbus = est["room"] as! Int
                            let tiempollegadabus = est["timetonextstation"] as! Int
                            
                            let seconds: Int = tiempollegadabus % 60
                            let minutes: Int = (tiempollegadabus / 60) % 60
                            let hours: Int = tiempollegadabus / 3600
                            
                            
                            self.Ocupacion1.text = self.Ocupacion1.text! + " \(ocupacionbus)%"
                            
                            if hours == 0{
                                self.llegada1.text = self.llegada1.text! + (" " + String(format: "%02d min %02d seg", minutes, seconds))
                            }
                            else{
                                self.llegada1.text = self.llegada1.text! + (" " + String(format: "%02d hor %02d min %02d seg", hours, minutes, seconds))
                            }
                            break
                        }else{
                            break
                        }
                    }
                }
                
            }catch{
                print("Error al leer el JSON")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCounter() {
        //you code, this is an example
        if counter > 0 {
            
            let seconds: Int = counter % 60
            let minutes: Int = (counter / 60) % 60
            let hours: Int = counter / 3600
            
            
            if hours == 0{
               self.llegada1.text = ("Llega en: " + String(format: "%02d min %02d seg", minutes, seconds))
            }
            else{
               self.llegada1.text = ("Llega en: " + String(format: "%02d hor %02d min %02d seg", hours, minutes, seconds))
            }
            counter -= 1
        }
    }
    
    func updateCounter2() {
        if counter2 > 0{
            let seconds1: Int = counter2 % 60
            let minutes1: Int = (counter2 / 60) % 60
            let hours1: Int = counter2 / 3600
            
            
            if hours1 == 0{
                self.llegada2.text = ("Llega en: " + String(format: "%02d min %02d seg", minutes1, seconds1))
            }
            else{
                self.llegada2.text = ("Llega en: " + String(format: "%02d hor %02d min %02d seg", hours1, minutes1, seconds1))
            }
            counter2 -= 1
        }
    
    }
    
    
}

