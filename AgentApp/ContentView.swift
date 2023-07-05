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
			if let facility = viewModel.facilities?.facilities {
				ScrollView {
					LazyVStack(spacing: 10) {
						ForEach(facility, id: \.name) { facility in
							VStack(alignment: .leading, spacing: 8) {
								Text(facility.name)
									.font(.headline)
									.padding()
								
								ScrollView(.horizontal, showsIndicators: false) {
									LazyHStack(spacing: 10) {
										ForEach(facility.options, id: \.id) { option in
											Button(action: {
												print(option.name)
												viewModel.selectOption(option)
											}) {
												OptionView(option: option, isSelected: option == viewModel.selectedOption)
											}
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
			} else {
				Text("Loading...")
			}
		}
	}
}

struct OptionView: View {
	let option: Option
	var isSelected: Bool
	
	var body: some View {
		VStack(spacing: 5) {
			Image(option.icon)
				.resizable()
				.frame(width: 40, height: 40)
			
			Text(option.name)
				.foregroundColor(isSelected ? Color.white : Color.blue.opacity(0.5))
				.font(.caption)
				.multilineTextAlignment(.center)
				.padding(5)
		}
		.frame(width: 80, height: 80)
		.background(isSelected ? Color.blue.opacity(0.7) : Color.secondary.opacity(0.3))
		.cornerRadius(8)
		.padding()
		.shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
	}
}

