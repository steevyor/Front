import CoreLocation
import Foundation


class User : Equatable {
    private var pseudo: String
    private var email: String
    private var token:String
    private var contacts = FriendList()
    private var invitationRequests = FriendList()
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = CLLocationCoordinate2D()
    
    
    init(pseudo: String, email: String, token: String){
        self.pseudo = pseudo
        self.email = email
        self.token = ""
        self.contacts = FriendList.init()
        self.invitationRequests = FriendList.init()
        self.isVisible = true
        self.isConnected = true
        self.coordinates = CLLocationCoordinate2D.init()
        
    }
    
    init(){
        self.pseudo = ""
        self.email = ""
        self.token = ""
        self.contacts = FriendList.init()
        self.invitationRequests = FriendList.init()
        self.isVisible = true
        self.isConnected = true
        self.coordinates = CLLocationCoordinate2D.init()
        
    }
    init(u: User){
        self.pseudo = u.getPseudo()
        self.email = u.getEmail()
        self.token = u.getToken()
        self.contacts = FriendList.init(f: u.getContacts().getList())
        self.invitationRequests = FriendList.init(f: u.getInvitationsRequests().getList())
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
    func getInvitationsRequests() -> FriendList{
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
    
    func deleteAllContacts(){
        self.contacts.remove()
    }
    
    func deleteContact(pseudo : String){
        self.contacts.remove(pseudo: pseudo)
    }
    
    func deleteContact(index : Int){
        self.contacts.remove(index: index)
    }
    
    func addInvitationRequests(request : Friend){
        self.invitationRequests.addFriend(f: request)
    }
    
    func addInvitationRequest(requests : [Friend]){
    self.invitationRequests.addList(tab: requests)
    }
    
    func deleteInvitationRequest(request : String){
        self.invitationRequests.remove(pseudo: request)
    }
    
    func deleteInvitationRequest(index : Int){
        self.invitationRequests.remove(index: index)
    }
    
    func deleteAllInvitationRequest(){
        self.invitationRequests.remove()
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

    func addContacts(f : FriendList){
        for friend in f.getList(){
            
            self.contacts.addFriend(f: friend)

        }
    }
    
    
}

