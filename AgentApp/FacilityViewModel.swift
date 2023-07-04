//
//  FacilityViewModel.swift
//  AgentApp
//
//  Created by Noye Samuel on 03/07/2023.
//

import Foundation
import Combine


class FacilityViewModel: ObservableObject {
	@Published var facilities: FacilityResponse?
	private var cancellables: Set<AnyCancellable> = []
	
	func fetchData() {
		NetworkManager.shared.fetchData()
			.decode(type: FacilityResponse.self, decoder: JSONDecoder())
		//	.map(\.facilities)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
					case .failure(let error):
							// Handle network or JSON decoding error
						print("Error: \(error)")
					case .finished:
						break
				}
			}, receiveValue: { [weak self] facilities in
				self?.facilities = facilities
				print(facilities)
			})
			.store(in: &cancellables)
	}
}




