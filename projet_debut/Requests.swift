import Foundation
import MapKit

let ngrok = "090ad80d"

class Requests {
    
    func post(parameters: [String: AnyObject], url: URL, finRequete: @escaping (_ response: [String: AnyObject], _ httpCode: Int?) -> Void) {
        print("Request.post : ")
        var requestResults :[String: AnyObject] = [String: AnyObject].init()
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print("Request.post : Envoi JSON ok")
        } catch let error {
            print("Request.post : Envoi JSON pas ok")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print("Request.post : Apres envoi JSON error")

                return
            }
            guard let data = data else {
                print("Request.post : Apres envoi JSON data")

                return
            }
            var httpCode = (response as? HTTPURLResponse)?.statusCode
            do {
                print("Request.post : Récupération JSON ok")
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]{
                
                    finRequete(json, httpCode)
                }
                else {
                    finRequete([String: AnyObject](), httpCode)

                }
            } catch let error {
                print("Request.post : Récupération JSON pas ok")
                finRequete([String: AnyObject](), httpCode)

            }
        }
        )
        task.resume()
        
        
        
    }
    
    func connexion(login: String, password: String, messages: @escaping (_ user: User,_ message: String) -> Void){
        
        var user = User()
        let parameters = [
            "pseudo": "\(login)",
            "password": "\(password)"
        ]
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/auth")!
        print("Request.connexion : URL : \(url)")
        
        let r = Requests()
        r.post(parameters: parameters as [String : AnyObject], url: url,
               finRequete:{ response, statut in
                print("Request.connexion : statut = \(statut)")
                
                if let tab: [String:AnyObject] = response["token"] as? [String: AnyObject] {
                    print("Request.connexion : Récupération du json")
                    print("Request.connexion : Pseudo: \(tab["pseudo"])")
                    print("Request.connexion : Token: \(tab["token"])")
                    user.setPseudo(s: tab["pseudo"] as! String)
                    user.setToken(s: tab["key"] as! String)
                }

                if statut == 200 {
                    
                    self.getFriendPositions(pseudo: user.getPseudo(), token: user.getToken(), chargementAmis:{ friends in
                    user.addContacts(f: friends)
                    messages(user, "")
                    })
                } else if statut == 401 {
                    messages(user, "Mot de passe ou pseudo incorrect")
                    
                } else {
                    messages(user, "Une erreur s'est produite")
                    
                }
        }
        )
    }
    
    
    func getFriendPositions(pseudo: String, token: String, chargementAmis: @escaping (_ friends: FriendList) -> Void)
    {
        var friends = FriendList()
        let parameters = [
            "pseudo": "\(pseudo)",
            "tokenKey": "\(token)"
            ] as [String : AnyObject]
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/friends")!
        print("LoginController.getFriendsPosition : URL : \(url)")
        
        
        
        let r = Requests()
        r.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("LoginController.getFriendsPosition : statut = \(statut)")
                
                if let tab = response["friends"] as? [AnyObject] {
                    print("LoginController.getFriendsPosition : Récupération du json")
                    for i in 0..<tab.count {
                        var f: Friend = Friend.init()
                        if let amis = tab[i] as? [String: AnyObject] {
                            print("amis ok", amis)
                            f.setPseudo(s: amis["pseudo"] as! String )
                            if let coord = amis["coordinate"] as? [String: AnyObject] {
                                f.setCoordinates(latitude: coord["xCoordinate"] as! Double, longitude: coord["yCoordinate"] as! Double)
                            }
                            
                            if let image = amis["image"] as? String {
                                f.setImage(s: image)
                            }
                            friends.addFriend(f: f)
                        }
                    }
                    chargementAmis(friends)
                } else {
                    chargementAmis(FriendList())
                }
                })
    }
    
    
    
    
    //envoyer notre position au server
    func updatePosition(user: User, del: MappAppDelegate)
    {
        if user.getIsVIsible() == true {
            print("MapViewController.updatePosition : Coordinates : \(del.locations.latitude) , \(del.locations.longitude)")
            
            let parameters = [
                "pseudo": "\(user.getPseudo())",
                "tokenKey": "\(user.getToken())",
                "xCoordinates": "\(del.locations.longitude)",
                "yCoordinates": "\(del.locations.latitude)"
                ] as [String : AnyObject]
            
            let url = URL(string: "https://\(ngrok).ngrok.io/api/user/updateUserCoordinates")!
            print("MapViewController.updatePosition : URL : \(url)")
            
            
            let r = Requests()
            r.post(parameters: parameters, url: url,
                   finRequete:{ response, statut in
                    print("MapViewController.updatePosition : Statut : \(statut) ")
                    
            }
            )
        }
    }
    
    func refreshPosition(user: User){
        
            print("MapViewController.updatePosition : Coordinates : \(user.getCoordinates().latitude) , \(user.getCoordinates().longitude)")
            let parameters = [
                "pseudo": "\(user.getPseudo())",
                "tokenKey": "\(user.getToken())",
                "xCoordinates": "\(user.getCoordinates().latitude)",
                "yCoordinates": "\(user.getCoordinates().longitude)"
                ] as [String : AnyObject]
            
            let url = URL(string: "https://\(ngrok).ngrok.io/api/user/updateUserCoordinates")!
            print("MapViewController.updatePosition : URL : \(url)")
            
            
            let r = Requests()
            r.post(parameters: parameters, url: url,
                   finRequete:{ response, statut in })
            
        
        
    }
    
    
    func logOut(user: User, timer: Timer, timer2: Timer){
        
        print("MapViewController.disconnect : ")
        
        let parameters = [
            "userPseudo": "\(user.getPseudo())",
            "tokenKey": "\(user.getToken())"
            ] as [String : AnyObject]
        
        let url = URL(string: "https://\(ngrok).ngrok.io/api/user/disconnect")!
        print("MapViewController.disconnect : URL : \(url)")
        
        
        self.post(parameters: parameters, url: url,
               finRequete:{ response, statut in
                print("MapViewController.disconnect : Statut : \(statut)")
                    //on remove le pseudo et token enregistré
                    let disconect = UserDefaults.standard
                    disconect.removeObject(forKey: "taken")
                    disconect.removeObject(forKey: "Bruce")
                    disconect.synchronize()
                    timer.invalidate()
                    timer2.invalidate()
        })
        
        
    }
    
    
}
