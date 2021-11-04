//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadAllMessages()
    }
    
    func loadAllMessages() {
        db.collection(K.FStore.collectionName).addSnapshotListener { querySnapshop, error in
            if let e = error {
                print("There was an issue retrieving the data, \(e)")
            }else {
                self.messages = []
                if let snapshotDocuments = querySnapshop?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        print(data)
                        if let messageSender = doc[K.FStore.senderField] as? String,
                            let messageBody = data[K.FStore.bodyField] as? String {
                            self.messages.append(Message(sender: messageSender, body: messageBody))
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            let messageData = [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody
            ]
            
            db.collection(K.FStore.collectionName).addDocument(data: messageData) { error in
                if let e = error {
                    print("There was an error saving the message data, \(e)")
                }            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let e as NSError{
            print(e)
        }
    }
}


//MARK: - UITableViewdataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
}
