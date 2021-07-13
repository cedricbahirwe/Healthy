//
//  HealthyWidget.swift
//  HealthyWidget
//
//  Created by Cédric Bahirwe on 13/07/2021.
//

import WidgetKit
import SwiftUI


struct StepEntry: TimelineEntry {
    var date: Date = Date()
    var stepCount: Int
}


struct StepProvider: TimelineProvider {
    typealias Entry = StepEntry
    
    @AppStorage("StepCount", store: UserDefaults(suiteName: groupIdentifier))
    var stepCount: Int = 0
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = StepEntry(stepCount: stepCount)
        
        completion(entry)
    }
    
    func placeholder(in context: Context) -> StepEntry {
        StepEntry(stepCount: stepCount)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = StepEntry(stepCount: stepCount)
        
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
}

struct StepView: View {
    let entry: StepProvider.Entry
    var body: some View {
        Text("\(entry.stepCount) steps")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.75)
    }
}


@main
struct StepWidget: Widget {
    
    private let kind = "StepWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepProvider()) { (entry) in
            StepView(entry: entry)
        }
        .configurationDisplayName("Healthy")
        .description("Widget for Healthy app.")
    }
}

struct StepWidget_Previews: PreviewProvider {
    static var previews: some View {
        StepView(entry: StepEntry(stepCount: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
