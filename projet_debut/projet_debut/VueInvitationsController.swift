import UIKit

class VueInvitationsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var listeDemands: UITableView!
    
    //pour l'affichage des amis
    var demands: [String] = [String].init()
    
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
            print("Ami suprimé")
        }
        
        let addClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            //TODO: ajouter l'action d'ajout
            print("Ami ajouté")
        }
        
        let deleteFriend = UITableViewRowAction(style: .normal, title: "Ajouter", handler: deleteClosure)
        let addFriend = UITableViewRowAction(style: .default, title: "Supprimer", handler: addClosure)
        
        return [deleteFriend, addFriend]
        
    }
    
    
    
    
    
    
    
}
