//
//  ContentView.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//
import SwiftUI

struct WeatherView: View {

    @StateObject private var viewModel = WeatherViewModel(
        weatherService: WeatherService(),
        locationService: LocationService(),
        persistenceService: PersistenceService()
    )

    @State private var cityInput = ""
    @FocusState private var cityFieldFocused: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    headerSection
                    searchSection
                    locationSection
                    statusSection
                    weatherSection

                }
                .padding()
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task { await viewModel.loadLastCity() }
            }
        }
    }
}

private extension WeatherView {

    var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Current Weather")
                .font(.title2)
                .bold()

            Text("Search by city or use your current location")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var searchSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Enter US city", text: $cityInput)
                .textInputAutocapitalization(.words)
                .focused($cityFieldFocused)
                .submitLabel(.search)
                .onSubmit {
                    performSearch()
                }

            Button("Search") {
                performSearch()
            }
            .buttonStyle(.borderedProminent)
            .disabled(cityInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(14)
    }

    var locationSection: some View {
        Button {
            viewModel.requestLocation()
        } label: {
            Label("Use Current Location", systemImage: "location.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }

    @ViewBuilder
    var statusSection: some View {

        if viewModel.isLoading {
            ProgressView("Loading weather...")
                .padding(.top)
        }

        if viewModel.locationPermissionDenied {
            Text("Location access is disabled. You can enable it in Settings.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }

        if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    var weatherSection: some View {
        if let weather = viewModel.weather {
            VStack(spacing: 16) {

                Text(weather.city)
                    .font(.title)
                    .bold()

                HStack(spacing: 16) {
                    AsyncImage(
                        url: URL(
                            string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png"
                        )
                    ) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 80)
                    .accessibilityHidden(true)

                    Text("\(Int(weather.temperature))°F")
                        .font(.system(size: 48, weight: .medium))
                }

                Text(weather.description.capitalized)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 6)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut, value: weather.city)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                "\(weather.city), \(Int(weather.temperature)) degrees, \(weather.description)"
            )
        }
    }
}

private extension WeatherView {

    func performSearch() {
        cityFieldFocused = false

        let city = cityInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !city.isEmpty else { return }

        cityInput = ""

        Task {
            await viewModel.search(city: city)
        }
    }
}

#Preview {
    WeatherView()
}
