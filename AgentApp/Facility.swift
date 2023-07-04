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
	let facility_id, options_id: String
}
 
	// MARK: - Facility
struct Facility: Codable {
	let facility_id, name: String
	let options: [Option]
}

	// MARK: - Option
struct Option: Codable {
	let name, icon, id: String
}
