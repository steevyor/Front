

import UIKit

class LoginPage: UIViewController {

    @IBOutlet weak var loginPage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func connexion(_ sender: Any) {
        //Voir si le mot de passe est ok
        
        if !true {
            
                
            } else {
               let monAlerte = UIAlertController(title: "", message:
                    "Login ou mot de passe incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(monAlerte, animated: true, completion: nil)

        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
