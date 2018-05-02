import Foundation


class User : Equatable {
    private var pseudo: String
    private let email: String
    private var contacts = [String]()
    private var invitationDemands = [String]()
    private var invitationRequests = [String]()
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = [Double]()
    
    
    init(pseudo: String, email: String, password: String){
        self.pseudo = pseudo
        self.email = email
        self.contacts = []
        self.invitationDemands = []
        self.invitationRequests = []
        self.isVisible = false
        self.isConnected = false
        self.coordinates = []
        
    }
    
    func getPseudo() -> String{
        return self.pseudo
    }
    func getEmail() -> String{
        return self.email
    }
    func getContacts() -> [String]{
        return self.contacts
    }
    func getInvitationDemands() -> [String]{
        return self.invitationDemands
    }
    func getInvitationsRequests() -> [String]{
        return self.invitationRequests
    }
    func getIsConnected() -> Bool{
        return self.isConnected
    }
    func getIsVIsible() -> Bool{
        return self.isVisible
    }
    func getCoordinates() -> [Double]{
        return self.coordinates
    }
    
    
    func setPseudo(s : String){
        self.pseudo = s
    }
    func addContacts(email : String){
        self.contacts.append(email)
    }
    
    func deleteContacts(email : String){
        for index in 0...self.contacts.count{
            if(email == self.contacts[index]){
                self.contacts.remove(at: index)
            }
        }
    }
    func addInvitationDemands(demand : String){
        self.invitationDemands.append(demand)
    }
    
    func deleteInvitationDemands(demand : String){
        for index in 0...self.invitationDemands.count{
            if(demand == self.invitationDemands[index]){
                self.invitationDemands.remove(at: index)
            }
        }
    }
    func addInvitationRequests(request : String){
        self.invitationRequests.append(request)
    }
    
    func deleteInvitationRequests(request : String){
        for index in 0...self.invitationRequests.count{
            if(request == self.invitationRequests[index]){
                self.invitationRequests.remove(at: index)
            }
        }
    }
    func setIsConnected(b : Bool){
        self.isConnected = b
    }
    func setIsVIsible(b : Bool){
        self.isVisible = b
    }
    func addCoordinates(coordinates : Double){
        self.coordinates.append(coordinates)
    }
    
    func deleteCoordinates(coordinates : Double){
        for index in 0...self.coordinates.count{
            if(coordinates == self.coordinates[index]){
                self.coordinates.remove(at: index)
            }
        }
    }
    
    
    static func ==(user1: User, user2: User) -> Bool {
        return user1.pseudo == user2.pseudo && user1.email == user2.email

    }
    
    
    
}

