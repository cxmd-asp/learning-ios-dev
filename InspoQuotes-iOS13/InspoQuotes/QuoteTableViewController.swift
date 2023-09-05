//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
 
    
    
    var bundlesToShow = [
        "Somalia Basic",
        "Somalia Silver",
        "Somalia Gold",
        "Somalia Golden Subscription",
        "Airtime - $5",
        "Airtime - $10"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bundlesToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = bundlesToShow[indexPath.row]

        return cell
    }


    // MARK: - IAP Code
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the data for the selected row
        let item = bundlesToShow[indexPath.row]
        var productIdentifier = ""
     
        switch item {
        case "Somalia Basic":
            productIdentifier = "com.banksalaam.waafi.basic"
        case "Somalia Silver":
            productIdentifier = "com.salaambank.iaptest.silver"
        case "Somalia Gold":
            productIdentifier = "com.banksalaam.waafi.golden"
        case "Somalia Golden Subscription":
            productIdentifier = "com.banksalaam.waafi.goldensub"
        case "Airtime - $5":
            productIdentifier = "com.banksalaam.waafi.5"
        case "Airtime - $10":
            productIdentifier = "com.banksalaam.waafi.10"
        default:
            productIdentifier = "com.banksalaam.waafi.basic"
        }
        
        print("You selected \(productIdentifier)")
        
        BuyBundles(productId: productIdentifier)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func BuyBundles(productId: String) {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId         
            paymentRequest.applicationUsername = NSUUID().uuidString
            
            SKPaymentQueue.default().add(paymentRequest)
            showToast(message: "Payment added to queue. Product ID: \(productId)", timeout: 1)
        } else {
            showToast(message: "Payment not added to queue", timeout: 1)        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                
                let message = "Trasansaction ID: \(transaction.transactionIdentifier ?? "--")"
                
                showToast(message: message, timeout: 10)
           
                
                SKPaymentQueue.default().finishTransaction(transaction)

            } else if transaction.transactionState == .failed {
                showToast(message: "Transaction failed", timeout: 3)
            }
            
                            
        }
    }
    
    func DisplayMessage(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            
        }

        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)            
    
    }

    func showToast(message: String, timeout: Int) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let duration = DispatchTimeInterval.seconds(5)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true, completion: nil)
        }
    }        
  
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
        // Call the functions to fetch and send the receipt data
        if let receiptData = fetchReceiptData() {
            showToast(message: "Sending receipt...", timeout: 5)
            sendReceiptData(receiptData)
        } else {
          showToast(message: "No receipt found", timeout: 5)
        }
    }
    
    
    // Define a function to fetch the receipt data
    func fetchReceiptData() -> Data? {
      // Get the receipt if it's available.
      if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
        FileManager.default.fileExists(atPath: appStoreReceiptURL.path)
      {

        do {
          let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
          return receiptData
        } catch {
            showToast(message: "Couldn't read receipt data with error: " + error.localizedDescription, timeout: 5)
          return nil
        }
      } else {
          showToast(message: "No receipt found", timeout: 5)
        return nil
      }
    }

    // Define a function to send the receipt data to the REST api
    func sendReceiptData(_ receiptData: Data) {
        
      let receiptString = receiptData.base64EncodedString(options: [])
        
      // Create a JSON object with the receipt data
      let payload = ["iapReceipt": receiptString]
        
      // Convert the JSON object to data
      do {
        let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [])
        
          // Create a URL object for your server endpoint
        let url = URL(string: "https://gouatmw.waafi.com/iaptest")!
        
          // Create a URLRequest object
        var request = URLRequest(url: url)
          
        // Set the HTTP method to POST
        request.httpMethod = "POST"
        // Set the HTTP body with the payload data
        request.httpBody = payloadData
        // Set the content type header to JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
          // Create a URLSession object
        let session = URLSession.shared
        // Create a data task to send the request and handle the response
        let task = session.dataTask(with: request) { data, response, error in
          // Check for errors
          if let error = error {
              print( "Error sending receipt: \(error.localizedDescription)")
            return
          }
          // Check for valid response and data
          if let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
            let data = data
          {
            // Parse the response data as JSON
            do {
              let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response from server: \(json)")
            } catch {
                print("Error parsing response data: \(error.localizedDescription)")
            }
          } else {
           print("Invalid response or data")
          }
        }
        // Start the task
        task.resume()
      } catch {
          showToast(message: "Couldn't encode payload data with error: " + error.localizedDescription, timeout: 5)
      }
    }

}
