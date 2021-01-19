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
    
    @State var manager = CLLocationManager()
    @State var alert = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(title: $title, subtitle: $subtitle, lat: $lat, long: $long, manager: $manager, alert: $alert)
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please Enable Location Access In Settings Pannel"))
                }
            if self.title != "" {
                HStack(spacing: 12){
                    Image(systemName: "info.circle.fill")
                        .renderingMode(.original)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(self.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(self.subtitle)
                            .font(.body)
                            .foregroundColor(.gray)
                        HStack(spacing: 12){
                            Text("LAT: \(self.lat)")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("LONG: \(self.long)")
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
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    
    @State var coordinate = CLLocationCoordinate2D(latitude: 34.746483, longitude: -92.289597)
    
    
    let map = MKMapView()
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapView
        
        init(parent1: MapView) {
            parent = parent1
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .denied {
                parent.alert.toggle()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            let location = locations.last
//            let point = MKPointAnnotation()
//            parent.coordinate = location!.coordinate
//
//            point.title = "Test"
//            point.subtitle = "sub test"
//
//            point.coordinate = location!.coordinate
//
//            self.parent.map.addAnnotation(point)
//
//            let region = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//            self.parent.map.region = region
            
            
            print("Hello World")
            
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



