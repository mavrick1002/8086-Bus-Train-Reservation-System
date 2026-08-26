# 🎫 8086 Assembly Ticket Booking System

A console-based **Bus & Train Ticket Reservation System** built entirely in **x86 Assembly Language (8086, MASM/TASM, DOS INT 21H)**. This project demonstrates low-level systems programming — user authentication, role-based menus, dynamic seat maps, and booking management — implemented without any high-level language abstractions or external libraries.

---

## 📌 Overview

This system simulates a real-world ticket booking platform (like a bus/train reservation portal) but runs entirely in **DOS mode**, using raw memory arrays, manual string comparison, and BIOS/DOS interrupt calls for all I/O operations.

It supports two types of users:
- **Admin** — manages routes, views all bookings, and searches passengers
- **Regular User** — searches routes, books seats, views their bookings, and cancels tickets

---

## ✨ Features

### 🔐 Authentication
- User signup & login system
- Stores up to 10 users (username + password) in static arrays
- Account lockout after 3 failed login attempts
- Role detection — first registered user (`admin`) gets admin privileges

### 🚌 Route Management
- 10 predefined routes (Bus & Train) across major Bangladeshi cities
- Filter routes by **Service Type** (Bus / Train) and **Class** (AC / Non-AC)
- Displays route source, destination, fare, and available seat count

### 💺 Interactive Seat Selection
- Visual seat map rendered directly in the console
  - AC layout: 1 + 2 seating (30 seats)
  - Non-AC layout: 2 + 2 seating (40 seats)
- Real-time seat status: `[##]` Free, `[XX]` Booked, `[**]` Your Pick
- Select up to 5 seats per booking with input validation

### 🎟️ Booking & PNR System
- Auto-generated unique PNR for every confirmed booking
- Stores route, seat numbers, passenger, and booking status
- Prevents overbooking by checking live seat availability

### 📋 Booking Management
- **My Bookings** — view your own active bookings with seat details
- **Cancel Ticket** — cancel via PNR, restores seats to available pool
- **Admin: View All Bookings** — full booking list across all users
- **Admin: Search Passenger** — look up bookings by passenger name

---

## 🛠️ Tech Details

| Aspect | Detail |
|---|---|
| Language | x86 Assembly (8086) |
| Assembler | MASM / TASM |
| Model | `.MODEL SMALL` |
| I/O | DOS Interrupts (`INT 21H`) |
| Data Structures | Static byte/word arrays, parallel arrays for records |
| Memory | No dynamic allocation — fixed-size buffers throughout |

---

## 📂 Core Modules

| Procedure | Responsibility |
|---|---|
| `SIGNUP_PROC` / `LOGIN_PROC` | User registration and authentication |
| `CHK_USER` / `CHK_CRED` | Username/credential lookup |
| `DISP_RT` | Display filtered route list |
| `SEARCH_BOOK_PROC` | Route search + booking flow |
| `SELECT_AC_SEATS` / `SELECT_NONAC_SEATS` | Interactive seat picking logic |
| `DISP_AC_SEATS` / `DISP_NONAC_SEATS` | Render seat map layouts |
| `DISP_MY_BOOK` / `DISP_ALL_BOOK` | Booking history views |
| `CANCEL_PROC` | Ticket cancellation |
| `SEARCH_PASSENGER_PROC` | Admin passenger search |
| `PRINT_NUM` / `READ_NUM` | Manual number I/O (no library support) |

---

## ▶️ How to Run

1. Assemble using **TASM** or **MASM**:
   ```
   tasm booking.asm
   tlink booking.obj
   ```
2. Run in DOS or a DOS emulator (e.g. **DOSBox**):
   ```
   dosbox booking.exe
   ```
3. Follow the on-screen menu to **Signup**, **Login**, and start booking tickets.

---

## 👥 Contributors

- Deb Aditya Barua (Adi)
- Kristina Datta Ritu

---

## 📄 License

This project was built for academic purposes as part of a Computer Architecture / Assembly Language course assignment.
