//
//  NetworkManager.swift
//  AgentApp
//
//  Created by Noye Samuel on 03/07/2023.
//

import Foundation
import Combine


class NetworkManager {
	static let shared = NetworkManager()
	
	private init() {}
	
	func fetchData() -> AnyPublisher<Data, URLError> {
		guard let url = URL(string: "https://my-json-server.typicode.com/iranjith4/ad-assignment/db") else {
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}
		
		return URLSession.shared.dataTaskPublisher(for: url)
			.map(\.data)
			.eraseToAnyPublisher()
	}
	
	func fetchLocalData() -> AnyPublisher<FacilityResponse, URLError> {
			// Create a mock ResponseData object from the JSON data
		let response =  getData()
		
		return Just(response)
			.setFailureType(to: URLError.self)
			.eraseToAnyPublisher()
	}
	
	private func getData() -> FacilityResponse {
			// Read the JSON file and parse its content
		guard let fileURL = Bundle.main.url(forResource: "response_data", withExtension: "json"),
			  let jsonData = try? Data(contentsOf: fileURL) else {
			fatalError("Failed to load JSON file")
		}
		
			// Decode the JSON data
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601 // Set the date decoding strategy
		
		do {
			let responseData = try decoder.decode(FacilityResponse.self, from: jsonData)
			return responseData
		} catch {
			fatalError("Failed to parse JSON: \(error)")
		}
	}
}

class LocalDataService {
	func fetchData() -> AnyPublisher<FacilityResponse, URLError> {
			// Create a mock ResponseData object from the JSON data
		let response =  getData()
		
		return Just(response)
			.setFailureType(to: URLError.self)
			.eraseToAnyPublisher()
	}
	
	private func getData() -> FacilityResponse {
			// Read the JSON file and parse its content
		guard let fileURL = Bundle.main.url(forResource: "mock_data", withExtension: "json"),
			  let jsonData = try? Data(contentsOf: fileURL) else {
			fatalError("Failed to load JSON file")
		}
		
			// Decode the JSON data
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601 // Set the date decoding strategy
		
		do {
			let responseData = try decoder.decode(FacilityResponse.self, from: jsonData)
			return responseData
		} catch {
			fatalError("Failed to parse JSON: \(error)")
		}
	}
}


