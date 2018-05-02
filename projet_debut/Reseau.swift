import UIKit
import Alamofire

class Reseau {
    
    

    public var Contacts: [String]
    
    init() {
        self.Contacts = []
    }

    public func getUserContacts(){
        //var contacts : [String]
        //Exemple d'URL ou l'on ira récupérer nos données
        let url = URL(string: "http://localhost:8080/api/test/list")!

        //On effectue une GET Request à l'url correspondante pour récupérer les contacts
        Alamofire.request( url).responseJSON { (responseData) -> Void in
        if((responseData.result.value) != nil) {

        //On récupère la réponse du server au sein d'un fichier JSON
            
        let swiftyJsonVar = responseData.result.value
        
        print("\(swiftyJsonVar ?? 0)")
        
        let tab = ["Sonia","Guillaume","Alex"]
        print("\(tab)")
            
        
        //Sérialisation du JSON en un array

        //self.Contacts = try JSONSerialization
        //print("\(self.Contacts)")
                }
            }
        
        }
}
