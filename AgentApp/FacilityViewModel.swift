//
//  FacilityViewModel.swift
//  AgentApp
//
//  Created by Noye Samuel on 03/07/2023.
//

import Foundation
import Combine
import SwiftUI


class FacilityViewModel: ObservableObject {
	@Published var facilities: FacilityResponse?
	@Published var btn: [BtnOption] = []
	@Published var isSelected = false
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		fetchData()
		//fetchLocalData()
	}
	
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
				//
				if let items = self?.facilities?.facilities {
					for item in items {
						for option in item.options {
							self?.btn.append(BtnOption(name: option.name, icon: option.icon))
						}
					}
				}
				print(facilities)
				print("btn:",self?.btn)
			})
			.store(in: &cancellables)
	}
	
	func fetchLocalData() {
		NetworkManager.shared.fetchLocalData()
			//.decode(type: FacilityResponse.self, decoder: JSONDecoder())
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
				//ForEach(self?.facilities)
				if let items = self?.facilities?.facilities {
					for item in items {
						for option in item.options {
							self?.btn.append(BtnOption(name: option.name, icon: option.icon))
						}
					}
				}
				print(facilities)
				print("btn:",self?.btn)
			})
			.store(in: &cancellables)
	}
}




