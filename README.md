# L-MobileSales-Mini
Mini-version of leysco mobile sales application focusing on field sales, inventory management, and customer interactions.

flowchart TD

    A[App Launch] --> B[Login Screen]

    B --> C[User Enters Credentials]

    C --> D{Password Valid?}

    D -->|No| E[Show Validation Error]
    E --> F{Attempts < 3?}

    F -->|Yes| C
    F -->|No| G[Start 5-Minute Cooldown]
    G --> B

    D -->|Yes| H{Credentials Match?}

    H -->|No| E

    H -->|Yes| I[Generate Auth Token]
    I --> J[Store Token Securely]
    J --> K[Set Logged-In Flag]
    K --> L[Navigate to Home Screen]

    B --> M[Forgot Password Selected]

    M --> N[Show Recovery Form]
    N --> O[User Enters Email & Username]
    O --> P{Details Match?}

    P -->|No| N
    P -->|Yes| Q[Show Loader]
    Q --> R[Send Reset Email]

    C --> S{Remember Me Enabled?}

    S -->|Yes| T[Encrypt & Store Credentials]
    S -->|No| U[Continue Login]

    L --> V{Token Expired?}

    V -->|Yes| W{Auto Refresh Supported?}
    W -->|Yes| X[Refresh Token]
    X --> L

    W -->|No| B
    V -->|No| L
