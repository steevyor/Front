import UIKit

class VueInvitationsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var listeDemands: UITableView!
    
    //pour l'affichage des amis
    var demands: [String] = [String].init()
    
    var statut: Int = 0
    
    var user: User = User.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        demands = [ "Alex2", "Guillaume2", "Henri2", "Sonia2"]
        
        listeDemands.dataSource = self
        listeDemands.delegate = self
        
    }
    
    
    
    
    //par rapport à la mémoire et au nombre de lignes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Créer une cellule
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        cell.textLabel?.text = self.demands[indexPath.row]
        //cell.detailTextLabel?.text = element.name
        
        
        return cell
    }
    
    //actions sur une demande
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            //TODO: ajouter l'action de suppression
            //self.delete_or_add_friends(action: true, pseudo: self.demands[indexPath.row], indexPath: indexPath)
            self.demands.remove(at: indexPath.row)
            self.listeDemands.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
            print("Ami suprimé")
        }
        
        let addClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            //TODO: ajouter l'action d'ajout
            //self.delete_or_add_friends(action: false, pseudo: self.demands[indexPath.row], indexPath: indexPath)
            print("Ami ajouté")
            self.demands.remove(at: indexPath.row)
            self.listeDemands.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
        }
        
        
        let deleteFriend = UITableViewRowAction(style: .default, title: "Supprimer", handler: deleteClosure)
        
        let addFriend = UITableViewRowAction(style: .default, title: "Ajouter", handler: addClosure)
        addFriend.backgroundColor = UIColor.green
        return [ addFriend,deleteFriend]
        
    }
    
    func liste_invitation() -> Void
    {
        let parameters = [
            "pseudo": "\(self.user)",
        ]
        
        let url = URL(string: "https://6adff20d.ngrok.io/api/user/friendslist")!
        
        let r = Requests()
        r.post(parameters: parameters as [String : AnyObject], url: url,
               finRequete:{ response, statut in
                
                self.statut = statut!
                
                print("récupèration de la liste des amis ....", response)
                
                if self.statut == 200 {
                    print("Reponse getPositions", response)
                    for (_,value) in response {
                        self.demands.append( value as! String)
                    }
                    
                }else{
                    DispatchQueue.main.async(execute: {
                        self.message(display: "Une erreur s'est produite lors de l'affichage des invitations", emoji: "☔️", dissmiss: "Annuler")
                    })
                    
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        )
        
    }
    
    func delete_or_add_friends(action: Bool, pseudo: String, indexPath: IndexPath!) -> Void
        
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let parameters = [
            "pseudo": "\(self.user)",
        ]
        if action == true
        {
            
            let url = URL(string: "https://6adff20d.ngrok.io/api/user/delete")!
            
            let r = Requests()
            r.post(parameters: parameters as [String : AnyObject], url: url,
                   finRequete:{ response, statut in
                    
                    self.statut = statut!
                    
                    print("suppresion d'un ami ....", response)
                    
                    if self.statut == 200 {
                        self.demands.remove(at: indexPath.row)
                        self.listeDemands.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                        self.message(display: "\(self.demands[indexPath.row]) supprimé 👌🏾", emoji: "☔️", dissmiss: "Annuler")
                    }else{
                        DispatchQueue.main.async(execute: {
                            self.message(display: "Une erreur s'est produite lors de la suppresion de l'ami", emoji: "☔️", dissmiss: "Annuler")
                        })
                        
                    }
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            )
        }
        else
        {
            let url = URL(string: "https://6adff20d.ngrok.io/api/user/add")!
            
            let r = Requests()
            r.post(parameters: parameters as [String : AnyObject], url: url,
                   finRequete:{ response, statut in
                    
                    self.statut = statut!
                    
                    print("ajout d'un ami ....", response)
                    
                    if self.statut == 200 {
                        self.demands.remove(at: indexPath.row)
                        self.listeDemands.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                        self.message(display: "\(self.demands[indexPath.row]) ajouté 👌🏾", emoji: "☔️", dissmiss: "Annuler")
                    }else{
                        DispatchQueue.main.async(execute: {
                            self.message(display: "Une erreur s'est produite lors de l'ajout de l'ami", emoji: "☔️", dissmiss: "Annuler")
                        })
                        
                    }
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            )
        }
        
        
        
    }
    
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
}



