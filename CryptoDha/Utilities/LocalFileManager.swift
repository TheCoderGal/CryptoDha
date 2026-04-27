//
//  LocalFileManager.swift
//  CryptoDha
//
//  Created by Rosh on 27/04/26.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    func getImage(file: String, folder: String) -> UIImage? {
        
        if let url = getFilePath(fileName: file, folderName: folder), FileManager.default.fileExists(atPath: url.path) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            } catch(let error) {
                print("Failed to read data from the url \(url): \(error)")
                return UIImage()
            }
        } else {
            return nil
        }
    }
    
    func saveImage(image: UIImage, file: String, folder: String) {
        createFolderIfNeeded(folderName: folder)
        guard let data = image.pngData(), let url = getFilePath(fileName: file, folderName: folder) else {return}
        do {
            try data.write(to: url)
        } catch(let error) {
            print("Failed to write data to the url \(url): \(error)")
        }
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let path = getFolderPath(folderName: folderName)?.path else {return}
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch(let error) {
            print("Failed to create new directory/folder at \(path) \(error)")
        }
        
    }
        
    func getFolderPath(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let path = url.appendingPathComponent(folderName)
        return path
    }
    
    func getFilePath(fileName: String, folderName: String) -> URL? {
        guard let folderPath = getFolderPath(folderName: folderName) else { return nil }
        return folderPath.appendingPathComponent(fileName)
    }
}
