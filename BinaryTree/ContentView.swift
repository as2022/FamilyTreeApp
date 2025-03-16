//
//  ContentView.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {
        ScrollView {
            ScrollView(.horizontal) {
                BinaryTreeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
