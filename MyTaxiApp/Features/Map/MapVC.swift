//
//  MapVC.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 02/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

import UIKit
import MapKit
import MBProgressHUD
import Alamofire

class MapVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var visualEffectViewHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    
    private (set) var mapViewModel = MapViewModel()
    private var coordinate1 = Coordinate(latitude: 53.694865, longitude: 9.757589)
    private var coordinate2 = Coordinate(latitude: 53.394655, longitude: 10.099891)

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectViewHeight.constant = UIApplication.shared.statusBarFrame.size.height
        view.layoutIfNeeded()
        listButton.cornerRadius(radius: 25)
        listButton.applyShadow()
        setupMap()
        setupCollectionView()
        networkReachability()
    }
    
    // MARK: - Network reachability
    
    var reachability = NetworkReachabilityManager(host: API.getDomain())
    private func networkReachability() {
        reachability?.listener = { status in
            switch status {
            case .reachable(_):
                if self.mapViewModel.taxiList.isEmpty {
                    self.getTaxis()
                }
                break
            default:
                break
            }
        }
        reachability?.startListening()
    }
    
    // MARK: - IBActions
    
    @IBAction func showTaxiListVC(_ sender: Any) {
        let vc = Storyboard.Main.viewController(of: TaxiListVC.self, for: ViewControllerID.TaxiListVC)!
        vc.listViewModel = TaxiListViewModel(mapViewModel.taxiList)
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - MKMapView
    
    private func setupMap() {
        // Map view insets
        let insets = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: collectionView.frame.size.height, right: 0)
        //mapView.layoutMargins = insets
        mapView.setVisibleMapRect(mapView.visibleMapRect, edgePadding: insets, animated: true)
        
        // Hamburg 53.5511,9.9937
        let hamburg = CLLocationCoordinate2D(latitude: 53.511, longitude: 9.9937)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        mapView.setRegion(MKCoordinateRegion(center: hamburg, span:span), animated: true)

        // Map view delegate
        mapView.delegate = self
        
        // Region coordinates
        coordinate1 = mapView.topLeftCoordinate(topPadding: visualEffectViewHeight.constant)
        coordinate2 = mapView.bottomRightCoordinate(bottomPadding: collectionView.frame.size.height)
    }
    
    // MARK: - UICollectionView
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 154, height: collectionView.bounds.height)
        layout.minimumInteritemSpacing = UIConstants.margin()
        layout.minimumLineSpacing = UIConstants.margin()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: UIConstants.margin(), bottom: 0, right: UIConstants.margin())
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: TaxiCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TaxiCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Get Taxis
    
    private func getTaxis() {
        mapView.removeAnnotations(mapView.annotations)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        mapViewModel.taxiList.removeAll()
        collectionView.reloadData()
        collectionView.setContentOffset(CGPoint(x: -collectionView.contentInset.left, y: 0), animated: false)
        collectionView.isScrollEnabled = false
        listButton.isHidden = true
        
        mapViewModel.searchTaxis(coordinate1: coordinate1, coordinate2: coordinate2) { (success, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.collectionView.reloadData()
            self.collectionView.isScrollEnabled = !self.mapViewModel.taxiList.isEmpty
            self.collectionView.isHidden = self.mapViewModel.taxiList.isEmpty
            self.listButton.isHidden = self.mapViewModel.taxiList.isEmpty
            if success {
                self.displayTaxies()
            } else {
                self.displayError(error: error)
            }
        }
    }
    
    private func displayError(error: String? = Constants.genericErrorMessage()) {
        if reachability == nil || !reachability!.isReachable {
            AlertUtils.showAlertWith(title: Constants.noInternetMessage(), message: Constants.noInternetDescription(), viewController: self)
            return
        }
        AlertUtils.showToast(title: nil, message: error, viewController: self)
    }
    
    private func displayTaxies() {
        var annotations = Array<TaxiAnnotation>()
        for taxi in mapViewModel.taxiList {
            if let coordinate = taxi.coordinate {
                let annotation = TaxiAnnotation(coordinate: coordinate.locationCoordinate2D())
                annotation.title = taxi.fleetType ?? "TAXI"
                annotation.subtitle = "Heading: \(taxi.getHeadingDirection())"
                annotation.taxi = taxi
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
        //mapView.showAnnotations(annotations, animated: true)
    }

}

extension MapVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mapViewModel.taxiList.isEmpty {
            return 4
        }
        return mapViewModel.taxiList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, ofType: TaxiCell.self)!
        if mapViewModel.taxiList.isEmpty {
            cell.displayLoadingState()
        } else {
            cell.display(taxi: mapViewModel.getTaxi(at: indexPath.item))
        }
        return cell
    }
    
}

extension MapVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mapViewModel.taxiList.isEmpty {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        //collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        for annotation in mapView.annotations {
            if let taxiAnnotation = annotation as? TaxiAnnotation {
                if let taxi = mapViewModel.getTaxi(at: indexPath.item) {
                    if taxiAnnotation.taxi != nil && taxiAnnotation.taxi!.id == taxi.id {
                        mapView.selectAnnotation(annotation, animated: true)
                        break
                    }
                }
            }
        }
    }
    
}

extension MapVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            // When user pans or zooms in/out
            coordinate1 = mapView.topLeftCoordinate(topPadding: visualEffectViewHeight.constant)
            coordinate2 = mapView.bottomRightCoordinate(bottomPadding: collectionView.frame.size.height)
            getTaxis()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let taxiAnnotation = annotation as? TaxiAnnotation {
            let annotationIdentifier = String(describing: taxiAnnotation.self)
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            
            annotationView!.image = taxiAnnotation.image
            
            // Rotation as per heading.
            /*if let oldPin = annotationView?.viewWithTag(99) {
                oldPin.removeFromSuperview()
            }
            let pin = UIImageView(image: taxiAnnotation.image)
            pin.tag = 99
            pin.isUserInteractionEnabled = true
            
            let rotationAngle = CGFloat(taxiAnnotation.taxi!.heading * .pi / 180)
            pin.transform = CGAffineTransform(rotationAngle: rotationAngle)
            annotationView?.addSubview(pin)*/
            
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        /*UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform.identity
            view.image = #imageLiteral(resourceName: "taxi_pin")
        }*/
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /*UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            view.image = #imageLiteral(resourceName: "taxi_top")
        }*/
    }
    
}

extension MKMapView {
    func topLeftCoordinate(topPadding: CGFloat = 0) -> Coordinate {
        let coordinate = convert(CGPoint(x: 0, y: topPadding), toCoordinateFrom: self)
        return Coordinate(coordinate: coordinate)
    }
    
    func bottomRightCoordinate(bottomPadding: CGFloat = 0) -> Coordinate {
        let coordinate = convert(CGPoint(x: frame.width, y: frame.height-bottomPadding), toCoordinateFrom: self)
        return Coordinate(coordinate: coordinate)
    }
}
