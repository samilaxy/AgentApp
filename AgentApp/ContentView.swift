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
										ForEach(viewModel.btn.indices, id: \.self) { index in
											let option = viewModel.btn[index]
											Button(action: {
												print(option.name)
												viewModel.btn[index].isSelected.toggle()
											}) {
												OptionView(option: option, isSelected: option.isSelected)
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

