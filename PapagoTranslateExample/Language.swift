//
//  Language.swift
//  PapagoTranslateExample
//
//  Created by 정재훈 on 11/10/2019.
//  Copyright © 2019 Jung. All rights reserved.
//

import Foundation


class NowSelectedLanguage {
    
    static let shared: NowSelectedLanguage = NowSelectedLanguage()
    
    var SourceLanguage: String = "한국어"
    var SourceCountryCode: String = "ko"
    var TargetLanguage: String = "영어"
    var TargetCountryCode: String = "en"
}
