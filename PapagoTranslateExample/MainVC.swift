//
//  MainVC.swift
//  PapagoTranslateExample
//
//  Created by 정재훈 on 10/10/2019.
//  Copyright © 2019 Jung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var buttonSourceLanguage: UIButton!
    @IBOutlet weak var buttonTargetLanguage: UIButton!
    @IBOutlet weak var buttonChangeLanguage: UIButton!
    @IBOutlet weak var textViewSource: UITextView!
    @IBOutlet weak var textViewTranslated: UITextView!
    
    let textViewPlaceholder: String = "번역할 내용을 입력해주세요."
    let urlPapagoSMT: String = "https://openapi.naver.com/v1/language/translate"
    let headersNaverClientKey: HTTPHeaders = [
        "X-Naver-Client-Id": "A9m7cViAArYoJ5ezn4mX",
        "X-Naver-Client-Secret": "o3lIGNMpGu"
    ]
    var queryParameters: [String: String] = [
        "source": "",
        "target": "",
        "text": ""
    ]
    
    var constraintSourceTextViewDefault: NSLayoutConstraint? = nil
    var constraintSourceTextViewTransform: NSLayoutConstraint? = nil
    
    var isChanged: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if buttonSourceLanguage.titleLabel?.text != NowSelectedLanguage.shared.SourceLanguage {
            buttonSourceLanguage.setTitle(NowSelectedLanguage.shared.SourceLanguage, for: .init())
        }
        
        if buttonTargetLanguage.titleLabel?.text != NowSelectedLanguage.shared.TargetLanguage {
            buttonTargetLanguage.setTitle(NowSelectedLanguage.shared.TargetLanguage, for: .init())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setIBOutletFistTime()
        textViewSource.delegate = self
    }
    
    @IBAction func touchUpInsideSelectLanguage(_ sender: UIButton) {
        switch sender {
        case buttonSourceLanguage:
            moveSelectLanguageVC(senderType: "입력")
            
        case buttonTargetLanguage:
            moveSelectLanguageVC(senderType: "번역")
            
        default:
            break
        }
    }
    
    @IBAction func touchUpInsideChangeLanguage(_ sender: UIButton) {
        let tmpName: String = NowSelectedLanguage.shared.SourceLanguage
        NowSelectedLanguage.shared.SourceLanguage = NowSelectedLanguage.shared.TargetLanguage
        NowSelectedLanguage.shared.TargetLanguage = tmpName
        
        let tmpCode: String = NowSelectedLanguage.shared.SourceCountryCode
        NowSelectedLanguage.shared.SourceCountryCode = NowSelectedLanguage.shared.TargetCountryCode
        NowSelectedLanguage.shared.TargetCountryCode = tmpCode
        
        self.buttonSourceLanguage.setTitle(NowSelectedLanguage.shared.SourceLanguage, for: .init())
        self.buttonTargetLanguage.setTitle(NowSelectedLanguage.shared.TargetLanguage, for: .init())
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textView Did Beging Editing")
        
        if textView.text == self.textViewPlaceholder {
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
        textView.textAlignment = .natural
        self.textViewSource.font = UIFont.systemFont(ofSize: 18.0)
        
        self.constraintSourceTextViewDefault?.isActive = false
        self.constraintSourceTextViewTransform?.isActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textView Did Change")
        
        if textView.text == "" {
            textView.text = self.textViewPlaceholder
            textView.textColor = .lightGray
        } else if textView.text != "" {
            textView.textColor = .black
            queryParameters = [
                "source": NowSelectedLanguage.shared.SourceCountryCode,
                "target": NowSelectedLanguage.shared.TargetCountryCode,
                "text": textView.text
            ]
            // requestTranslate()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textView Did End Editing")
        if textView.text == self.textViewPlaceholder || self.textViewSource.text == "" {
            textView.text = self.textViewPlaceholder
            textView.textColor = .lightGray
            textView.textAlignment = .center
            self.textViewSource.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            self.constraintSourceTextViewDefault?.isActive = true
            self.constraintSourceTextViewTransform?.isActive = false
        } else {
            self.textViewSource.font = UIFont.systemFont(ofSize: 18.0)
            queryParameters = [
                "source": NowSelectedLanguage.shared.SourceCountryCode,
                "target": NowSelectedLanguage.shared.TargetCountryCode,
                "text": textView.text
            ]
            requestTranslate()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.endEditing(true)
            // textView.resignFirstResponder()
            return false
        } else if textView.text == self.textViewPlaceholder {
            textView.text = nil
        }
        return true
    }
    
    func moveSelectLanguageVC(senderType: String) {
        guard let selectLanguageVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectLanguage") as? SelectLanguageVC else {
            print("Not Exsit VC")
            return
        }
        
        selectLanguageVC.modalPresentationStyle = .fullScreen
        selectLanguageVC.senderType = senderType
        self.present(selectLanguageVC, animated: true, completion: nil)
    }
    
    func requestTranslate() {
        AF.request(urlPapagoSMT, method: .post, parameters: queryParameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody), headers: headersNaverClientKey).responseJSON{ response in
            
            switch response.result {
            case .success(let value):
                let json: JSON = JSON(value)
                let translatedText: String = json["message"]["result"]["translatedText"].stringValue
                self.textViewTranslated.text = translatedText
                print("translated Text: " + translatedText)
                
            case .failure(let error):
                print(error)
            }
            debugPrint(response)
        }
    }
    
    func setIBOutletFistTime() {
        
        // set buttons title and color
        self.buttonSourceLanguage.setTitle(NowSelectedLanguage.shared.SourceLanguage, for: .init())
        self.buttonSourceLanguage.setTitleColor(.gray, for: .init())
        self.buttonTargetLanguage.setTitle(NowSelectedLanguage.shared.TargetLanguage, for: .init())
        self.buttonTargetLanguage.setTitleColor(.gray, for: .init())
        self.buttonChangeLanguage.setTitle("Change", for: .init())
        self.buttonChangeLanguage.setTitleColor(.black, for: .init())
        
        // set Source textView properties
        self.textViewSource.returnKeyType = .done
        self.textViewSource.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.textViewSource.text = self.textViewPlaceholder
        self.textViewSource.textColor = .lightGray
        self.textViewSource.textAlignment = .center
        self.textViewSource.layer.borderWidth = 0.5
        self.textViewSource.layer.borderColor = UIColor.lightGray.cgColor
        
        // set Translated textView properties
        self.textViewTranslated.isEditable = false
        self.textViewTranslated.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        self.textViewTranslated.text = ""
        self.textViewTranslated.textColor = .black
        self.textViewTranslated.textAlignment = .natural
        self.textViewTranslated.layer.borderWidth = 0.5
        self.textViewTranslated.layer.borderColor = UIColor.lightGray.cgColor
        
        // able to Auto Layout
        self.buttonSourceLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.buttonChangeLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.buttonTargetLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.textViewSource.translatesAutoresizingMaskIntoConstraints = false
        self.textViewTranslated.translatesAutoresizingMaskIntoConstraints = false
        
        // buttons constraints
        // Change Language button
        self.buttonChangeLanguage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.buttonChangeLanguage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        // Source Language button
        self.buttonSourceLanguage.centerXAnchor.constraint(equalTo: self.buttonChangeLanguage.leadingAnchor, constant: -75.0).isActive = true
        self.buttonSourceLanguage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        // Target Language button
        self.buttonTargetLanguage.centerXAnchor.constraint(equalTo: self.buttonChangeLanguage.trailingAnchor, constant: 75.0).isActive = true
        self.buttonTargetLanguage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // Source textView constraints
        self.textViewSource.topAnchor.constraint(equalTo: self.buttonChangeLanguage.bottomAnchor, constant: 10.0).isActive = true
        self.textViewSource.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.textViewSource.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.constraintSourceTextViewDefault = self.textViewSource.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.constraintSourceTextViewTransform = self.textViewSource.bottomAnchor.constraint(equalTo: self.textViewSource.topAnchor, constant: 100.0)
        self.constraintSourceTextViewDefault?.isActive = true
        self.constraintSourceTextViewTransform?.isActive = false
        // Translated textView constraints
        self.textViewTranslated.topAnchor.constraint(equalTo: self.textViewSource.bottomAnchor).isActive = true
        self.textViewTranslated.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.textViewTranslated.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.textViewTranslated.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
