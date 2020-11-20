//
//  Storefronts.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

class StorefrontDeterminator {
    
    struct StorefrontDetails {
        let identifier: Int
        let countryName: String
        let countryCode: String
    }
    
    static var storefronts: [StorefrontDetails] = [
        StorefrontDetails(identifier: 143563, countryName: "Algeria", countryCode: "DZ"),
        StorefrontDetails(identifier: 143564, countryName: "Angola", countryCode: "AO"),
        StorefrontDetails(identifier: 143538, countryName: "Anguilla", countryCode: "AI"),
        StorefrontDetails(identifier: 143540, countryName: "Antigua & Barbuda", countryCode: "AG"),
        StorefrontDetails(identifier: 143505, countryName: "Argentina", countryCode: "AR"),
        StorefrontDetails(identifier: 143524, countryName: "Armenia", countryCode: "AM"),
        StorefrontDetails(identifier: 143460, countryName: "Australia", countryCode: "AU"),
        StorefrontDetails(identifier: 143445, countryName: "Austria", countryCode: "AT"),
        StorefrontDetails(identifier: 143568, countryName: "Azerbaijan", countryCode: "AZ"),
        StorefrontDetails(identifier: 143559, countryName: "Bahrain", countryCode: "BH"),
        StorefrontDetails(identifier: 143490, countryName: "Bangladesh", countryCode: "BD"),
        StorefrontDetails(identifier: 143541, countryName: "Barbados", countryCode: "BB"),
        StorefrontDetails(identifier: 143565, countryName: "Belarus", countryCode: "BY"),
        StorefrontDetails(identifier: 143446, countryName: "Belgium", countryCode: "BE"),
        StorefrontDetails(identifier: 143555, countryName: "Belize", countryCode: "BZ"),
        StorefrontDetails(identifier: 143542, countryName: "Bermuda", countryCode: "BM"),
        StorefrontDetails(identifier: 143556, countryName: "Bolivia", countryCode: "BO"),
        StorefrontDetails(identifier: 143525, countryName: "Botswana", countryCode: "BW"),
        StorefrontDetails(identifier: 143503, countryName: "Brazil", countryCode: "BR"),
        StorefrontDetails(identifier: 143543, countryName: "British Virgin Islands", countryCode: "VG"),
        StorefrontDetails(identifier: 143560, countryName: "Brunei", countryCode: "BN"),
        StorefrontDetails(identifier: 143526, countryName: "Bulgaria", countryCode: "BG"),
        StorefrontDetails(identifier: 143455, countryName: "Canada", countryCode: "CA"),
        StorefrontDetails(identifier: 143544, countryName: "Cayman Islands", countryCode: "KY"),
        StorefrontDetails(identifier: 143483, countryName: "Chile", countryCode: "CL"),
        StorefrontDetails(identifier: 143465, countryName: "China", countryCode: "CN"),
        StorefrontDetails(identifier: 143501, countryName: "Colombia", countryCode: "CO"),
        StorefrontDetails(identifier: 143495, countryName: "Costa Rica", countryCode: "CR"),
        StorefrontDetails(identifier: 143527, countryName: "Cote D'Ivoire", countryCode: "CI"),
        StorefrontDetails(identifier: 143494, countryName: "Croatia", countryCode: "HR"),
        StorefrontDetails(identifier: 143557, countryName: "Cyprus", countryCode: "CY"),
        StorefrontDetails(identifier: 143489, countryName: "Czech Republic", countryCode: "CZ"),
        StorefrontDetails(identifier: 143458, countryName: "Denmark", countryCode: "DK"),
        StorefrontDetails(identifier: 143545, countryName: "Dominica", countryCode: "DM"),
        StorefrontDetails(identifier: 143508, countryName: "Dominican Rep.", countryCode: "DO"),
        StorefrontDetails(identifier: 143509, countryName: "Ecuador", countryCode: "EC"),
        StorefrontDetails(identifier: 143516, countryName: "Egypt", countryCode: "EG"),
        StorefrontDetails(identifier: 143506, countryName: "El Salvador", countryCode: "SV"),
        StorefrontDetails(identifier: 143518, countryName: "Estonia", countryCode: "EE"),
        StorefrontDetails(identifier: 143447, countryName: "Finland", countryCode: "FI"),
        StorefrontDetails(identifier: 143442, countryName: "France", countryCode: "FR"),
        StorefrontDetails(identifier: 143443, countryName: "Germany", countryCode: "DE"),
        StorefrontDetails(identifier: 143573, countryName: "Ghana", countryCode: "GH"),
        StorefrontDetails(identifier: 143448, countryName: "Greece", countryCode: "GR"),
        StorefrontDetails(identifier: 143546, countryName: "Grenada", countryCode: "GD"),
        StorefrontDetails(identifier: 143504, countryName: "Guatemala", countryCode: "GT"),
        StorefrontDetails(identifier: 143553, countryName: "Guyana", countryCode: "GY"),
        StorefrontDetails(identifier: 143510, countryName: "Honduras", countryCode: "HN"),
        StorefrontDetails(identifier: 143463, countryName: "Hong Kong", countryCode: "HK"),
        StorefrontDetails(identifier: 143482, countryName: "Hungary", countryCode: "HU"),
        StorefrontDetails(identifier: 143558, countryName: "Iceland", countryCode: "IS"),
        StorefrontDetails(identifier: 143467, countryName: "India", countryCode: "IN"),
        StorefrontDetails(identifier: 143476, countryName: "Indonesia", countryCode: "ID"),
        StorefrontDetails(identifier: 143449, countryName: "Ireland", countryCode: "IE"),
        StorefrontDetails(identifier: 143491, countryName: "Israel", countryCode: "IL"),
        StorefrontDetails(identifier: 143450, countryName: "Italy", countryCode: "IT"),
        StorefrontDetails(identifier: 143511, countryName: "Jamaica", countryCode: "JM"),
        StorefrontDetails(identifier: 143462, countryName: "Japan", countryCode: "JP"),
        StorefrontDetails(identifier: 143528, countryName: "Jordan", countryCode: "JO"),
        StorefrontDetails(identifier: 143517, countryName: "Kazakstan", countryCode: "KZ"),
        StorefrontDetails(identifier: 143529, countryName: "Kenya", countryCode: "KE"),
        StorefrontDetails(identifier: 143466, countryName: "Korea, Republic Of", countryCode: "KR"),
        StorefrontDetails(identifier: 143493, countryName: "Kuwait", countryCode: "KW"),
        StorefrontDetails(identifier: 143519, countryName: "Latvia", countryCode: "LV"),
        StorefrontDetails(identifier: 143497, countryName: "Lebanon", countryCode: "LB"),
        StorefrontDetails(identifier: 143522, countryName: "Liechtenstein", countryCode: "LI"),
        StorefrontDetails(identifier: 143520, countryName: "Lithuania", countryCode: "LT"),
        StorefrontDetails(identifier: 143451, countryName: "Luxembourg", countryCode: "LU"),
        StorefrontDetails(identifier: 143515, countryName: "Macau", countryCode: "MO"),
        StorefrontDetails(identifier: 143530, countryName: "Macedonia", countryCode: "MK"),
        StorefrontDetails(identifier: 143531, countryName: "Madagascar", countryCode: "MG"),
        StorefrontDetails(identifier: 143473, countryName: "Malaysia", countryCode: "MY"),
        StorefrontDetails(identifier: 143488, countryName: "Maldives", countryCode: "MV"),
        StorefrontDetails(identifier: 143532, countryName: "Mali", countryCode: "ML"),
        StorefrontDetails(identifier: 143521, countryName: "Malta", countryCode: "MT"),
        StorefrontDetails(identifier: 143533, countryName: "Mauritius", countryCode: "MU"),
        StorefrontDetails(identifier: 143468, countryName: "Mexico", countryCode: "MX"),
        StorefrontDetails(identifier: 143523, countryName: "Moldova, Republic Of", countryCode: "MD"),
        StorefrontDetails(identifier: 143547, countryName: "Montserrat", countryCode: "MS"),
        StorefrontDetails(identifier: 143484, countryName: "Nepal", countryCode: "NP"),
        StorefrontDetails(identifier: 143452, countryName: "Netherlands", countryCode: "NL"),
        StorefrontDetails(identifier: 143461, countryName: "New Zealand", countryCode: "NZ"),
        StorefrontDetails(identifier: 143512, countryName: "Nicaragua", countryCode: "NI"),
        StorefrontDetails(identifier: 143534, countryName: "Niger", countryCode: "NE"),
        StorefrontDetails(identifier: 143561, countryName: "Nigeria", countryCode: "NG"),
        StorefrontDetails(identifier: 143457, countryName: "Norway", countryCode: "NO"),
        StorefrontDetails(identifier: 143562, countryName: "Oman", countryCode: "OM"),
        StorefrontDetails(identifier: 143477, countryName: "Pakistan", countryCode: "PK"),
        StorefrontDetails(identifier: 143485, countryName: "Panama", countryCode: "PA"),
        StorefrontDetails(identifier: 143513, countryName: "Paraguay", countryCode: "PY"),
        StorefrontDetails(identifier: 143507, countryName: "Peru", countryCode: "PE"),
        StorefrontDetails(identifier: 143474, countryName: "Philippines", countryCode: "PH"),
        StorefrontDetails(identifier: 143478, countryName: "Poland", countryCode: "PL"),
        StorefrontDetails(identifier: 143453, countryName: "Portugal", countryCode: "PT"),
        StorefrontDetails(identifier: 143498, countryName: "Qatar", countryCode: "QA"),
        StorefrontDetails(identifier: 143487, countryName: "Romania", countryCode: "RO"),
        StorefrontDetails(identifier: 143469, countryName: "Russia", countryCode: "RU"),
        StorefrontDetails(identifier: 143479, countryName: "Saudi Arabia", countryCode: "SA"),
        StorefrontDetails(identifier: 143535, countryName: "Senegal", countryCode: "SN"),
        StorefrontDetails(identifier: 143500, countryName: "Serbia", countryCode: "RS"),
        StorefrontDetails(identifier: 143464, countryName: "Singapore", countryCode: "SG"),
        StorefrontDetails(identifier: 143496, countryName: "Slovakia", countryCode: "SK"),
        StorefrontDetails(identifier: 143499, countryName: "Slovenia", countryCode: "SI"),
        StorefrontDetails(identifier: 143472, countryName: "South Africa", countryCode: "ZA"),
        StorefrontDetails(identifier: 143454, countryName: "Spain", countryCode: "ES"),
        StorefrontDetails(identifier: 143486, countryName: "Sri Lanka", countryCode: "LK"),
        StorefrontDetails(identifier: 143548, countryName: "St. Kitts & Nevis", countryCode: "KN"),
        StorefrontDetails(identifier: 143549, countryName: "St. Lucia", countryCode: "LC"),
        StorefrontDetails(identifier: 143550, countryName: "St. Vincent & The Grenadines", countryCode: "VC"),
        StorefrontDetails(identifier: 143554, countryName: "Suriname", countryCode: "SR"),
        StorefrontDetails(identifier: 143456, countryName: "Sweden", countryCode: "SE"),
        StorefrontDetails(identifier: 143459, countryName: "Switzerland", countryCode: "CH"),
        StorefrontDetails(identifier: 143470, countryName: "Taiwan", countryCode: "TW"),
        StorefrontDetails(identifier: 143572, countryName: "Tanzania", countryCode: "TZ"),
        StorefrontDetails(identifier: 143475, countryName: "Thailand", countryCode: "TH"),
        StorefrontDetails(identifier: 143539, countryName: "The Bahamas", countryCode: "BS"),
        StorefrontDetails(identifier: 143551, countryName: "Trinidad & Tobago", countryCode: "TT"),
        StorefrontDetails(identifier: 143536, countryName: "Tunisia", countryCode: "TN"),
        StorefrontDetails(identifier: 143480, countryName: "Turkey", countryCode: "TR"),
        StorefrontDetails(identifier: 143552, countryName: "Turks & Caicos", countryCode: "TC"),
        StorefrontDetails(identifier: 143537, countryName: "Uganda", countryCode: "UG"),
        StorefrontDetails(identifier: 143444, countryName: "UK", countryCode: "GB"),
        StorefrontDetails(identifier: 143492, countryName: "Ukraine", countryCode: "UA"),
        StorefrontDetails(identifier: 143481, countryName: "United Arab Emirates", countryCode: "AE"),
        StorefrontDetails(identifier: 143514, countryName: "Uruguay", countryCode: "UY"),
        StorefrontDetails(identifier: 143441, countryName: "USA", countryCode: "US"),
        StorefrontDetails(identifier: 143566, countryName: "Uzbekistan", countryCode: "UZ"),
        StorefrontDetails(identifier: 143502, countryName: "Venezuela", countryCode: "VE"),
        StorefrontDetails(identifier: 143471, countryName: "Vietnam", countryCode: "VN"),
        StorefrontDetails(identifier: 143571, countryName: "Yemen", countryCode: "YE")
    ]
    
    class func storefront(for countryCode: String) -> StorefrontDetails? {
        return self.storefronts.first(where: {$0.countryCode == countryCode})
    }
    
    class func deviceStorefront() -> StorefrontDetails? {
        let currentLocale = Locale.current
        guard let localeCountryCode = currentLocale.regionCode else { return nil }
        
        return self.storefront(for: localeCountryCode)
    }
    
    class func accountStorefront(userToken: String) -> StorefrontDetails? {
        return nil
    }
    
}
