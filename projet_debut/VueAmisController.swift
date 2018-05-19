import UIKit

class VueAmisController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listeAmis: UITableView!
    
    //Pour récupérer les amis à afficher dans la liste
    var friendSegue: [Friend] = [Friend].init()
    var friends: FriendList = FriendList.init()
    
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

        listeAmis.dataSource = self
        listeAmis.delegate = self
        searchBar.delegate = self
        
    }
    
        //En fonction de l'état de la searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    //On récupère le contenu de la recherche et on filtre les amis
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
    
        filteredFriends.remove()
        
        friends.filter(login: searchText, filteredFriends: &filteredFriends)
        
        if(filteredFriends.getList().count == 0){
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
        //cell.detailTextLabel?.text = element.name
        
        return cell
    }

    

    
    
    

}
