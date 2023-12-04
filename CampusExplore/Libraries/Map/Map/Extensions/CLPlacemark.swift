 

import MapKit

public extension CLPlacemark {
    var address: String {
        var address = ""
        if let subThoroughfare = self.subThoroughfare {
            address += subThoroughfare + " "
        }
        if let thoroughfare = self.thoroughfare {
            address += thoroughfare + ", "
        }
        if let locality = self.locality {
            address += locality + " "
        }
        if let administrativeArea = self.administrativeArea {
            address += administrativeArea
        }
        return address
    }
    
    var mkPlacemark: MKPlacemark? {
        guard let coordinate = location?.coordinate, let addressDictionary = addressDictionary as? [String: Any] else {
            return nil
        }
        return MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    }
}
