//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lee, Steve on 10/23/18.
//  Copyright © 2018 Lee, Steve. All rights reserved.
//

import UIKit
import MapKit


class  MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
//    var studentsInformation: [Students] = [Students]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get notifications on reloading data
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadStarted), name: .reloadStarted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompleted), name: .reloadCompleted, object: nil)
        
        mapView.delegate = self
        loadStudents()
    }

    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {
                print("error")
                return
            }
            guard let url = URL(string: subtitle!), UIApplication.shared.canOpenURL(url) else {
                print("error")
                return
            }
            UIApplication.shared.open(url, options: [:])

        }
    }
    
    
    private func loadStudents() {
        Client.sharedInstance().getStudents() { (data, error) in
            if let data = data {
                StudentsInformation.shared.studentsInformation = data
                print("data for map loaded")
                performUIUpdatesOnMain {
                    self.showStudentsOnMap(StudentsInformation.shared.studentsInformation)
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    private func showStudentsOnMap(_ students: [Students]) {
        
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        
        // We are using the dictionaries to create map annotations.
        // This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for student in students where student.lat != 0.0 && student.long != 0.0 {
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL ?? ""
            annotation.coordinate = CLLocationCoordinate2D(latitude: student.lat, longitude: student.long)

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @objc func reloadStarted() {
        performUIUpdatesOnMain {
            print("reload for map started")
        }
    }
    
    @objc func reloadCompleted() {
        performUIUpdatesOnMain {
            self.showStudentsOnMap(StudentsInformation.shared.studentsInformation)
            print("reload for map finished")

        }
    }

}

