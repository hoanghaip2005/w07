//
//  ContactListViewController.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit
import SVProgressHUD

class ContactListViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var photos: [Photo] = []
    var currentPage = 1
    var isLoading = false
    var currentQuery: String? = nil
    
    // Dictionary lưu random height cho mỗi photo id
    var randomHeights: [Int: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wallpapers"
        
        // Setup refresh control (pull to refresh)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        
        // Load initial photos
        loadPhotos()
    }
    
    // MARK: - Data Loading
    
    func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        // Show loading HUD
        SVProgressHUD.show(withStatus: "Loading...")
        
        PhotoService.fetchPhotos(page: currentPage, query: currentQuery) { [weak self] photos, error in
            guard let self = self else { return }
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                SVProgressHUD.dismiss()
                
                if let error = error {
                    print("Error loading photos: \(error.localizedDescription)")
                    return
                }
                
                if let photos = photos {
                    // Assign random heights
                    for photo in photos {
                        if self.randomHeights[photo.id] == nil {
                            self.randomHeights[photo.id] = CGFloat.random(in: 150...350)
                        }
                    }
                    
                    // New images go to top of the list
                    self.photos.insert(contentsOf: photos, at: 0)
                    self.currentPage += 1
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func refreshPhotos() {
        // Pull to refresh: load next page, new images on top
        loadPhotos()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        // Reset and search
        photos.removeAll()
        randomHeights.removeAll()
        currentPage = 1
        currentQuery = query
        loadPhotos()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        // Reset to general photos
        photos.removeAll()
        randomHeights.removeAll()
        currentPage = 1
        currentQuery = nil
        loadPhotos()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallpaperCell", for: indexPath) as! WallpaperCell
        let photo = photos[indexPath.row]
        cell.configure(with: photo)
        
        // Use stored random height
        if let height = randomHeights[photo.id] {
            cell.imageHeightConstraint.constant = height
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        return randomHeights[photo.id] ?? 250
    }
    
    // MARK: - Scroll to load more (pull down)
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Load more when near bottom
        if offsetY > contentHeight - height - 200 {
            loadPhotos()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let destination = segue.destination as? ContactDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedPhoto = photos[indexPath.row]
        }
    }
}
