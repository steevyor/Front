

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
  
    
    @IBOutlet weak var `switch`: UISwitch!
    let del = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.zoomPos()
        self.displayFriendPosition(pos: CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11), friendName: "Soso")
        print(self.del.locations.longitude, del.locations.latitude)
    }


    
    
    @IBAction func switchButtonChanged (sender: UISwitch) {
        /*if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/your.bundle.identifier") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
        
        if sender.isOn {
            self.del.enableLocationManager()
        } else {
            self.del.disableLocationManager()
        }
    }
    
    @IBAction func loupe(_ sender: UIButton) {
        self.zoomPos()        
    }
    
    func displayFriendPosition(pos: CLLocationCoordinate2D, friendName: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = pos
        annotation.title = friendName
        //annotation.UIImage(named: "pins.png")
        self.map.addAnnotation(annotation)
    
        
    }
    
    func zoomPos(){
        self.map.setUserTrackingMode( MKUserTrackingMode.follow, animated: true) //zoomer sur la position
    }
    
    
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue"{
           let vueAmis = segue.destination as! VueAmis
            secondViewController.
        }*/
    
    
}

