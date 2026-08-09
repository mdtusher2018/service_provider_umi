import json
import sys

def main(filepath, new_keys):
    with open(filepath, 'r') as f:
        data = json.load(f)
    
    for k, v in new_keys.items():
        if k not in data:
            data[k] = v

    with open(filepath, 'w') as f:
        json.dump(data, f, indent=2)

if __name__ == '__main__':
    keys = {
        "accountSettings": "Account Settings",
        "personalDetails": "Personal details",
        "myAddresses": "My addresses",
        "paymentsAndRefunds": "Payments and refunds",
        "mySubscription": "My Subscription",
        "myListing": "My Listing",
        "mySchedule": "My schedule",
        "minimumBookingAmount": "Minimum booking amount",
        "myReview": "My Review",
        "addFaq": "Add FAQ",
        "changePassword": "Change password",
        "language": "Language",
        "aboutUs": "About Us",
        "termsAndConditions": "Terms and conditions",
        "privacyPolicy": "Privacy policy",
        "logout": "Log Out",
        "failedToLoadProfile": "Failed to load profile",
        "pullToRefresh": "Pull to refresh"
    }
    main(sys.argv[1], keys)
