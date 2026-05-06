# Tupay Demo App

Tupay is a fintech platform demo built in Flutter. This application showcases a seamless cross-border payment experience, allowing users to easily mock transfers between NGN (Nigerian Naira) and RMB (Chinese Yuan).

The app was designed to demonstrate high-performance engineering, smooth user experience, and modern security practices within a Flutter app.

## 🚀 Key Features

We focused on bringing the UI to life while keeping performance smooth and adding essential security elements:

1. **Super Smooth Scrolling**: The balance card on the dashboard smoothly shrinks and stays pinned to the top as you scroll.  
2. **Resume Where You Left Off**: If your phone needs memory and silently closes the app while you're in the middle of a transfer, don't worry! When you open it again, it brings you right back to the exact step with all the details you already typed. 
3. **Secure Background Blur**: Whenever you switch apps or minimize Tupay, a privacy blur and lock icon automatically cover the screen to protect your financial details from prying eyes.
4. **Secure Data Storage**: Whenever you finish a transfer, the transaction ID is safely stored using your phone's built-in secure storage.
5. **No Lag on Big Data**: We created a background process to handle massive amounts of data (like loading a heavy 5MB list of 50,000 transactions). Because this heavy lifting happens in the background, the app never freezes or lags.

## 👤 Test Users (Dummy Accounts)

This is a demo app, meaning there is no real backend server. Everything runs on your device!

To quickly test the app without signing up, you can log in using one of our built-in dummy accounts. Just enter any of the emails below on the login screen (the password doesn't matter, just make sure the email matches):

- **`tola@tupay.demo`** - Fully verified user with a high balance and linked bank accounts (password also just Password1!)
- **`ada@tupay.demo`** - Another verified user with multiple wallets to explore (password also just ada12345!)
- **`seyi@tupay.demo`** - An unverified user account with lower limits (password also just seyi123!)

### Create Your Own Account!
If you prefer, you can also just hit the **Sign Up** button on the welcome screen. The app will let you create your own temporary profile and walk you through the experience!

---

## 🛠 Running the App

To run the app locally, just use standard Flutter commands:

```bash
flutter pub get
flutter run
```

To run the automated tests:
```bash
flutter test
```

