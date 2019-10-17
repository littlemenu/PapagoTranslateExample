//
//  SelectLanguageVC.swift
//  PapagoTranslateExample
//
//  Created by 정재훈 on 10/10/2019.
//  Copyright © 2019 Jung. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectLanguageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIndetifire: String = "cellLanguage"
    let urlJSONFile: String = "CountryList"
    var countryJOSNList: JSON?
    var senderType: String = ""
    var selectedLanguage: String = ""
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var tableViewLanguage: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        loadJSONFile()
        tableViewLanguage.dataSource = self
        tableViewLanguage.delegate = self
        //  print(countryJOSNList ?? "JSON File is Nil")
        setProperties()
        self.tableViewLanguage.rowHeight = 46
        // self.tableViewLanguage.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func touchUpInsidePopView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countryList: JSON = countryJOSNList else {
            preconditionFailure("Failed Load JSON File")
        }
        
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: LanguageTableViewCell = tableViewLanguage.dequeueReusableCell(withIdentifier: cellIndetifire, for: indexPath) as? LanguageTableViewCell else {
            preconditionFailure("Failed Load Language List")
        }
        
        guard let countryList: JSON = countryJOSNList else {
            preconditionFailure("Failed Load JSON File")
        }
        
        cell.labelLagnuage.text = countryList[indexPath.row]["language_korean"].stringValue
        
        switch senderType {
        case "입력":
            if NowSelectedLanguage.shared.SourceLanguage == cell.labelLagnuage.text {
                cell.labelLagnuage.textColor = .systemGreen
                cell.imageIsChecked.isHidden = false
            }
            
        case "번역":
            if NowSelectedLanguage.shared.TargetLanguage == cell.labelLagnuage.text {
                cell.labelLagnuage.textColor = .systemGreen
                cell.imageIsChecked.isHidden = false
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let countryList: JSON = countryJOSNList else {
            preconditionFailure("Failed Load JSON File")
        }
        
        switch senderType {
        case "입력":
            if NowSelectedLanguage.shared.TargetLanguage == countryList[indexPath.row]["language_korean"].stringValue {
                let tmpName: String = NowSelectedLanguage.shared.SourceLanguage
                NowSelectedLanguage.shared.SourceLanguage = NowSelectedLanguage.shared.TargetLanguage
                NowSelectedLanguage.shared.TargetLanguage = tmpName
                
                let tmpCode: String = NowSelectedLanguage.shared.SourceCountryCode
                NowSelectedLanguage.shared.SourceCountryCode = NowSelectedLanguage.shared.TargetCountryCode
                NowSelectedLanguage.shared.TargetCountryCode = tmpCode
                
                self.dismiss(animated: true, completion: nil)
            } else if NowSelectedLanguage.shared.SourceLanguage == countryList[indexPath.row]["language_korean"].stringValue {
                self.dismiss(animated: true, completion: nil)
            }
            
            
            NowSelectedLanguage.shared.SourceLanguage = countryList[indexPath.row]["language_korean"].stringValue
            NowSelectedLanguage.shared.SourceCountryCode = countryList[indexPath.row]["country_code"].stringValue
            
        case "번역":
            if NowSelectedLanguage.shared.SourceLanguage == countryList[indexPath.row]["language_korean"].stringValue {
                let tmpName: String = NowSelectedLanguage.shared.SourceLanguage
                NowSelectedLanguage.shared.SourceLanguage = NowSelectedLanguage.shared.TargetLanguage
                NowSelectedLanguage.shared.TargetLanguage = tmpName
                
                let tmpCode: String = NowSelectedLanguage.shared.SourceCountryCode
                NowSelectedLanguage.shared.SourceCountryCode = NowSelectedLanguage.shared.TargetCountryCode
                NowSelectedLanguage.shared.TargetCountryCode = tmpCode
                
                self.dismiss(animated: true, completion: nil)
            } else if NowSelectedLanguage.shared.TargetLanguage == countryList[indexPath.row]["language_korean"].stringValue {
                self.dismiss(animated: true, completion: nil)
            }
            
            
            NowSelectedLanguage.shared.TargetLanguage = countryList[indexPath.row]["language_korean"].stringValue
            NowSelectedLanguage.shared.TargetCountryCode = countryList[indexPath.row]["country_code"].stringValue
            
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadJSONFile() {
        
        guard let JSONFile = Bundle.main.url(forResource: "CountryList", withExtension: "json") else {
            print("Error: Failed load JSON File")
            return
        }
        
        do {
            let JSONdata: Data = try Data(contentsOf: JSONFile)
            self.countryJOSNList = try JSON(data: JSONdata)
            
        } catch {
            print("Error: Failed Match JSON File")
            return
        }
    }
    
    func setProperties() {
        
        labelTitle.text = "이 언어로 \(senderType)"
        buttonBack.setTitle("Cancel", for: .init())
        buttonBack.setTitleColor(.lightGray, for: .init())
        
        // able to AutoLayout
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBack.translatesAutoresizingMaskIntoConstraints = false
        self.tableViewLanguage.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label Constraints
        self.labelTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.labelTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // Back button Constraints
        self.buttonBack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.buttonBack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0).isActive = true
        
        // Language tableView Constraints
        self.tableViewLanguage.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 25.0).isActive = true
        self.tableViewLanguage.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableViewLanguage.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableViewLanguage.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
