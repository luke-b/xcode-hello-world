# TestFlight: ruční vstupy a kroky mimo GitHub Actions

Tento dokument je záměrně oddělený od CI/CD workflow a shrnuje **co musíš dodat ručně**
(osobní údaje, Apple účet, přístupy, certifikáty) + **co ručně odkliknout/provést**
v Apple Developer, App Store Connect a na iPadu.

---

## 1) Vstupy, které musíš mít připravené

## 1.1 Účty a identity

- **Apple ID (vlastník / administrátor)**
  - e-mail Apple ID
  - zapnuté 2FA
- **Apple Developer Program membership**
  - aktivní členství organizace nebo jednotlivce
- **Role v App Store Connect**
  - minimálně práva pro správu app a TestFlight distribuci

## 1.2 Identita aplikace

- **Bundle Identifier** (musí přesně sedět s Xcode projektem)
- **Název aplikace**
- **SKU** (interní identifikátor v App Store Connect)
- **Apple Team ID** (`APPLE_TEAM_ID`)

## 1.3 Podpisování (code signing)

- **Apple Distribution certifikát** exportovaný do `.p12`
- **Heslo k `.p12`** (`P12_PASSWORD`)
- **App Store provisioning profile** pro správný Bundle ID

## 1.4 App Store Connect API klíč

- **API Key ID** (`APP_STORE_CONNECT_API_KEY_ID`)
- **Issuer ID** (`APP_STORE_CONNECT_ISSUER_ID`)
- **Soubor `AuthKey_<KEY_ID>.p8`** (uložit jako Base64 do secretu)

## 1.5 Testeři a kontakt

- **Seznam interních testerů** (jméno + e-mail + Apple ID)
- (volitelně) **Externí testeři** (e-mail)
- **Kontaktní osoba pro release** (kdo schvaluje vypuštění buildů)

---

## 2) Jak převést soubory do GitHub Secrets

> Secrets, které workflow očekává:
>
> - `BUILD_CERTIFICATE_BASE64`
> - `P12_PASSWORD`
> - `MOBILEPROVISION_BASE64`
> - `KEYCHAIN_PASSWORD`
> - `APPLE_TEAM_ID`
> - `APP_STORE_CONNECT_API_KEY_ID`
> - `APP_STORE_CONNECT_ISSUER_ID`
> - `APP_STORE_CONNECT_API_KEY_BASE64`

### 2.1 Base64 pro `.p12`

```bash
base64 -i Certificates.p12 | pbcopy
```

Výsledek vlož do `BUILD_CERTIFICATE_BASE64`.

### 2.2 Base64 pro provisioning profile

```bash
base64 -i AppStore.mobileprovision | pbcopy
```

Výsledek vlož do `MOBILEPROVISION_BASE64`.

### 2.3 Base64 pro App Store Connect API key (`.p8`)

```bash
base64 -i AuthKey_XXXXXXX.p8 | pbcopy
```

Výsledek vlož do `APP_STORE_CONNECT_API_KEY_BASE64`.

---

## 3) Ruční kroky v Apple Developer a App Store Connect

## 3.1 Apple Developer (jednorázově)

- [ ] Zkontroluj aktivní členství Apple Developer Program.
- [ ] Ověř App ID s přesným Bundle ID.
- [ ] Vygeneruj/ověř Apple Distribution certifikát.
- [ ] Vytvoř App Store provisioning profile pro danou app.

## 3.2 App Store Connect (jednorázově)

- [ ] Vytvoř app záznam (název, primární jazyk, Bundle ID, SKU).
- [ ] Vytvoř App Store Connect API key.
- [ ] Nastav interní testery (Internal Testing).
- [ ] (Volitelné) nastav External Testing group.

## 3.3 GitHub (jednorázově)

- [ ] Ulož všechny výše uvedené secrets do repozitáře:
  - `Settings` → `Secrets and variables` → `Actions`.
- [ ] Spusť ručně workflow: **iOS Release — Archive & Upload to TestFlight**.

---

## 4) Ruční kroky na iPadu (tester)

Cílové zařízení: **iPad (5. generace), iPadOS 16.7.10 (20H350)**.

- [ ] Otevři **App Store** a nainstaluj **TestFlight**.
- [ ] Přihlas se Apple ID, které je přidané mezi testery.
- [ ] Otevři pozvánku z e-mailu / public link a přijmi ji.
- [ ] Nainstaluj poslední build.
- [ ] Proveď smoke test:
  - [ ] launch aplikace
  - [ ] hlavní obrazovka / hlavní flow
  - [ ] rotace zařízení (pokud relevantní)
  - [ ] stabilita (bez pádu)
- [ ] Při bugu pošli report: build number + čas + screenshot + kroky reprodukce.

---

## 5) Kdo co vyplňuje (doporučení)

- **Release owner**
  - Team ID, API key, certifikáty, provisioning
- **Tester coordinator**
  - seznam testerů (jméno/e-mail), distribuce pozvánek
- **QA / tester**
  - potvrzení instalace na iPadu a výstup ze smoke testu

---

## 6) Nejčastější problémy

- Špatný Bundle ID vs provisioning profile → build se nevyexportuje.
- Neplatný/expirovaný certifikát → signing selže v archivu.
- Chybějící role v App Store Connect → upload odmítnut.
- Tester není přidaný do správné TestFlight skupiny → build nevidí.
