# Privacy Policy — CaliDay

**Last updated: April 9, 2026**

---

CaliDay is a home workout app built on a simple principle: your data belongs to you.
This policy explains what information the app uses, how it stays on your device,
and the one case where you can choose to share a profile snapshot with another person.

---

## 1. Data We Collect

**CaliDay does not collect, transmit, or store any personal data on external servers.**

There are no accounts, no sign-up, no cloud sync. Everything you do in the app —
workouts, progress, streak, settings — is stored locally on your device using
on-device storage (Hive). This data never leaves your device unless you explicitly
choose to use the Friends feature (see Section 5).

---

## 2. Local Storage

The following data is stored **on your device only**:

| Data | Purpose |
|------|---------|
| Display name (optional) | Shown in your profile; shared only if you use Friends |
| Workout history | Tracking your progress over time |
| Skill progress (branch stages) | Determining which exercises to generate |
| Streak and SP (Strength Points) | Gamification |
| Settings (theme, sound, reminders) | Your preferences |
| Saved routines | Custom workouts you've built |

All of this data is deleted when you uninstall the app.

---

## 3. Health Data (Apple Health / Google Health Connect)

If you opt in during onboarding or in Settings, CaliDay can:

- **Write** workout sessions (type, duration, estimated calories) to Apple Health or Google Health Connect
- **Read** your body weight from Apple Health or Google Health Connect for more accurate calorie estimates

This integration is **entirely optional** and **off by default**. Health data is read and written
directly on your device. It is never transmitted to CaliDay's developers or any third party.
You can revoke this permission at any time in your device's Health or Settings app.

---

## 4. Camera

The camera is used **only** for scanning a friend's QR code on the Friends screen.
No photos are taken, saved, or transmitted. The camera is accessed only while the
QR scan screen is open and is released immediately after scanning.

---

## 5. Peer-to-Peer Profile Sharing (Friends Feature)

The Friends feature lets you share your workout profile with another person directly,
without any server involvement.

**What is shared:**
- Your display name
- Your current rank, SP, and streak
- Your branch progress (which stage you've reached in each branch)

**How it works:**
- Sharing happens **only when you explicitly initiate it** — by opening the Friends screen
  and either showing your QR code or tapping Connect on a nearby Bluetooth device.
- The transfer is **direct, device-to-device**: via QR code (optical) or Bluetooth (local).
  No data passes through the internet or any server.
- The recipient sees a **snapshot** of your profile at the moment of sharing.
  It is not a live feed and does not update automatically.

**What you should know:**
- Once you share your profile with someone, they have a copy of that snapshot on their device.
  Removing a friend from your list deletes their data from your device,
  but cannot remove your snapshot from theirs — the same as handing someone a business card.
- Your workout history, health data, and saved routines are **never included** in the shared profile.

This feature is **entirely optional**. If you never open the Friends screen, no peer-to-peer
data exchange ever occurs.

---

## 6. Bluetooth

Bluetooth is used **only** for the Friends feature:
- To discover nearby devices also running CaliDay (scan)
- To advertise your presence to nearby CaliDay users (peripheral mode, optional)
- To exchange profile data directly with a specific nearby device (GATT)

Bluetooth is never used to transmit data to the internet, analytics services, or any third party.
Advertising is active only while the Friends screen is open.

---

## 7. Push Notifications

CaliDay schedules local push notifications (workout reminders, streak alerts) entirely on-device.
No push tokens are sent to any server. Notifications are managed by your device's operating system.
You can disable them at any time in your device's Settings.

---

## 8. Analytics and Advertising

CaliDay contains **no analytics SDKs, no crash reporting services, no advertising networks,
and no tracking of any kind.** The developers do not know how many people use the app,
what workouts they do, or anything else about user behavior.

---

## 9. Children

CaliDay is not directed at children under the age of 13. We do not knowingly collect
any information from children. If you are a parent or guardian and believe your child
has provided personal information through the app, please contact us — though in practice
the app stores nothing off-device that could be retrieved.

---

## 10. Changes to This Policy

If this policy is updated, the "Last updated" date at the top will change.
Significant changes will be noted in the app's release notes.
Continued use of the app after a policy update constitutes acceptance of the revised policy.

---

## 11. Contact

Questions about this privacy policy:

**Email:** [kurnyakov.petr@gmail.com](mailto:kurnyakov.petr@gmail.com)
**GitHub:** [https://github.com/pupptmstr/caliday](https://github.com/pupptmstr/caliday)
