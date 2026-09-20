# Working of OTP

```
User enters 10-digit number
        ↓
Tap "Continue"
        ↓
Firebase sends OTP
        ↓
Open OTP screen
        ↓
User enters 6-digit OTP
        ↓
Create PhoneAuthCredential
        ↓
Firebase signInWithCredential()
        ↓
User authenticated
        ↓
Open Expenses screen
```