//
//  MapViewModel.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 02/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

class MapViewModel {
    
    var taxiList: Array<Taxi>
    
    init(with taxiList: Array<Taxi> = .init()) {
        self.taxiList = taxiList
    }
    
    func getTaxi(at index: Int) -> Taxi? {
        return taxiList[index]
    }
    
    func searchTaxis(coordinate1: Coordinate, coordinate2: Coordinate, completion: ((_ success: Bool, _ error: String?) -> Void)?) {
        //self.taxiList.removeAll()
        APIMethods.searchTaxis(coordinate1: coordinate1, coordinate2: coordinate2) { (vehicleList, error) in
            if vehicleList != nil {
                self.taxiList = vehicleList!
            }
            var errorMessage = error
            if self.taxiList.isEmpty {
                errorMessage = "Oops! No taxi found in this region"
            }
            completion?(!self.taxiList.isEmpty, errorMessage)
        }
    }
    
}
