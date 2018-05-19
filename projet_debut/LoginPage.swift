import UIKit
import SwiftKeychainWrapper

class LoginPage: UIViewController
{

    @IBOutlet weak var loginPage: UIImageView!
    
    @IBOutlet weak var mail: UITextField!

    @IBOutlet weak var mdp: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
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
        else
        {
            return
            
            let parameters = [
                "login": "\(login!)",
                "login": "\(password!)"
            ]
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let feedURL = "163.172.154.4:8080/dant/api/test/authentificate"
            var request = URLRequest(url: URL(string: feedURL)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
            _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let jsonData = data ,
                    let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary , let token = feed.value(forKeyPath: "feed.entry.im:token.label") as? String
                {
                    
                    let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: "myKey")
                    print("\(saveSuccessful)")
                }
                    //let artist = feed.value(forKeyPath: "feed.entry.im:artist.label") as? String ,
                    //let imageURLs = feed.value(forKeyPath: "feed.entry.im:image") as? [NSDictionary] {
                    //if let imageURL = imageURLs.last ,
                        /*let imageURLString = imageURL.value(forKeyPath: "label") as? String{
                        self.loadImage(from: URL(string:imageURLString)!)
                        self.titleLabel.text = title
                        self.titleLabel.isHidden = false
                        self.arstistLabel.text = artist
                        self.arstistLabel.isHidden = false
                        */
                }.resume()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

}
            




