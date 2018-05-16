import UIKit
import SwiftKeychainWrapper

class LoginPage: UIViewController {

    @IBOutlet weak var loginPage: UIImageView!
    
    @IBOutlet weak var mail: UITextField!

    @IBOutlet weak var mdp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func connexion(_ sender: Any) {
        
        
        print("Bouton de connexion appuyé")
        
        let login = mail.text
        let password = mdp.text
        
        if (login?.isEmpty)! || (password?.isEmpty)!
        {
            
            let monAlerte = UIAlertController(title: "☔️", message: "Veillez renseigner tout les champs", preferredStyle: UIAlertControllerStyle.alert)
            monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
            self.present(monAlerte, animated: true, completion: nil)
            

            return
        }
                
            let loading = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            loading.center = loginPage.center
            
            loading.hidesWhenStopped = false
            
            loading.startAnimating()
            
            loginPage.addSubview(loading)
        
            //envoyer une requete avec le mail et le user pour authentification
        let token :String = "ok"//doit résulté du parsing après la requete
        let userId :String = "ok"//doit résulter du parsing après la requete
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "accesToken")
        let saveId: Bool = KeychainWrapper.standard.set(userId, forKey: "login")
        
        if token.isEmpty
        {
            let monAlerte = UIAlertController(title: "☔️", message: "Il y a un soucis", preferredStyle: UIAlertControllerStyle.alert)
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
