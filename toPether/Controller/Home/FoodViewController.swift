//
//  FoodViewController.swift
//  toPether
//
//  Created by 林宜萱 on 2021/10/30.
//

import UIKit

class FoodViewController: UIViewController {
    
    convenience init(selectedPet: Pet?) {
        self.init()
        self.selectedPet = selectedPet
    }
    private var selectedPet: Pet!
    private var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.year = 2021
//        dateComponents.month = 8
//        dateComponents.day = 7
//        let mockdate = dateComponents.date
        
//        PetModel.shared.setFood(
//            petId: selectedPet.id,
//            name: "Test food name",
//            weight: "800 weight",
//            unit: "kg",
//            price: "$ 1000",
//            market: "Shoppe",
//            dateOfPurchase: mockdate!,
//            note: "mock note") { result in
//            switch result {
//            case .success(let food):
//                print("food mock", food.dateOfPurchase)
//            case .failure(let error):
//                print("food mock error", error)
//            }
//        }
        
        PetModel.shared.queryFoods(petId: selectedPet.id) { result in
            switch result {
            case .success(let foods):
                for index in foods {
                    print(index.dateOfPurchase)
                }
//                food[0].dateOfPurchase = mockdate!
//                PetModel.shared.updateFood(petId: self.selectedPet.id, recordId: food[0].id, food: food[0])
                PetModel.shared.deleteFood(petId: self.selectedPet.id, recordId: foods[1].id)
            case .failure(let error):
                print("query foods error", error)
            }
        }
    }
    
    @objc func tapAdd(_: UIButton) {
        
    }
}
