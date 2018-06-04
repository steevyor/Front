

import Foundation
import UIKit
class SuggestionsController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate{
    
    
    @IBOutlet weak var suggestionList: UITableView!
    var user: User = User.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSuggestions()
        
        suggestionList.dataSource = self
        suggestionList.delegate = self
        
        
    }
    
    func tabBarcontroller(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
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
        return self.user.getSuggestions().getList().count
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "testCell")
        
        // Ajouter les infos
        cell.textLabel?.text = self.user.getSuggestions().getList()[indexPath.row].getPseudo()
        //cell.detailTextLabel?.text = element.name
        
        return cell
        
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

    
    
    
    
}
