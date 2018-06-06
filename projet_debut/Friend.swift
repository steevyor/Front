
import CoreLocation
import Foundation

class Friend : Equatable, CustomStringConvertible {
    private var pseudo: String
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = CLLocationCoordinate2D()
    private var image: String
    public var description: String { return "Pseudo : \(self.pseudo), Coordinates : \(self.coordinates), Image : \(self.image)" }
    
    
    init(){
        self.pseudo = ""
        self.isVisible = false
        self.isConnected = false
        self.coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.image = ""

        
    }
    
    init(pseudo: String, coord: CLLocationCoordinate2D){
        self.pseudo = pseudo
        self.isVisible = false
        self.isConnected = false
        self.coordinates = coord
        self.image = ""

        
    }
    init(pseudo: String){
        self.pseudo = pseudo
        self.isVisible = false
        self.isConnected = false
        self.coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.image = ""

        
    }
    init(f: Friend){
        self.pseudo = f.getPseudo()
        self.isVisible = false
        self.isConnected = false
        self.coordinates = f.getCoordinates()
        self.image = f.image

        
    }
    
    func getPseudo() -> String{
        return self.pseudo
    }
    
    func getImage() -> String{
        return self.image
    }
    
    func getCoordinates() -> CLLocationCoordinate2D{
        return self.coordinates
    }
    func setCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees ){
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    static func ==(user1: Friend, user2: Friend) -> Bool {
        return user1.pseudo == user2.pseudo 
        
    }
    
    func setPseudo(s: String) {
        self.pseudo = s
    }
    
    func setImage(s: String) {
        self.image = s
    }
    

    
    
}
