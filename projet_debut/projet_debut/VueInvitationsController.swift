import UIKit

class VueInvitationsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {
    
    @IBOutlet weak var listeDemands: UITableView!
    
    var user: User = User.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getInvitations()

        listeDemands.dataSource = self
        listeDemands.delegate = self
        
    }
    
    func tabBarController(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        /*if item.title == "Amis" {
            self.getInvitations()
            
        }*/
        print("TabBarItem Suggestions")

    }
    
    
    //par rapport à la mémoire et au nombre de lignes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user.getInvitationsRequests().getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Créer une cellule
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        cell.textLabel?.text = self.user.getInvitationsRequests().getList()[indexPath.row].getPseudo()
        //cell.detailTextLabel?.text = element.name
        
        
        return cell
    }
    
    //actions sur une invitation
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{

        let deleteClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            //TODO: ajouter l'action de suppression
            self.refuseOrAcceptInvitation(action: false, requestedPseudo: self.user.getInvitationsRequests().getList()[indexPath.row].getPseudo(), indexPath: [indexPath])
        }
        
        let addClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            self.refuseOrAcceptInvitation(action: true, requestedPseudo: self.user.getInvitationsRequests().getList()[indexPath.row].getPseudo(), indexPath: [indexPath])
        }
        
        
        let deleteFriend = UITableViewRowAction(style: .default, title: "Supprimer", handler: deleteClosure)
        
        let addFriend = UITableViewRowAction(style: .default, title: "Ajouter", handler: addClosure)
        addFriend.backgroundColor = UIColor.green
        return [ addFriend,deleteFriend]
        
    }
    
    func getInvitations()
    {
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
         print("VueInvitation.getInvitations: ")
         
         let parameters = [
         "userPseudo": "\(self.user.getPseudo())",
         "tokenKey": "\(self.user.getToken())"
         ] as [String : AnyObject]
         
         
         let url = URL(string: "https://\(ngrok).ngrok.io/api/user/invitationList")!
         print("VueInvitation.getInvitations : URL : \(url)")
        print("VueInvitation.getInvitations : token : \(self.user.getToken())")

        
         let r = Requests()
         r.post(parameters: parameters, url: url,
            finRequete:{ response, statut in
            print("VueInvitation.getInvitations : Statut : \(statut)")
            
            self.user.deleteAllInvitationRequest()
            if let tab = response["emitters"] as? [AnyObject] {
                print("VueInvitation.getInvitations :  Récupération des résultat")
                print("VueInvitation.getInvitations : invitations : \(tab)")
            
                for i in 0..<tab.count {
                    print("VueInvitation.getInvitations : user : \(tab[i])")
                    var f: Friend = Friend.init()
                    f.setPseudo(s: tab[i] as! String )
                    self.user.addInvitationRequests(request: f)
                }
                print("VueInvitation.getInvitations : results : \(self.user.getInvitationsRequests())")
            } else {
                print("VueInvitation.getInvitations : Aucun résultat ")
            }
            
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
         
        DispatchQueue.main.async(execute: {
            self.listeDemands.reloadData()
        })
         
        }
        )
    }
    
    
    func refuseOrAcceptInvitation(action: Bool, requestedPseudo: String, indexPath: [IndexPath])
    {
        print("VueInvitation.refuseOrAcceptInvitation: ")

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let parameters = [
            "emitterPseudo": "\(requestedPseudo)",
            "tokenKey": "\(self.user.getToken())",
            "recepterPseudo": "\(self.user.getPseudo())"
            ] as [String : AnyObject]
        
        var msg200 = String()
        var url = String()
        if action
        {
            url = "https://\(ngrok).ngrok.io/api/user/acceptInvitation"
            msg200 = "Invitation acceptée"
        } else {
            url = "https://\(ngrok).ngrok.io/api/user/refuseInvitation"
            msg200 = "Invitation refusée"
        }
        
        let r = Requests()
        
        r.post(parameters: parameters as [String : AnyObject], url: URL(string: url)!,
                   finRequete:{ response, statut in

                    print("VueInvitation.refuseOrAcceptInvitation: statut: \(statut)")
                    
                    if statut == 200 {
                        DispatchQueue.main.async(execute: {
                            self.message(display: msg200, emoji: "☀️", dissmiss: "Ok")
                            print("VueInvitation.refuseOrAcceptInvitation avant delete : \(self.user.getInvitationsRequests())")

                            self.user.deleteInvitationRequest(request: requestedPseudo)
                            
                            self.listeDemands.deleteRows(at: indexPath, with: UITableViewRowAnimation.automatic)
                            self.listeDemands.reloadData()
                        })

                    }else{
                        DispatchQueue.main.async(execute: {
                            self.message(display: "Une erreur s'est produite", emoji: "☔️", dissmiss: "Annuler")
                        })
                        
                    }
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
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



