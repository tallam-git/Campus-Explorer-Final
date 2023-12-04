//
//  ViewModel.swift
//  CampusExplore
//
//  Created by Charan on 01/12/23.
//

import UIKit

class ViewModel {

    static let shared = ViewModel()
    
 
    func getAllBuildings(completion: @escaping ([CampusBuilding])->()) {
  
        FireStoreManager.shared.getAllBuildings { list in
            
            completion(list)
        }
    }
      
    func getAllFaculties(completion: @escaping ([Faculty])->()) {
  
        FireStoreManager.shared.getAllFaculties { list in
            
            completion(list)
        }
    }
    
    func getAllEvents(completion: @escaping ([Event])->()) {
  
        FireStoreManager.shared.getAllEvents { list in
            
            completion(list)
        }
    }
    
//
//    func getAllOffers(completion: @escaping ([OffersModel])->()) {
//
//        FireStoreManager.shared.getAllOffers { list in
//            completion(list)
//        }
//    }
//
//
//    func getAllRestaurants(completion: @escaping ([RestaurantsModel])->()) {
//
//        FireStoreManager.shared.getAllRestaurants { list in
//            completion(list)
//        }
//    }
}
