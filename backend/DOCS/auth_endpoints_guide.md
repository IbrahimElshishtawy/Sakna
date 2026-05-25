# دليل مسارات الباك إند - نظام المصادقة وإدارة الجلسات
# API Endpoints Guide - Authentication & Session Management

تم إنشاء وتفعيل نظام المصادقة بالكامل في الباك إند متوافقاً مع هيكلية **Sakna (سكنى)** الهندسية النظيفة وبشكل مؤمن بالكامل. يوضح هذا الدليل كافة المسارات (Endpoints) التي تم برمجتها وجاهزيتها للاستدعاء من تطبيق الفلاتر أو عبر Postman.

---

## 1. قائمة المسارات البرمجية (API Endpoints List)

### 1️⃣ إرسال رمز التحقق للرقم (Send SMS / WhatsApp OTP)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/otp/send`
* **الحد الأمني (Rate Limiting):** أقصى حد هو **3 طلبات في خلال 10 دقائق** لنفس الجوال (لمنع السبام واستنزاف بوابات الإرسال).
* **صلاحية الرمز:** صلاحية الرمز **120 ثانية (دقيقتان)** فقط.
* **المدخلات (Request Body - JSON):**
  ```json
  {
    "phone": "1002345678",
    "country_code": "+20",
    "channel": "whatsapp" // أو "sms" (افتراضياً: sms)
  }
  ```
* **المخرجات الناجحة (Response - 200 OK):**
  ```json
  {
    "status": "success",
    "message": "OTP sent successfully via whatsapp",
    "data": {
      "session_id": "otp_sess_abcd123",
      "channel": "whatsapp",
      "expires_in": 120
    }
  }
  ```

---

### 2️⃣ التحقق من رمز الهاتف (Verify OTP)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/otp/verify`
* **المدخلات (Request Body - JSON):**
  ```json
  {
    "session_id": "otp_sess_abcd123",
    "phone": "1002345678",
    "country_code": "+20",
    "otp_code": "123456"
  }
  ```
* **المخرجات الناجحة (Response - 200 OK):**
  * يرجع توكن تحقق فريد وموقع للتأكيد الأمني.
  ```json
  {
    "status": "success",
    "message": "Phone number verified successfully",
    "data": {
      "verification_token": "eyJhbGciOiJIUzI1NiIsIn..."
    }
  }
  ```

---

### 3️⃣ إنشاء حساب جديد (User Registration)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/register`
* **الشروط الأمنية المطبقة:**
  * فحص توقيع الـ `verification_token` وتطابق رقم الجوال داخله.
  * الاسم يجب أن يكون ثلاثياً على الأقل (3 كلمات على الأقل).
  * منع تكرار البريد الإلكتروني أو الهاتف المسجل مسبقاً.
  * تشفير كلمة المرور بـ **BCrypt**.
* **المدخلات (Request Body - JSON):**
  ```json
  {
    "name": "أحمد محمد علي",
    "phone": "1002345678",
    "country_code": "+20",
    "email": "ahmad@example.com",
    "password": "Password123",
    "verification_token": "eyJhbGciOiJIUzI1NiIsIn...",
    "agree_to_terms": true
  }
  ```
* **المخرجات الناجحة (Response - 201 Created):**
  ```json
  {
    "status": "success",
    "message": "User registered successfully",
    "data": {
      "user": {
        "id": "usr_xyz456",
        "name": "أحمد محمد علي",
        "phone": "+201002345678",
        "email": "ahmad@example.com",
        "is_profile_complete": false
      },
      "tokens": {
        "access_token": "eyJhbGci...",
        "refresh_token": "eyJhbGci..."
      }
    }
  }
  ```

---

### 4️⃣ تسجيل الدخول التقليدي (User Login)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/login`
* **المدخلات (Request Body - JSON):**
  * يدعم حقل `login_field` إدخال **البريد الإلكتروني** أو **رقم الهاتف**.
  ```json
  {
    "login_field": "ahmad@example.com", // أو "1002345678"
    "password": "Password123"
  }
  ```
* **المخرجات الناجحة (Response - 200 OK):**
  ```json
  {
    "status": "success",
    "message": "Login successful",
    "data": {
      "user": {
        "id": "usr_xyz456",
        "name": "أحمد محمد علي",
        "phone": "+201002345678",
        "email": "ahmad@example.com",
        "is_profile_complete": true
      },
      "tokens": {
        "access_token": "eyJhbGci...",
        "refresh_token": "eyJhbGci..."
      }
    }
  }
  ```

---

### 5️⃣ الدخول الاجتماعي (Google & Facebook SSO)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/social`
* **الوصف:** في حال تسجيل الدخول الاجتماعي لحساب جديد يتم إنشاؤه تلقائياً بالبريد الإلكتروني وبحالة ملف شخصي غير مكتمل ويُترك الجوال فارغاً ليقوم العميل بربطه لاحقاً.
* **المدخلات (Request Body - JSON):**
  ```json
  {
    "provider": "google", // أو "facebook"
    "social_token": "google_id_token_xyz",
    "email": "user@gmail.com",
    "name": "Ahmad Mohammad",
    "avatar_url": "https://lh3.googleusercontent.com/..." // اختياري
  }
  ```
* **المخرجات الناجحة (Response - 200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "user": {
        "id": "usr_abc789",
        "name": "Ahmad Mohammad",
        "phone": null,
        "email": "user@gmail.com",
        "is_profile_complete": false
      },
      "tokens": {
        "access_token": "eyJhbGci...",
        "refresh_token": "eyJhbGci..."
      }
    }
  }
  ```

---

### 6️⃣ إكمال الملف الشخصي (Complete Profile)
* **المسار (URL):** `POST http://localhost:3000/api/v1/auth/profile/complete`
* **المتطلب الأمني:** يتطلب إرسال الـ Access Token في الرأس الحامي للطلب:
  `Authorization: Bearer <access_token>`
* **نوع الطلب (Content-Type):** `multipart/form-data`
* **المدخلات (Form Data):**
  * `gender`: `MALE` / `FEMALE`
  * `dob`: `YYYY-MM-DD` (تاريخ الميلاد)
  * `offers_enabled`: `true` / `false`
  * `avatar`: (ملف الصورة الشخصية الفعلي - اختياري)
  * `phone`: (رقم الجوال - إلزامي فقط إذا كان الحساب مسجلاً عبر جوجل/فيسبوك ولم يربط هاتف بعد)
  * `country_code`: (رمز الدولة مثل "+20" - إلزامي فقط للربط)
  * `verification_token`: (توكن التحقق المولد من تفعيل OTP - إلزامي فقط للربط)
* **المخرجات الناجحة (Response - 200 OK):**
  ```json
  {
    "status": "success",
    "message": "Profile completed successfully",
    "data": {
      "user": {
        "id": "usr_xyz456",
        "name": "أحمد محمد علي",
        "phone": "+201002345678",
        "email": "ahmad@example.com",
        "gender": "MALE",
        "dob": "1995-08-20",
        "avatar_url": "https://cdn.sakna.com/avatars/usr_xyz456_avatar.png",
        "offers_enabled": true,
        "is_profile_complete": true
      }
    }
  }
  ```

---

### 7️⃣ التحقق من صحة الجلسة (Check Active Session)
* **المسار (URL):** `GET http://localhost:3000/api/v1/auth/session`
* **المتطلب الأمني:** يتطلب إرسال الـ Access Token في الرأس الحامي للطلب:
  `Authorization: Bearer <access_token>`
* **المخرجات الناجحة (Response - 200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "user": {
        "id": "usr_xyz456",
        "name": "أحمد محمد علي",
        "phone": "+201002345678",
        "email": "ahmad@example.com",
        "gender": "MALE",
        "avatar_url": "https://cdn.sakna.com/avatars/usr_xyz456_avatar.png",
        "is_profile_complete": true
      }
    }
  }
  ```

---

## 2. ميزات الحماية والتصميم الأمنية المطبقة (Security Architectures)

1. **حماية تخطي التحقق (No Verification Bypass):** لا يمكن تخطي خطوة تفعيل الهاتف، حيث يتم توقيع توكن سري مؤقت يسمى `verification_token` يربط الهاتف بالطلب.
2. **الحد من الطلبات للـ OTP (Rate Limiter Service):** تم تطبيق ميزة حظر عشوائي لأي جوال يرسل أكثر من 3 طلبات تحقق خلال 10 دقائق منعاً لخسائر الرسائل.
3. **تشفير كلمات المرور بـ BCrypt:** تشفير تام وعميق لكلمات المرور.
4. **حارس صلاحية الجلسة (JwtAuthGuard):** يحمي مسار إكمال الملف والتحقق من الجلسة، ويقوم بفك التوكن واستخراج معرّف العميل لربطه بالخدمة.
5. **فلترة المدخلات الإضافية (Whitelisting inputs):** قمنا بتمرير فلتر تصفية شامل في `main.ts` يتخلص من أي حقول مريبة مرسلة عبر الهندسة العكسية.
