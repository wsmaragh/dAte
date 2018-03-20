

import UIKit

class Lover: NSObject {
	var id: String?
	var name: String?
	var email: String?
	var profileImageUrl: String?

	init(dictionary: [String: String]) {
		self.id = dictionary["id"]
		self.name = dictionary["name"]
		self.email = dictionary["email"]
		self.profileImageUrl = dictionary["profileImageUrl"]
	}
}



