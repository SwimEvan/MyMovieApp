//
//  ViewController.swift
//  stupidApp
//
//  Created by EVAN MEYER on 1/16/25.
//

import UIKit






class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var numMovies = 0
    var movieBigNames: [String] = []
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMovie()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    func getMovie() {
        
        guard let searchQuery = textFieldOutlet.text, !searchQuery.isEmpty else {
            showErrorAlert(message: "Please enter a word to search for movies.")
            return
        }
        
        let session = URLSession.shared
        let movieURL = URL(string: "http://www.omdbapi.com/?s=\(searchQuery)&apikey=eacfa78e")!
        
        let dataTask = session.dataTask(with: movieURL) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                self.showErrorAlert(message: "There was an error fetching the movies.")
                return
            }
            
            guard let data = data else {
                self.showErrorAlert(message: "No data received.")
                return
            }
            
            do {
                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let movieArray = jsonObj["Search"] as? [[String: Any]] {
                        self.movieBigNames = movieArray.compactMap { movie in
                            return movie["Title"] as? String
                        }
                        self.numMovies = self.movieBigNames.count
                    } else {
                        DispatchQueue.main.async {
                            self.showErrorAlert(message: "No movies found for that search.")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableViewOutlet.reloadData()
                    }
                } else {
                    self.showErrorAlert(message: "Invalid response format.")
                }
            } catch {
                self.showErrorAlert(message: "Error parsing data.")
            }
        }
        
        dataTask.resume()
    }
    
   
    func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numMovies
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skib", for: indexPath)
        cell.textLabel?.text = movieBigNames[indexPath.row]
        return cell
    }
    @IBAction func searchAction(_ sender: UIButton) {
        getMovie()
        
        
        
    }
    
}
