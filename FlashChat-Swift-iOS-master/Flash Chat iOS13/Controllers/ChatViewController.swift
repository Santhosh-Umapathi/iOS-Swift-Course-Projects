//
//  ChatViewController.swift
//  Flash Chat iOS13
//

import UIKit
import Firebase

class ChatViewController: UIViewController
{

    let db = Firestore.firestore() //Initializing DB
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = Constants.titleName
        navigationItem.hidesBackButton = true //Hiding back button
        
        //Registering Nib File
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)

        loadMessages()
    }
    
    //Loading messages from DB
    func loadMessages()
    {                                                  //Orderby date                      /Listens for new changes
        db.collection(Constants.FStore.collectionName).order(by: Constants.FStore.dateField).addSnapshotListener
        { (querySnapshot, error) in
            self.messages = [] //Emptying the messages array
            if let e = error
            {
                print(e)
            }
            else
            {
                if let snapshotQuery = querySnapshot?.documents
                {
                    for doc in snapshotQuery
                    {
                        let data = doc.data()
                        if
                        let messageSender = data[Constants.FStore.senderField] as? String,
                        let messageBody = data[Constants.FStore.bodyField] as? String
                        {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async
                            {
                                self.tableView.reloadData()
                                //Setting the latest messages on bottom
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem)
    {
        do
        {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true) //Going to Root VC
        }
        catch let signOutError as NSError
        {
            print("Error signing out: %@", signOutError)
        }
    }
    
    //Saving user and message in DB
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if
        let messageBody = messageTextfield.text, //Grabbing the message from textfield
        let messageSender = Auth.auth().currentUser?.email //Grabbing the logged in user.
        {
            db.collection(Constants.FStore.collectionName).addDocument(data:
                [
                Constants.FStore.senderField:messageSender,
                Constants.FStore.bodyField:messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
                ]){ (error) in
                    if let e = error
                    {
                        print(e)
                    }
                    else
                    {
                        print("Successfully stored data")
                        DispatchQueue.main.async
                            {
                                self.messageTextfield.text = ""
                            }
                    }
                }
        }
    }
    

}
//MARK: - Table DataSource Methods
extension ChatViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messages.count //Returning array count.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell //Using message class for cells
        cell.label.text = message.body //label from message class
        
        //Message from current user. Setting avatar settings.
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        }
        //Message from another user. Setting avatar settings.
        else
        {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        return cell
    }
}

//MARK: - TableView Delegate Methods

extension ChatViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print(indexPath.row)
    }
}

