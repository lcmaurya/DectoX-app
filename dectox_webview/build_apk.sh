#!/bin/bash

APP_NAME="DectoX"
PACKAGE_NAME="com.dectox.webview"
ACTIVITY_NAME="MainActivity"
KEYSTORE="dectox.keystore"
KEY_ALIAS="dectoxkey"

# Step 1: Create necessary directories
mkdir -p out

# Step 2: Build DEX file from Java code
echo "[*] Compiling Java source..."
mkdir -p classes
javac -source 1.8 -target 1.8 -d classes src/*.java
if [ $? -ne 0 ]; then
    echo "Java compile failed"
    exit 1
fi

echo "[*] Creating DEX file..."
dx --dex --output=classes.dex classes/
if [ $? -ne 0 ]; then
    echo "DEX creation failed"
    exit 1
fi

# Step 3: Create APK structure
echo "[*] Packaging APK..."
aapt package -f -m -F out/$APP_NAME.apk -M AndroidManifest.xml -S res -I $PREFIX/share/aapt/android.jar

# Step 4: Add DEX file to APK
aapt add out/$APP_NAME.apk classes.dex

# Step 5: Generate keystore (if not exist)
if [ ! -f "$KEYSTORE" ]; then
    echo "[*] Generating keystore..."
    keytool -genkey -v -keystore $KEYSTORE -alias $KEY_ALIAS -keyalg RSA -keysize 2048 -validity 10000 -storepass 123456 -keypass 123456 -dname "CN=DectoX, OU=AI, O=Crypto, L=Blockchain, S=Net, C=IN"
fi

# Step 6: Sign APK
echo "[*] Signing APK..."
apksigner sign --ks $KEYSTORE --ks-pass pass:123456 --key-pass pass:123456 --out out/$APP_NAME-signed.apk out/$APP_NAME.apk

echo "[✔] APK successfully built at: out/$APP_NAME-signed.apk"
