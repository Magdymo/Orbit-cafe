# Orbit Cafe — منيو وطلبات بالباركود

كافيه وهمي لمعرض الأعمال، لكنه يعمل فعلياً: الزبون يمسح باركود الترابيزة، يطلب، والطلب يظهر فوراً في لوحة الإدارة مع صوت تنبيه.

## التشغيل
1. أنشئ مشروعاً مجانياً في [Supabase](https://supabase.com).
2. من **SQL Editor** الصق محتوى `setup.sql` ونفّذه.
3. من **Authentication > Users** أنشئ مستخدم الإدارة (بريد + كلمة مرور). ثم من **Authentication > Sign In / Providers** أوقف خيار تسجيل المستخدمين الجدد (Allow new users to sign up).
4. من **Project Settings > API** انسخ Project URL و anon public key إلى `config.js`.
5. افتح `admin.html` وسجّل الدخول، ثم من تبويب **المنيو** اضغط «استيراد المنيو الأساسي».
6. ارفع الملفات على GitHub ثم فعّل GitHub Pages (Settings > Pages > Deploy from branch).

- صفحة الباركود: `https://USERNAME.github.io/REPO/qr.html` (ولّد الباركود واطبعه)

## الروابط
- المنيو: `https://USERNAME.github.io/REPO/index.html?table=5`
- الإدارة: `https://USERNAME.github.io/REPO/admin.html`

## وضع التجربة
`DEMO_MODE = true` في `config.js` يسمح للزائر باختيار رقم الترابيزة بنفسه. غيّره إلى `false` عند التشغيل الحقيقي.
