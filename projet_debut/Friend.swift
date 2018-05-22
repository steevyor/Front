
import CoreLocation
import Foundation

class Friend : Equatable{
    private var pseudo: String
    private var isConnected: Bool
    private var isVisible: Bool
    private var coordinates = CLLocationCoordinate2D()
    
    
    init(pseudo: String, coord: CLLocationCoordinate2D){
        self.pseudo = pseudo
        self.isVisible = false
        self.isConnected = false
        self.coordinates = coord
        
    }
    init(pseudo: String){
        self.pseudo = pseudo
        self.isVisible = false
        self.isConnected = false
        self.coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
    }
    
    func getPseudo() -> String{
        return self.pseudo
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

    
    
}
