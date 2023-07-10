	//
	//  ContentView.swift
	//  AgentApp
	//
	//  Created by Noye Samuel on 03/07/2023.
	//

import SwiftUI

struct ContentView: View {
	@ObservedObject private var viewModel = FacilityViewModel()
	
	var body: some View {
		VStack {
		//	if let facility = viewModel.receivedData {
				ScrollView {
					LazyVStack(spacing: 10) {
						ForEach(viewModel.receivedData, id: \.facilityID) { facility in
							VStack(alignment: .leading, spacing: 8) {
								Text(facility.name)
									.font(.headline)
									.padding()
								
								ScrollView(.horizontal, showsIndicators: false) {
									LazyHStack(spacing: 10) {
										ForEach(facility.options, id: \.id) { item in
											Button(action: {
												viewModel.handleSelection(facilityID: facility.facilityID, option: item)
											}) {
												VStack(spacing: 5) {
													Image(item.icon)
														.frame(width: 15, height: 15)
													Text(item.name)
														.foregroundColor(viewModel.getTextColor(for: facility, option: item))
														.font(.caption)
														.multilineTextAlignment(.center)
														.padding(5)
												}
												
												.frame(width: 80, height: 80)
												.background(viewModel.getBackgroundColor(for: facility, option: item))
												.cornerRadius(8)
												.padding()
												.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
											}.disabled(viewModel.isOptionExcluded(facilityID: facility.facilityID, optionID: item.id))
										}
									}
								}
							}
							.frame(maxWidth: .infinity)
							.background(Color.secondary.opacity(0.3))
							.cornerRadius(10)
							.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
							.padding()
						}
					}
					.padding(.top, 16)
				}
//			} else {
//				Text("Loading...")
//			}
		}
	}
}

struct OptionView: View {
	let option: BtnOption
	var isSelected: Bool
	
	var body: some View {
		VStack(spacing: 5) {
			Image(option.icon)
				.frame(width: 15, height: 15)
			Text(option.name)
				.foregroundColor(option.isSelected ? Color.white : Color.blue.opacity(0.5))
				.font(.caption)
				.multilineTextAlignment(.center)
				.padding(5)
		}
		.frame(width: 80, height: 80)
		.background(option.isSelected ? Color.blue.opacity(0.7) : Color.secondary.opacity(0.3))
		.cornerRadius(8)
		.padding()
		.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
	}
}




