---
name: react-native-expo
description: "React Native + Expo — muunna React-web-app mobiilisovellukseksi iOS ja Android. Käytä: React Native, Expo, mobiilisovellus, iOS app, Android app, Expo Router, native app, file-based routing mobile, EAS Build."
---

# React Native + Expo — web Reactista mobiilisovellukseksi

Expo on 2026 suositeltava tapa rakentaa React Native -sovelluksia. **SDK 55** (helmikuu 2026, RN 0.83) on uusin — Legacy Architecture poistettu, New Architecture oletuksena. Jakaa liiketoimintalogiikan React-web-projektin kanssa.

## Milloin käyttää

- Haluat julkaista App Storeen / Google Playhin
- Web-app on jo olemassa — haluat jakaa logiikan native-version kanssa
- Tarvitset natiiveja ominaisuuksia: push-ilmoitukset, kamera, GPS, biometria

## Expo vs React Native CLI

| Tekijä | Expo Managed | React Native CLI |
|--------|-------------|-----------------|
| Aloitus | `npx create-expo-app` | Vaatii Xcode + Android Studio |
| Native-moduulit | 100+ valmiina (SDK) | Itse asennettava |
| Build | EAS Build (pilvi) | Lokaalisti |
| Testaus | Expo Go -app (QR) | Simulaattori |
| Suositus 2026 | ✅ Oletusvalinta | Vain erikoistarpeisiin |

## Asennus — uusi projekti

```bash
npx create-expo-app@latest PukkariNative --template tabs  # SDK 55
cd PukkariNative && npx expo start
# Skannaa QR Expo Go -appilla → näkyy välittömästi puhelimessa
```

## Expo Router — file-based routing

```
app/
  _layout.tsx           → root layout (Stack / Tabs)
  index.tsx             → /
  events/
    index.tsx           → /events
    [id].tsx            → /events/:id
  (tabs)/
    players.tsx         → tabbi: pelaajat
    calendar.tsx        → tabbi: kalenteri
```

```tsx
// app/(tabs)/players.tsx
import { Link } from 'expo-router'

export default function Players() {
  return <Link href="/events/42">Avaa tapahtuma</Link>
}
```

## Koodin jakaminen web-projektin kanssa

```
pukkari-web/     (React + Vite)
pukkari-native/  (Expo)
shared/
  api/           ← sama fetch-logiikka molemmissa
  types/         ← TypeScript-tyypit
  utils/         ← apufunktiot (ei UI:ta)
```

Platform-spesifiset komponentit:

```
PlayerCard.native.tsx  → Expo käyttää tätä
PlayerCard.web.tsx     → Vite käyttää tätä
```

## Web → Native: elementtimuunnos

| Web (HTML/CSS) | React Native |
|----------------|-------------|
| `<div>` | `<View>` |
| `<p>`, `<span>` | `<Text>` |
| `<button>` | `<Pressable>` / `<TouchableOpacity>` |
| `<img>` | `<Image>` |
| CSS-tyyli | `StyleSheet.create({})` tai NativeWind |
| `localStorage` | `AsyncStorage` |

## Natiiviominaisuudet Expo SDK:lla

```tsx
import * as Notifications from 'expo-notifications'  // push-ilmoitukset
import * as Camera from 'expo-camera'               // kamera
import * as Location from 'expo-location'           // sijainti
// 100+ moduulia — ei native-koodia tarvita
```

## EAS Build — tuotantobuild

```bash
npm install -g eas-cli && eas login
eas build --platform ios        # .ipa → App Store
eas build --platform android    # .aab → Google Play
```

## Migraatio Pukkarista nativeksi

```
1. npx create-expo-app PukkariNative --template tabs
2. Kopioi src/data/ → shared/data/
3. Luo app/(tabs)/: players, calendar, chat, stats
4. Korvaa div→View, p→Text, button→Pressable
5. Testaa Expo Go -appilla
6. Push-ilmoitukset: expo-notifications (korvaa NotificationCenter)
7. EAS Build → julkaisu App Storeen / Google Playhin
```

## Yleisimmät virheet

| Virhe | Ratkaisu |
|-------|----------|
| `div` ei toimi | Korvaa `<View>` |
| CSS class ei toimi | Käytä `StyleSheet` tai NativeWind |
| `localStorage` undefined | Käytä `AsyncStorage` |
| Fontti ei lataudu | `expo-font` + `useFonts` |

## Resurssit

- [Expo Router docs](https://docs.expo.dev/router/introduction/)
- [React Native 2026 guide](https://adevs.com/blog/why-react-native-still-leads-cross-platform-development-in-2026/)
- [Expo SDK 55 — What's New](https://medium.com/@onix_react/whats-new-in-expo-sdk-55-6eac1553cee8)
