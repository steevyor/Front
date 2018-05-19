

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var `switch`: UISwitch!
    var partage : Bool = true
    let timer :Timer? = nil
    deinit
    {
        if let timer = self.timer
        {
            timer.invalidate()
        }
    }
    
    let del = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.zoomPos()
        self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        print(self.del.locations.longitude, del.locations.latitude)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(ViewController.updatePosition), userInfo: nil,
                             repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        updatePosition()
    }

    
    func updatePosition()
    {
        if self.partage
        {
            let latitude = del.locations.latitude
            let longitude = del.locations.longitude
            
            print("Longitude :\(longitude) , Latitude: \(latitude)")
            
            let parameters = [
                "latitude": "Longitude \(longitude)",
                "longitude": "Latitude \(latitude)",
            ]
            
            let feedURL = "163.172.154.4:8080/dant/api/test/position"
            
            var request = URLRequest(url: URL(string: feedURL)!)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else
            {
                print("Something append")
                return
            }
            request.httpBody = httpBody
            _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
                
            }.resume()
            
        }
            else
        {
            return
        }
        
    }

    
    
    @IBAction func switchButtonChanged (sender: UISwitch)
    {
        /*if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/your.bundle.identifier") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
        
        if sender.isOn
        {
            self.del.enableLocationManager()
            self.partage = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
            else
        {
            self.del.disableLocationManager()
            self.partage = false
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @IBAction func loupe(_ sender: UIButton)
    {
        self.zoomPos()        
    }
    
    func displayFriendPosition(pos: CLLocationCoordinate2D, friendName: String)
    {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pos
        annotation.title = friendName
        //annotation.UIImage(named: "pins.png")
        self.map.addAnnotation(annotation)
    }
    
    func zoomPos()
    {
        self.map.setUserTrackingMode( MKUserTrackingMode.followWithHeading, animated: true) //zoomer sur la position
    }
    
    
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue"{
           let vueAmis = segue.destination as! VueAmis
            secondViewController.
        }*/
    
    
}

