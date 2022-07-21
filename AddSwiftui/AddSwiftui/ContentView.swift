//
//  ContentView.swift
//  AddSwiftui
//
//  Created by Alexander Larsen on 05/07/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var adWidth: CGFloat = 0
    @State private var adHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            Text("Some text")
            AdnuntiusRepresentable(auId: "000000000006f450", width: $adWidth, height: $adHeight)
                .frame(minWidth: self.adWidth, maxWidth: .infinity, minHeight: self.adHeight, maxHeight: .infinity)
            Text("Some text")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
