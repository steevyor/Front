

import Foundation

class Friend : Equatable{
    private var pseudo: String
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = [Double]()
    
    
    init(pseudo: String){
        self.pseudo = pseudo
        self.isVisible = false
        self.isConnected = false
        self.coordinates = []
        
    }
    
    func getPseudo() -> String{
        return self.pseudo
    }
    
    static func ==(user1: Friend, user2: Friend) -> Bool {
        return user1.pseudo == user2.pseudo 
        
    }
    
    
}
