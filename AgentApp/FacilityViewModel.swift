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
	@Published var btn: FacilityData?
	@Published var receivedData: [Facility] = []
	@Published var exclusions: [[Exclusion]] = []
	@Published var selectedOptions: [String: Option] = [:]
	@Published  var exclusionCombinations: [Exclusion] = []
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		fetchData()
	}
	
	func fetchData() {
		NetworkManager.shared.fetchData()
			.decode(type: FacilityResponse.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
					case .failure(let error):
							// Handle network or JSON decoding error
						print("Error: \(error)")
					case .finished:
						break
				}
			}, receiveValue: {[ weak self] response in
				self?.receivedData = response.facilities
				self?.exclusions = response.exclusions
				print("response:",response)
			})
			.store(in: &cancellables)
	}

	
	func handleSelection(facilityID: String, option: Option) {
		if let currentSelection = selectedOptions[facilityID] {
			if currentSelection.id == option.id {
				selectedOptions[facilityID] = nil
			} else {
				selectedOptions[facilityID] = option
			}
		} else {
			selectedOptions[facilityID] = option
		}
	}
	
	func isOptionExcluded(facilityID: String, optionID: String) -> Bool {
		var isDisabled = false
		
		for pairedExclusions in exclusions {
			
			if selectedOptions.contains(where: { ($0.key, $0.value.id) == (pairedExclusions[0].facilityID, pairedExclusions[0].optionID ) }) {
				
				isDisabled = (pairedExclusions[1].facilityID, pairedExclusions[1].optionID) == (facilityID, optionID)
				print("first available", isDisabled)
				
			} else if selectedOptions.contains(where: { ($0.key, $0.value.id) == (pairedExclusions[1].facilityID, pairedExclusions[1].optionID) }) {
				print("Second available")
				isDisabled = (pairedExclusions[0].facilityID, pairedExclusions[0].optionID) == (facilityID, optionID)
			}
		}
		return isDisabled
	}

	
	
//	func fetchLocalData() {
//		NetworkManager.shared.fetchLocalData()
//			//.decode(type: FacilityResponse.self, decoder: JSONDecoder())
//			//	.map(\.facilities)
//			.receive(on: DispatchQueue.main)
//			.sink(receiveCompletion: { completion in
//				switch completion {
//					case .failure(let error):
//							// Handle network or JSON decoding error
//						print("Error: \(error)")
//					case .finished:
//						break
//				}
//			}, receiveValue: { [weak self] facilities in
//				self?.facilities = facilities
//				//ForEach(self?.facilities)
//				if let items = self?.facilities?.facilities {
//					for item in items {
//						for option in item.options {
//							self?.btn.append(BtnOption(name: option.name, icon: option.icon))
//						}
//					}
//				}
//				print(facilities)
//				print("btn:",self?.btn)
//			})
//			.store(in: &cancellables)
//	}
}

extension FacilityViewModel {
	func getTextColor(for facility: Facility, option: Option) -> Color {
		if let selectedOption = selectedOptions[facility.facilityID], selectedOption.id == option.id {
			return Color.white
		} else {
			return Color.blue.opacity(0.5)
		}
	}
	
	func getBackgroundColor(for facility: Facility, option: Option) -> Color {
		if let selectedOption = selectedOptions[facility.facilityID], selectedOption.id == option.id {
			return Color.blue.opacity(0.7)
		} else {
			return Color.secondary.opacity(0.3)
		}
	}
}
