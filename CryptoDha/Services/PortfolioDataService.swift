//
//  PortfolioDataService.swift
//  CryptoDha
//
//  Created by Rosh on 28/04/26.
//

import Foundation
import CoreData

/// This class takes care of CRED ops on the core data entity along with initialisation of the coredata container. Exposes only one public function that takes care of all cred ops to outside layers
class PortfolioDataService {
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    let containerName = "PortfolioContainer"
    let entityName = "PortfolioEntity"

    private let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Error in loading container: \(error)")
            }
        }
    }
    
    //PUBLIC
    func updateSavedEntity(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: {$0.coinID == coin.id})  {
            print("updating existing one")
            if amount > 0 {
                editPortfolio(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            print("adding new coin")
            add(coin: coin, amount: amount)
        }
    }
    
    //PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try persistentContainer.viewContext.fetch(request)
        } catch(let error) {
            print("Error in fetching Portfolio entities: \(error)")
        }
    }
    
    private func editPortfolio(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        persistentContainer.viewContext.delete(entity)
        applyChanges()
    }
    
    //Add a new coin to the coredata
    private func add(coin: Coin, amount: Double) {
        let entity = PortfolioEntity(context: persistentContainer.viewContext)
        entity.amount = amount
        entity.coinID = coin.id
        applyChanges()
    }
    
    //Saving the coredata container context
    private func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch(let error) {
            print("Error in saving Portfolio entities: \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
