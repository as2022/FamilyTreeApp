//
//  String Tree.swift
//  BinaryTree
//
//  Created by Alex Smithson on 3/15/25.
//

let stringTree = Tree<String>("Ralph Smith", children: [
    Tree("Terri Smith", children: [
        Tree("Kirsten Smithson"),
        Tree("Drew Smithson"),
        Tree("Alex Smithson")
    ]),
    Tree("Lyle Smith", children: [
        Tree("Reese Smith"),
        Tree("Avery Smith")
    ])
])

let uniqueStringTree = stringTree.map(Unique.init)

extension Tree where A == Unique<String> {
    mutating func insert(_ string: String) {
        if string.hashValue < value.value.hashValue {
            if children.count > 0 {
                children[0].insert(string)
            } else {
                children.append(Tree(Unique(string)))
            }
        } else {
            if children.count == 2 {
                children[1].insert(string)
            } else if children.count == 1 && children[0].value.value.hashValue > string.hashValue {
                children[0].insert(string)
            } else {
                children.append(Tree(Unique(string)))
            }
        }
    }
}
