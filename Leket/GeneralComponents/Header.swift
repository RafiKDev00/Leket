//
//  Header.swift
//  Leket
//
//  Created by RJ  Kigner on 1/18/26.
//

import SwiftUI

struct Header: View {
    var onLogout: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center){
            Image("phritzdaStalkLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
            Spacer()
            
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(
            Color("grayAsparagus")
                .shadow(color:  Color("grayAsparagus").opacity(0.3), radius: 4, y: 4)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    Header()
}
