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
}




