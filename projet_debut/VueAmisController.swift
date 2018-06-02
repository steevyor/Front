import UIKit

class VueAmisController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listeAmis: UITableView!
    
    //Amis récupérés
    var friendsToDisplay = FriendList()
    var dbResearch = FriendList()
    
    var user: User = User.init()
    
    var research: FriendList = FriendList.init()
    var filteredFriends: FriendList = FriendList.init()
    var searchActive = false
    var dbResearchActive = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsToDisplay.addList(tab: [Friend.init(pseudo: "Alex"),
                              Friend.init(pseudo: "Guillaume"),
                              Friend.init(pseudo: "Henri"),
                              Friend.init(pseudo: "Sonia")]
        )
        
      
        searchBar.showsScopeBar = false
        searchBar.delegate = self
        listeAmis.dataSource = self
        listeAmis.delegate = self
        
    }
    
    //En fonction de l'état de la searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        dbResearchActive = false
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.listeAmis.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        doSearch(searchBar.text!)
    }
    
    
    //On récupère le contenu de la recherche et on filtre les amis
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        filteredFriends.remove()
        dbResearch.remove()
        friendsToDisplay.filter(login: searchText, filteredFriends: &filteredFriends)
        
        if(filteredFriends.getList().count == 0 && searchText.isEmpty ){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.listeAmis.reloadData()
    }
    //par rapport à la mémoire et au nombre de lignes
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredFriends.getList().count
        } else if dbResearchActive {
            print("VueAmisController \(dbResearch.getList().count)")
            return dbResearch.getList().count
        }
        return friendsToDisplay.getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Récupérer le bon élément, en fonction de si la liste est filtrée ou non

        let friend : Friend
        
        if searchActive {
            friend = filteredFriends.getList()[indexPath.row]
        } else if dbResearchActive{
            friend = dbResearch.getList()[indexPath.row]
            print("VueAmisController.cellRowAt \(dbResearch.getList()[indexPath.row])")

        } else {
            friend = friendsToDisplay.getList()[indexPath.row]
        }
        
        // Créer une cellule
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        cell.textLabel?.text = friend.getPseudo()
        
        return cell
    }
    
    func doSearch(_ requestedPseudo: String)
    {// Requete de récupération de liste d'amis
        searchActive = false //Sinon pour le nb de lignes on recupere la taille de filterredFriends
        dbResearchActive = true

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("VueAmisController.research : ")
        
        let parameters = [
            "userPseudo": "\(self.user.getPseudo())",
            "tokenKey": "\(self.user.getToken())",
            "requestedPseudo": "\(requestedPseudo)"
            ] as [String : AnyObject]
        
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/researchFriend")!
        print("VueAmisController.research : URL : \(url)")
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("VueAmisController.research : Statut : \(statut)")
                print("VueAmisController.research : removing FilteredFriends")
                print("VueAmisController.research : reloading listeAmis")
                self.filteredFriends.remove()
                if let tab = response["utilisateurs"] as? [AnyObject] {
                    print("VueAmisController.research :  Récupération des résultat")
                    print("VueAmisController.research : utilisateurs : \(tab)")

                    
                    for i in 0..<tab.count {
                        print("VueAmisController.research : user : \(tab[i])")
                        var f: Friend = Friend.init()
                        f.setPseudo(s: tab[i] as! String )
                        self.dbResearch.addFriend(f: f)
                        
                    }
                    print("VueAmisController.research : results : \(self.dbResearch)")
                } else {
                    print("VueAmisController.research : Aucun résultat ")

                    self.message(display: "Aucun utilisateur ne correspond", emoji: "☔️", dissmiss: "Annuler")

                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                
                DispatchQueue.main.async(execute: {
                    self.listeAmis.reloadData()
                })

        }
        )
        
        
    }
    //Chargée d'afficher les messages renvoyés à l'utilisateur
    func message(display: String, emoji: String, dissmiss: String) -> Void
    {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: dissmiss, style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
    //action sur un ami
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        // Si la recherche est activée et que la recherche ne correspond pas à quelqu'un qui est déjà notre ami
        //if ( searchActive && !(self.friends.contains(login: self.research.list[indexPath.row].getPseudo())) ){
        if (dbResearchActive){
                let ajouterClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
                //TODO: Envoie d'une demande en amie
                self.dbResearch.remove(index: indexPath.row)
                self.listeAmis.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
            }
            
            
            let askFriend = UITableViewRowAction(style: .normal, title: "Ajouter", handler: ajouterClosure)
            askFriend.backgroundColor = UIColor.blue
            
            return [askFriend]
        }else{
            
            let deleteClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
                //TODO: Ajouter l'action de suppression
                self.friendsToDisplay.remove(index: indexPath.row)
                self.listeAmis.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                
            }
            
            let deleteFriend = UITableViewRowAction(style: .default, title: "Supprimer", handler: deleteClosure)
            
            return [deleteFriend]
            
        }
        
    }
    
    
    
    
    
    
    
}
