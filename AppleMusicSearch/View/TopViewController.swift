//
//  TopViewController.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit
import StoreKit

import JWT


class TopViewController: UITableViewController {

    let apiClient = APIClient()
    
    var albums: [Resource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
}

extension TopViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text,
            text.count > 0 {
            apiClient.search(term: text) { [unowned self] searchResult in
                DispatchQueue.main.async {
                    self.albums = searchResult?.albums
                    self.tableView.reloadData()
                }
            }
        } else {
            self.albums = nil
            tableView.reloadData()
        }
    }
}

extension TopViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albums = albums else { return 0 }
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = album.attributes?.name
        cell.detailTextLabel?.text = album.attributes?.artistName
        cell.imageView?.image = nil
        
        if let url = album.attributes?.artwork?.imageURL(width: 100, height: 100) {
            apiClient.image(url: url) { image in
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums![indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
        vc.albumID = album.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopViewController {
    
    func prepare() {
        title = "Search"
        tableView.tableFooterView = UIView()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        SKCloudServiceController.requestAuthorization { status in
            guard status == .authorized else { return }
            print("Authorization status is authorized")
        }
//        const jwtToken = jwt.sign({}, privateKey, {
//            algorithm: "ES256",
//            expiresIn: "180d",
//            issuer: "ABCDE12345", //your 10-character Team ID, obtained from your developer account
//            header: {
//                alg: "ES256",
//                kid: "FGHIJ67890" //your MusicKit Key ID
//            }
//        });
        //8788R8265L : team
        //ZZ44B8S3NM : music
        
//        var claimSet = ClaimSet()
//        var headerCliamSet = ClaimSet()
//
//        //var authKey = Data(: "/Users/euijoonjung/Desktop/main/ios/AppleMusicSearch-master/AuthKey_ZZ44B8S3NM.p8")
//        headerCliamSet["alg"] = "ES256"
//        headerCliamSet["kid"] = "ZZ44B8S3NM"
//        claimSet.issuer = "8788R8265L"
//        claimSet["expiresIn"] = "180d"
//        claimSet["header"] = headerCliamSet
//        claimSet["algorithm"] = "ES256"
//
//        let developerToken = JWT.encode(claims: claimSet, algorithm: .hs256(authKey.data(using: .utf8)!))
//
//        print("developerToken : " + developerToken)
        let skcloudSericeController = SKCloudServiceController()
        let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlpaNDRCOFMzTk0ifQ.eyJpYXQiOjE1MzM5ODI0MTMsImV4cCI6MTU0OTUzNDQxMywiaXNzIjoiODc4OFI4MjY1TCJ9.uhoZnZ1vPJ8WXBJZuywHTWs8RfeOenWAodLsWnFbciND8PPStL_9unJRESvvcr6oeFAHhMJfogPxiTiFTb92pw"
        
        
        skcloudSericeController.requestUserToken(forDeveloperToken: developerToken) { (string, error) in
         
            if error != nil {
                print(error)
                
            }else{
                print(string)
            }
        }
    }
}
