//
//  Facility.swift
//  AgentApp
//
//  Created by Noye Samuel on 03/07/2023.
//

import Foundation


//struct Facility: Codable {
//	let id: Int?
//	let name: String
//	let icon: String?
//}
//
//
//struct FacilityResponse: Codable {
//	let facilities: [Facility]
//}

struct FacilityResponse: Codable {
	let facilities: [Facility]
	let exclusions: [[Exclusion]]
}

	// MARK: - Exclusion
struct Exclusion: Codable {
	let facilityID, optionID: String
	
	enum CodingKeys: String, CodingKey {
		case facilityID = "facility_id"
		case optionID = "options_id"
	}
}
 
	// MARK: - Facility
struct Facility: Codable {
	var facilityID, name: String
	var options: [Option]
	
	enum CodingKeys: String, CodingKey {
		case facilityID = "facility_id"
		case name, options
	}
}

	// MARK: - Option
struct Option: Codable {
	var name, icon, id: String
}


struct FacilityData: Codable {
	let facilities: [BtnData]
	let exclusions: [[Exclusion]]
}

struct BtnData: Codable {
	var facilityID, name: String
	var option: [BtnOption]
}
struct BtnOption: Codable {
	var id: Int
	var name, icon: String
	var isSelected = false
}
