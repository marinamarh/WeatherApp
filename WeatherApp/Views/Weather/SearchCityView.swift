//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 05.06.2026.
//

import SwiftUI

struct SearchCityView: View {
    @Environment(CityStore.self) private var cityStore
    
    @State private var searchViewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var selectedLocation: CityLocation?
    
    var body: some View {
        NavigationStack {
            List {
                switch searchViewModel.state {
                case .idle:
                    Text("Your search results will be shown here")
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                    
                case .error(let message):
                    ContentUnavailableView(
                        "Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                case .loaded(let locations):
                    ForEach(locations) { location in
                        Button {
                            selectedLocation = location
                        } label: {
                            VStack(alignment: .leading) {
                                Text(location.name).font(.headline)
                                Text("\(location.state ?? ""), \(location.country)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .tint(.primary)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a city")
            .task(id: searchText) {
                await searchViewModel.search(query: searchText)
            }
            .sheet(item: $selectedLocation) { location in
                NavigationStack {
                    WeatherDetailView()
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button { selectedLocation = nil } label: { Image(systemName: "xmark").fontWeight(.medium) }.tint(.primary)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button {
                                    cityStore.add(location.toSaved())
                                    selectedLocation = nil
                                    searchText = ""
                                    searchViewModel.reset()
                                } label: { Image(systemName: "plus").fontWeight(.bold) }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    let mockStore = CityStore()
    
    SearchCityView()
        .environment(mockStore)
}
