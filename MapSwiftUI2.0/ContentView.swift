//
//  ContentView.swift
//  MapSwiftUI2.0
//
//  Created by Shawn Williams on 1/17/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var title = ""
    @State var subtitle = ""
    @State var lat = ""
    @State var long = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(title: $title, subtitle: $subtitle, lat: $lat, long: $long).edgesIgnoringSafeArea(.all)
            if self.title != "" {
                HStack(spacing: 12){
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(self.title)
                            .font(.body)
                            .foregroundColor(.black)
                        Text(self.subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                        HStack(spacing: 12){
                            Text("LAT: \(self.lat)")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("Long: \(self.long)")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding()
                .background(Color("Color"))
                .cornerRadius(15)
            }
        }
    }
}




struct MapView: UIViewRepresentable {
    
    @Binding var title: String
    @Binding var subtitle: String
    @Binding var lat: String
    @Binding var long: String
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        let map = MKMapView()
        
        let coordinate  = CLLocationCoordinate2D(latitude: 34.746483, longitude: -92.289597)
        
        map.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.746483, longitude: -92.289597), latitudinalMeters: 500, longitudinalMeters: 500)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent1: MapView) {
            parent = parent1
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let pin = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.animatesWhenAdded = true
            pin.tintColor = .red
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(
                                                    latitude:(view.annotation?.coordinate.latitude)!,
                                                    longitude: (view.annotation?.coordinate.longitude)!)) { (places, err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.parent.title = (places?.first?.name ?? places?.first?.postalCode)!
                self.parent.subtitle = (places?.first?.locality ?? places?.first?.country ?? "None")
            }
            self.parent.lat = String(format: "%.5f", (view.annotation?.coordinate.latitude)!)
            self.parent.long = String(format: "%.5f", (view.annotation?.coordinate.longitude)! )

        }
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}



