import UIKit
import SwiftKeychainWrapper
import Alamofire

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
    

    @IBAction func connexion(_ sender: Any)
    
    {
        

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
        
            let token = NSUUID.init(uuidString: password!)?.uuidString
        
            let saveSuccessful: Bool = KeychainWrapper.standard.set(token!, forKey: "getToken()")
        
            let parameters = [
                "token": "\(NSUUID.init(uuidString: password!)?.uuidString ?? "0")"
            ]
        
            var url = "http://localhost:8080/check"
            url.append("/\(token ?? "ok")")
            Alamofire.request(url, method:.post, parameters:parameters,encoding: JSONEncoding.default).responseJSON { response in
                switch response.result {
                case .success:
                    print(response.result.value)
                case .failure(let error):
                    print("\(error)")
                
                    let monAlerte = UIAlertController(title: "☔️", message: "Une erreur esr survenue", preferredStyle: UIAlertControllerStyle.alert)
                    monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
                    self.present(monAlerte, animated: true, completion: nil)
                    
                }
            }
        
            
    }
            
        }



