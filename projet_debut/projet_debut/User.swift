import CoreLocation
import Foundation


class User : Equatable {
    private var pseudo: String
    private var email: String
    private var token:String
    private var contacts = FriendList()
    private var invitationDemands = [String]()
    private var invitationRequests = [String]()
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = CLLocationCoordinate2D()
    
    
    init(pseudo: String, email: String, token: String){
        self.pseudo = pseudo
        self.email = email
        self.token = ""
        self.contacts = FriendList.init()
        self.invitationDemands = []
        self.invitationRequests = []
        self.isVisible = true
        self.isConnected = true
        self.coordinates = CLLocationCoordinate2D.init()
        
    }
    
    init(){
        self.pseudo = ""
        self.email = ""
        self.token = ""
        self.contacts = FriendList.init()
        self.invitationDemands = []
        self.invitationRequests = []
        self.isVisible = true
        self.isConnected = true
        self.coordinates = CLLocationCoordinate2D.init()
        
    }
    init(u: User){
        self.pseudo = u.getPseudo()
        self.email = u.getEmail()
        self.token = u.getToken()
        self.contacts = u.getContacts()
        self.invitationDemands = u.getInvitationDemands()
        self.invitationRequests = u.getInvitationsRequests()
        self.isVisible = u.getIsVIsible()
        self.isConnected = u.getIsConnected()
        self.coordinates = u.getCoordinates()
        
    }
    
    func getPseudo() -> String{
        return self.pseudo
    }
    func getEmail() -> String{
        return self.email
    }
    func getToken() -> String{
        return self.token
    }
    func getContacts() -> FriendList{
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
    func getCoordinates() -> CLLocationCoordinate2D{
        return self.coordinates
    }
    func addContact(f : Friend){
        self.contacts.addFriend(f: f)
    }
    
    func deleteContact(f : Friend){
        for index in 0...self.contacts.getList().count{
            if f == self.contacts.getList()[index]  {
                self.contacts.remove(index: index)
            }
            return
        }
    }
    
    func addInvitationDemand(demand : String){
        self.invitationDemands.append(demand)
    }
    
    func deleteInvitationDemand(demand : String){
        for index in 0...self.invitationDemands.count{
            if(demand == self.invitationDemands[index]){
                self.invitationDemands.remove(at: index)
            }
            return
        }
    }
    func addInvitationRequest(request : String){
        self.invitationRequests.append(request)
    }
    
    func deleteInvitationRequest(request : String){
        for index in 0...self.invitationRequests.count{
            if(request == self.invitationRequests[index]){
                self.invitationRequests.remove(at: index)
            }
            return
        }
    }
    func setPseudo(s: String){
        self.pseudo = s
    }
    func setEmail(s: String){
        self.email = s
    }
    func setToken(s: String){
        self.token = s
    }
    func setIsConnected(b : Bool){
        self.isConnected = b
    }
    func setIsVIsible(b : Bool){
        self.isVisible = b
    }
    func setCoord(c: CLLocationCoordinate2D){
        self.coordinates = c
    }
    
    static func ==(user1: User, user2: User) -> Bool {
        return user1.pseudo == user2.pseudo && user1.email == user2.email

    }
    
    
    
}

