import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
     
    private let tableView = {
        let tbl = UITableView()
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tbl
    }()
    private var users = [User]()
    private let presenter = UserPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Users"
        presenter.setViewDelegate(delegate: self)
        presenter.getUsers()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // presenter handles tap
        guard let userName = users[indexPath.row].name else {return}
        guard let userEmail = users[indexPath.row].email else {return}
        presenter.delegate?.presentAlert(title: userName, message: userEmail)
    }
}

extension UserViewController: UserPresenterDelegate {
    func presentUsers(user: [User]) {
        self.users = user
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func presentAlert(title: String, message: String) {
        print(title,message)
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
