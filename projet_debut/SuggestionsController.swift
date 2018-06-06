

import Foundation
import UIKit
class SuggestionsController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {
    
    
    @IBOutlet weak var suggestionList: UITableView!
    var user: User = User.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSuggestions()
        
        suggestionList.dataSource = self
        suggestionList.delegate = self
        
        
    }
    
    //par rapport à la mémoire et au nombre de lignes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.getSuggestions().getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        if indexPath.row < self.user.getSuggestions().getList().count {
            cell.textLabel?.text = self.user.getSuggestions().getList()[indexPath.row].getPseudo()
            cell.imageView?.image = UIImage.init(named: self.user.getSuggestions().getList()[indexPath.row].getImage())

        }
        
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getSuggestions()
    }
    
    //actions sur une invitation
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        let addClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.inviter(recepterPseudo: self.user.getSuggestions().getList()[indexPath.row].getPseudo(), row: [indexPath])
        }
        
        let inviteSuggestion = UITableViewRowAction(style: .default, title: "Ajouter", handler: addClosure)
        inviteSuggestion.backgroundColor = UIColor.green
        return [inviteSuggestion]
        
    }
    
    func getSuggestions()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("VueSuggestions.getSuggestions: ")
        
        let parameters = [
            "userPseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())"
            ] as [String : AnyObject]
        
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/getFriendSuggestions")!
        print("VueSuggestions.getSuggestions : URL : \(url)")
        print("VueSuggestions.getSuggestions : token : \(self.user.getToken())")
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("VueSuggestions.getSuggestions : Statut : \(statut)")
                
                self.user.deleteAllInvitationRequest()
                if let tab = response["suggestions"] as? [AnyObject] {
                    print("VueSuggestions.getSuggestions :  Récupération des résultat")
                    print("VueSuggestions.getSuggestions : suggestions : \(tab)")
                    
                    for i in 0..<tab.count {
                        print("VueSuggestions.getSuggestions : user : \(tab[i])")
                        var f: Friend = Friend.init()
                        f.setPseudo(s: tab[i] as! String )
                        self.user.addSuggestion(request: f)
                    }
                    print("VueSuggestions.getSuggestions : results : \(self.user.getSuggestions())")
                } else {
                    print("VueSuggestions.getSuggestions : Aucun résultat ")
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                DispatchQueue.main.async(execute: {
                    self.suggestionList.reloadData()
                })
                
        }
        )
    }
    
    func inviter(recepterPseudo: String, row: [IndexPath]){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("SuggestionController.inviter : ")
        
        let parameters = [
            "emitterPseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())",
            "recepterPseudo": "\(recepterPseudo)"
            ] as [String : AnyObject]
        
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/sendInvitation")!
        print("SuggestionController.invite : URL : \(url)")
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("VueAmisController.inviter : Statut : \(statut)")
                if statut == 200 {
                    DispatchQueue.main.async(execute: {
                        self.message(display: "Une invitation a été envoyée à \(recepterPseudo)", emoji: "☀️", dissmiss: "Ok")
                        self.user.deleteSuggestion(request: recepterPseudo)
                        self.suggestionList.deleteRows(at: row, with: UITableViewRowAnimation.automatic)
                        
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.message(display: "L'envoi de l'invitation à \(recepterPseudo) a échouée", emoji: "☂️", dissmiss: "Ok")
                    })
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                
                DispatchQueue.main.async(execute: {
                    self.suggestionList.reloadData()
                })
                
        }
        )
        
    }
    
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
    

    
        
    
    
    
}
