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
			if let facilities = viewModel.facilities?.facilities {
				List(facilities, id: \.name) { facility in
					VStack {
						Image(facility.options[0].icon)
						Text(facility.name)
					}
				}
			} else {
				Text("Loading...")
			}
		}
		.onAppear {
			viewModel.fetchData()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
