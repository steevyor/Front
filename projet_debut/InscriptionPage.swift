
import UIKit

class InscriptionPage: UIViewController {
    
    @IBOutlet weak var loginPage: UIImageView!
    
    @IBOutlet weak var login: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password1: UITextField!
    
    @IBOutlet weak var password2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inscription(_ sender: UIButton) {
        let alert = Alert()
        
        if password1 == password2 {
            //Alert.alert()
            alert.createAlert(msg: "inscription effectuée vous pouvez maintenant vous connecter")
            
        } else {
            //alert()
            alert.createAlert(msg: "l'inscription à échoué, mots de passe différents")
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
