//MIT License
//
//Copyright (c) 2024 Omar Elsayed
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import MapKit
import YelpAPI

extension YLPClient: BusinessClientSearch {
  func search(with coordinates: CLLocationCoordinate2D, 
              term: String, limit: UInt,
              offset: UInt,
              success: @escaping ([Business]) -> Void,
              failure: @escaping (any Error) -> Void) {
    let yelpCoordinates = YLPCoordinate(latitude: coordinates.latitude, longitude: coordinates.longitude)
    search(with: yelpCoordinates, term: term, limit: limit, offset: offset, sort: .bestMatched) { result, error in
      guard let result, error == nil else {
        failure(error ?? NSError())
        return
      }
      success(result.businesses.adaptToBusiness())
    }
  }
}

extension [YLPBusiness] {
  func adaptToBusiness() -> [Business] {
    return self.compactMap { yelpBussines in
      guard let location = yelpBussines.location.coordinate else { return nil }
      return Business(name: yelpBussines.name, rating: yelpBussines.rating, coordinates: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    }
  }
}
