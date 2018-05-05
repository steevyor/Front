

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var `switch`: UISwitch!
    let del = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.setUserTrackingMode( MKUserTrackingMode.follow, animated: true) //zoomer sur la position
        
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
    
    
}

