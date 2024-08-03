//
//  AppStoreAgent.swift
//  HeyWeather
//
//  Created by Kamyar on 11/7/21.
//

import Foundation
import SwiftyStoreKit
import UIKit.UIApplication
import StoreKit.SKStoreReviewController
import StoreKit

struct AppStoreAgent {
    
    static func setupSwiftyStoreKit() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                default:
                    break
                }
            }
        }
    }
    
    static func buyPlan(plan: AppPlan, completionHandler: @escaping (Bool, NetworkFailResponse?) -> Void) {
        SwiftyStoreKit.purchaseProduct(plan.id, quantity: 1, atomically: true) { result in
            switch result {
            case .success( _):
//                let receiptData = SwiftyStoreKit.localReceiptData
//                let receiptString = receiptData!.base64EncodedString(options: [])
                completionHandler(true, nil)
                
            case .error(let error):
                var response: NetworkFailResponse?
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                    response = .unknown
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: print("Payment Canceled by User")
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                    response = .unknown
                }
                completionHandler(false, response)
            case .deferred(purchase: _):
                print ("Here")
            }
            
        }
    }
    
    static func restorePurchases(completionHandler: @escaping (_ isSuccessful: Bool, _ error: RestoreError?) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                completionHandler(false, .restoreFailed)
            } else if results.restoredPurchases.count > 0 {
                    completionHandler(true, nil)
            } else {
                completionHandler(false, .nothingToRestore)
            }
        }
    }
    
    
    private static func getServerPlans(completionHandler: @escaping ([AppPlan]) -> Void, failResponseCompletionHandler: @escaping (NetworkFailResponse) -> Void) {
        let repo = Repository()
        repo.getIAPPlans { allPlans in
            completionHandler(allPlans)
        } failResponseCompletion: { failResponse in
            failResponseCompletionHandler(failResponse)
        }
    }
    
    private static func getAppStorePlans(for serverPlans: [AppPlan], completionHandler: @escaping ([AppPlan]) -> Void, failResponseCompletionHandler: @escaping (NetworkFailResponse) -> Void) {
        let productIds = serverPlans.map({$0.id})
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds)) { result in
            var plans = serverPlans
            
            for product in result.retrievedProducts {
                let indexForPlan = plans.firstIndex(where: {$0.id == product.productIdentifier})
                if let index = indexForPlan {
                    plans[index].fillDetails(product: product)
                }
            }
            if plans.isEmpty { failResponseCompletionHandler(.appStorePlans) } else { completionHandler(plans) }
        }
    }
    
    static func getPlans(completionHandler: @escaping ([AppPlan]) -> Void, failResponseCompletionHandler: @escaping (NetworkFailResponse) -> Void) {
        getServerPlans { serverPlans in
            getAppStorePlans(for: serverPlans) { plans in
                completionHandler(plans)
            } failResponseCompletionHandler: { failResponse in
                failResponseCompletionHandler(failResponse)
            }
        } failResponseCompletionHandler: { failResponse in
            failResponseCompletionHandler(failResponse)
        }
    }
    
    static func requestReview() {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        SKStoreReviewController.requestReview(in: scene)
    }
    
    
    static func openInStoreReview() {
        let url = Constants.appStoreURL + "?action=write-review"
        guard let writeReviewURL = URL(string: url) else {
            return
        }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
}

enum RestoreError: Error, LocalizedError {
    case nothingToRestore
    case restoreFailed
    case unknown
}
