//
//  GroupDispatchViewController.swift
//  CallbacksThreading
//
//  Created by Henry Chukwu on 6/27/18.
//  Copyright © 2018 Henry Chukwu. All rights reserved.
//

import UIKit

class GroupDispatchViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!

    let groupA = ["user 1", "user 2"]
    let groupB = ["user 3", "user 4"]
    let groupC = ["user 5", "user 6"]

    var users = [String]()

    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func run(after seconds: Int, completion: @escaping () -> ()) {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }

    func getGroupA() {
        dispatchGroup.enter()
        run(after: 2) {
            print("got A")
            self.users.append(contentsOf: self.groupA)
            self.dispatchGroup.leave()
        }
    }

    func getGroupB() {
        dispatchGroup.enter()
        run(after: 4) {
            print("got B")
            self.users.append(contentsOf: self.groupB)
            self.dispatchGroup.leave()
        }
    }

    func getGroupC() {
        dispatchGroup.enter()
        run(after: 6) {
            print("got C")
            self.users.append(contentsOf: self.groupC)
            self.dispatchGroup.leave()
        }
    }

    func displayUsers() {
        print("reloading data")
        tableview.reloadData()
    }

    @IBAction func onDownloadTapped(_ sender: Any) {
        print("downloading")
        getGroupA()
        getGroupB()
        getGroupC()
        dispatchGroup.notify(queue: .main) {
            self.displayUsers()
        }
    }
    
}

extension GroupDispatchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = users[indexPath.row]
        return cell
    }
}

