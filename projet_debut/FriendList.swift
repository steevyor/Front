

import Foundation

class FriendList: CustomStringConvertible{
    var list : [Friend]
    public var description: String {
        var s:String = ""
        for f in list {
            s = "\(s) \n \(f.description)"
        }
        return s
    }

    
    init(){
        self.list = []
    }
    
    init(f: [Friend]){
        self.list = []
        for friend in f {
            self.list.append(friend)
        }
    }
    
    func getList() -> [Friend] {
        return self.list
    }
    
    func contains(login: String) -> Bool{
        for index in 0..<self.list.count {
            if self.list[index].getPseudo() == login {
                return true
            }
        }
        return false
    }
    
    func addList(tab: [Friend]){
        for index in 0..<tab.count {
            
            if !self.contains(login: tab[index].getPseudo()) {
                self.list.append(tab[index])
            }
        }
        
    }
    
    func addFriend(f: Friend){
        if !self.contains(login: f.getPseudo()) {
                self.list.append(f)
            }
    }
    
    func remove(){
        
        self.list.removeAll()
        
    }
    
    func remove(index: Int){
        self.list.remove(at: index)
    }
    
    func remove(pseudo: String){
        for i in 0..<self.list.count{
            if self.list[i].getPseudo() == pseudo{
                self.list.remove(at: i)
                return
            }
        }
    }
    
    func find(pseudo: String) -> Friend{
        for i in 0..<self.list.count{
            if self.list[i].getPseudo() == pseudo{
                return self.list[i]
            }
        }
        return Friend()
    }
    
    
    func filter( login: String, filteredFriends: inout FriendList) {
        var tab: [Friend] = []
        
        for index in 0..<self.list.count{
            if self.list[index].getPseudo().lowercased().contains(login.lowercased()) {
                
                if !filteredFriends.contains(login: login){
                    tab.append(self.list[index])
                }
                
            }
        }
        
        filteredFriends.addList(tab: tab)
    }
    
    


}
