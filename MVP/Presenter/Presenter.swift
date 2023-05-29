import Foundation
import UIKit

protocol UserPresenterDelegate:AnyObject{
    func presentUsers(user: [User])
    func presentAlert(title:String,message:String)
    
}
typealias PresenterDelegate = UserPresenterDelegate & UIViewController
class UserPresenter{
    var delegate:PresenterDelegate?
    
    public func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, respose, error in
            guard let data = data, error == nil else {return}
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(user: users)
            } catch {
                print("Error:",error.localizedDescription)
            }
        }
        task.resume()
    }
    public func setViewDelegate(delegate: PresenterDelegate?) {
        self.delegate = delegate
    }
}
