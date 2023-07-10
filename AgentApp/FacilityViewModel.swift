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
	
	@Published var btnFacilities: [BtnData] = []
	@Published var btnOption: [BtnOption] = []
	@Published var isSelected = false
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		fetchData()
		//fetchLocalData()
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
//				let btnData = FacilityData(
//					facilities: facilityResponse.facilities.map { facility in
//						BtnData(
//							facilityID: facility.facilityID,
//							name: facility.name,
//							option: facility.options.map { option in
//								BtnOption(
//									id: Int(option.id) ?? 0,
//									name: option.name,
//									icon: option.icon
//								)
//							}
//						)
//					},
//					exclusions: facilityResponse.exclusions
//				)

			}

)
			.store(in: &cancellables)
	}

	
	func handleSelection(facilityID: String, option: Option) {
		if let currentSelection = selectedOptions[facilityID] {
			if currentSelection.id == option.id {
				selectedOptions[facilityID] = nil
			} else {
				selectedOptions[facilityID] = option
			}
		//	print("selected", selectedOptions)
		} else {
			selectedOptions[facilityID] = option
		//	print("selected", selectedOptions)
		}
	}
	
	func isOptionExcluded(facilityID: String, optionID: String) -> Bool {
			//  exclusionCombinations.contains(where: { $0 == (facilityID, optionID) })
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

extension FacilityViewModel {
	func getTextColor1(for facility: Facility, option: Option) -> Color {
		if let selectedOption = selectedOptions[facility.facilityID], selectedOption.id == option.id {
			return isOptionExcluded(facilityID: facility.facilityID, optionID: option.id) ? Color.blue.opacity(0.5) : Color.white
		} else {
			return isOptionExcluded(facilityID: facility.facilityID, optionID: option.id) ? Color.white : Color.blue.opacity(0.5)
		}
	}
	
	func getBackgroundColor1(for facility: Facility, option: Option) -> Color {
		if let selectedOption = selectedOptions[facility.facilityID], selectedOption.id == option.id {
			return isOptionExcluded(facilityID: facility.facilityID, optionID: option.id) ? Color.white : Color.blue.opacity(0.7)
		} else {
			return isOptionExcluded(facilityID: facility.facilityID, optionID: option.id) ?  Color.white : Color.secondary.opacity(0.3)
		}
	}
}
