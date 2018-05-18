import UIKit
import SwiftKeychainWrapper

class LoginPage: UIViewController
{

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
        else
        {
            return
            
            let parameters = [
                "login": "\(login ?? "ok")",
                "login": "\(password ?? "ok")"
            ]
            let loading = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            loading.center = loginPage.center
            loading.hidesWhenStopped = false
            loading.startAnimating()
            loginPage.addSubview(loading)
            
            let feedURL = "163.172.154.4:8080/dant/api/test/authentificate"
            var request = URLRequest(url: URL(string: feedURL)!)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
            request.httpBody = httpBody
            _ = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let jsonData = data ,
                    let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary , let token = feed.value(forKeyPath: "feed.entry.im:token.label") as? String{
                    
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
            
            loading.stopAnimating()
        }
    }
        
             /*
            let loading = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            loading.center = loginPage.center
        
            
            loading.hidesWhenStopped = false
            
            loading.startAnimating()
            
            loginPage.addSubview(loading)
        
        func loadImage(from URL: URL) {
            let request = URLRequest(url: URL)
            let session = URLSession.shared.dataTask(with: request ,
                                                     completionHandler: { (data, response, error) in
                                                        if let imageData = data {
                                                            self.imageView.image = UIImage(data: imageData)
                                                        }
            })
            session.resume()
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            
            
            
            
            //titleLabel.text = titleText
            let request = URLRequest(url: URL(string: self.feedURL)!)
            let session = URLSession.shared.dataTask(with: request ,completionHandler:
            { (data, response, error) in
                if let jsonData = data ,
                    let feed = (try? JSONSerialization.jsonObject(with: jsonData , options: .mutableContainers)) as? NSDictionary , let title = feed.value(forKeyPath: "feed.entry.im:name.label") as? String ,
                    let artist = feed.value(forKeyPath: "feed.entry.im:artist.label") as? String ,
                    let imageURLs = feed.value(forKeyPath: "feed.entry.im:image") as? [NSDictionary] {
                    if let imageURL = imageURLs.last ,
                        let imageURLString = imageURL.value(forKeyPath: "label") as? String{
                        self.loadImage(from: URL(string:imageURLString)!)
                        self.titleLabel.text = title
                        self.titleLabel.isHidden = false
                        self.arstistLabel.text = artist
                        self.arstistLabel.isHidden = false
                    }
                    
                }
                
                
            })
            session.resume() }

            
            let parameters = [
                "login" : "\(login)",
                "pwd" : "\(password)"
            ]
        
            var url = "http://localhost:8080/check"
            url.append("/authentificate")
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
            }*/
        
            
}
            




