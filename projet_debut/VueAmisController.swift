import UIKit

class VueAmisController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listeAmis: UITableView!
    
    //Pour récupérer les amis à afficher dans la liste
    var friendSegue: [Friend] = [Friend].init()
    var friends: FriendList = FriendList.init()
    
    
    var user: User = User.init()
    var filteredFriends: FriendList = FriendList.init()
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Afficher les amis récupérés
        friends.addList(tab: friendSegue)
        friends.addList(tab: [Friend.init(pseudo: "Alex"),
                     Friend.init(pseudo: "Guillaume"),
                     Friend.init(pseudo: "Henri"),
                     Friend.init(pseudo: "Sonia")]
    )
        
        
        //print(friends)
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
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if(searchBar.text!.isEmpty)
        {
            return
        }
        
        //doSearch(searchBar.text!)
    }


    //On récupère le contenu de la recherche et on filtre les amis
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
    
        filteredFriends.remove()
        friends.filter(login: searchText, filteredFriends: &filteredFriends)
        
        if(filteredFriends.getList().count == 0 && searchText.isEmpty){
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
        }
        return friends.getList().count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Récupérer le bon élément, en fonction de si la liste est filtrée ou non
        let friend : Friend
        if searchActive {
            friend = filteredFriends.getList()[indexPath.row]
        } else {
            friend = friends.getList()[indexPath.row]
        }
        
        // Créer une cellule
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        cell.textLabel?.text = friend.getPseudo()
        
        
        return cell
    }
    
    func doSearch(_ searchWord: String)
    {
        searchBar.resignFirstResponder()
        
        let myUrl = URL(string: "https://6adff20d.ngrok.io/api/user/friends")
        
        let session = URLSession.shared
        
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        
        let postString = "searchWord=\(searchWord)&userId=23";
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            DispatchQueue.main.async {
                
                if error != nil
                {
                    // display an alert message
                    self.mmessage(display: error!.localizedDescription, emoji: "☔️")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    self.filteredFriends.remove()
                    self.listeAmis.reloadData()
                    
                    if let parseJSON = json {
                        
                        if let friends  = parseJSON["friends"] as? [AnyObject]
                        {
                            for friendObj in friends
                            {
                                let name = (friendObj["pseudo"] as! String)
                                
                                self.filteredFriends.addFriend(f: Friend.init(pseudo: name))
                            }
                            
                            self.listeAmis.reloadData()
                            
                        } else if(parseJSON["message"] != nil)
                        {
                            
                            let errorMessage = parseJSON["message"] as? String
                            if(errorMessage != nil)
                            {
                                // display an alert message
                                self.mmessage(display: errorMessage!, emoji: "☔️")
                            }
                        }
                    }
                    
                } catch {
                    print(error);
                }
                
            }
            
            
        })
        
        
        task.resume()
        
    }
    
    func mmessage(display: String, emoji: String) -> Void {
        let monAlerte = UIAlertController(title: emoji, message:display, preferredStyle: UIAlertControllerStyle.alert)
        monAlerte.addAction(UIAlertAction(title: "Annuler", style: UIAlertActionStyle.default,handler: nil))
        self.present(monAlerte, animated: true, completion: nil)
        
    }
    
    //action sur un ami
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            //TODO: Ajouter l'action de suppression
            print("Ami supprimé")
        }
        
        let deleteFriend = UITableViewRowAction(style: .default, title: "Supprimer", handler: deleteClosure)
        
        return [deleteFriend]
        
    }
    
    
    

}
