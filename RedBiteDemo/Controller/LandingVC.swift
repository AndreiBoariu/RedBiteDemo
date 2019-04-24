//
//  LandingVC.swift
//  RedBiteDemo
//
//  Created by Boariu Andy on 4/24/19.
//  Copyright © 2019 RedBite Inc. All rights reserved.
//

import UIKit
import RxSwift
import Async
import SwiftyJSON

struct Contribuitor {
    var imgUrl      : String?
    var name        = ""
    var commits     = 0
    var profileURL  : String?
    
    init(json: JSON) {
        self.imgUrl     = json["avatar_url"].string
        self.name       = json["login"].stringValue
        self.commits    = json["contributions"].intValue
        self.profileURL = json["url"].string
    }
}

class LandingVC: UITableViewController {
    
    var viewModel: LandingVM = LandingVM(githubAPI: GithubService())
    var disposeBag = DisposeBag()
    
    var arrContribuitors = [Contribuitor]()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRx()
    }

    
    // MARK: - Notification Methods
    
    // MARK: - Public Methods
    
    // MARK: - Custom Methods
    
    private func setupUI() {
        
    }
    
    private func setupRx() {
        getContribuitorsAPI()
    }
    
    private func loadContribuitorsInList(jsonData: JSON) {
        for json in jsonData.arrayValue {
            let contribuitor = Contribuitor(json: json)
            arrContribuitors.append(contribuitor)
        }
        
        arrContribuitors.sort {
            $0.commits > $1.commits
        }
        
        tableView.reloadData()
    }
    
    // MARK: - API Methods
    
    private func getContribuitorsAPI() {
        viewModel.getTopMostContribuitors
            .subscribe(onSuccess: { [weak self] requestState in
                guard let me = self else { return }
                
                switch requestState {
                case .completed(let result):
                    if let jsonData = result.data {
                        Async.main {
                            me.loadContribuitorsInList(jsonData: jsonData)
                        }
                    }
                    
                case .error(let message):
                    let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    me.present(alert, animated: true, completion: nil)
                }
            }) { error in
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Action Methods
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrContribuitors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContribuitorInfoCell.cellID, for: indexPath) as! ContribuitorInfoCell
        cell.loadContribuitorInfo(arrContribuitors[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //=>    Just to hide extra separators
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ContribuitorInfoVC") as! ContribuitorInfoVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

