//
//  NotificationTmpImageRepository.swift
//  AttachmentTest
//
//  Created by 横山 拓也 on 2016/08/18.
//  Copyright © 2016年 jp.co.chocoyama. All rights reserved.
//

import UIKit

class NotificationTmpImageRepository {
    
    private let tmpDirectory = NSTemporaryDirectory()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()
    
    func saveImage(from url: URL, imageName: String, completion: @escaping (_ savedUrl: URL?) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { [weak self](data, response, error) in
            guard let strongSelf = self else {
                completion(nil)
                return
            }
            
            let saveUrl = strongSelf.createFileUrl(with: imageName)
            do {
                try data?.write(to: saveUrl)
                completion(saveUrl)
            } catch let error {
                print(error)
                completion(nil)
            }
        })
        task.resume()
    }
    
    func getImage(at url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            return image
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func deleteImage(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    private func createFileUrl(with imageName: String) -> URL {
        let url = URL(fileURLWithPath: tmpDirectory).appendingPathComponent("\(imageName).png")
        return url
    }
}
