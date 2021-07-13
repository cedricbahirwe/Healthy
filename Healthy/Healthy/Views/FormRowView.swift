//
//  FormRowView.swift
//  Healthy
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import SwiftUI

struct FormRowView: View {
    let title: String
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }
    
    var body: some View {
        HStack {
            Text("\(title):")
            
            TextField(title, text: $text)
        }
    }
}

struct FormRowView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowView("Title",
                    text: .constant("value"))
    }
}
