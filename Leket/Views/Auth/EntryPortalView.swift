//
//  EntryPortalView.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct EntryPortalView: View {
    @Environment(AppSession.self) private var session
    @State private var selectedType: UserType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(Color("Highland"))

                Text("Nivat")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Connecting volunteers with farms")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                VStack(spacing: 16) {
                    Text("I am a...")
                        .font(.headline)
                        .foregroundStyle(Color("GrayAsparagus"))

                    NavigationLink {
                        SignInView(userType: .volunteer)
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text("Volunteer")
                                    .font(.headline)
                                Text("Help harvest at local farms")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("Highland"))

                    NavigationLink {
                        SignInView(userType: .farmer)
                    } label: {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .font(.title2)
                            VStack(alignment: .leading) {
                                Text("Farmer")
                                    .font(.headline)
                                Text("Manage your farm and volunteers")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("RedDamask"))
            
                    
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    EntryPortalView()
        .environment(AppSession())
}
