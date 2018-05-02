

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map.setUserTrackingMode( MKUserTrackingMode.follow, animated: true) //zoomer sur la position
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func switchButtonChanged (sender: UISwitch) {
        /*if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION/your.bundle.identifier") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }*/
        
        let del = UIApplication.shared.delegate as! AppDelegate
        
        if sender.isOn {
            del.enableLocationManager()
        } else {
            del.disableLocationManager()
        }
    }
    
    
}

