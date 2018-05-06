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
        /* criteres pour une inscription reussie:
            remplir tous les champs
            les deux mots de passe sont différents
            email et login n'existent pas déjà
            mot de passe assez long ? */
 
 
        
        if password1.text == password2.text {
            //Alert.alert()
            //alert.createAlert(msg: "inscription effectuée vous pouvez maintenant vous connecter")
            let monAlerte = UIAlertController(title: "", message:
                "L'inscription a bien été prise en compte!", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(monAlerte, animated: true, completion: nil)
            

            
        } else {
            //alert()
            //alert.createAlert(msg: "l'inscription à échoué, mots de passe différents")
            let monAlerte = UIAlertController(title: "", message:
                "Attention les mots de passe entrés sont différents!", preferredStyle: UIAlertControllerStyle.alert)
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
