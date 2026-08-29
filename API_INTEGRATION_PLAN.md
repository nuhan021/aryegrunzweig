# Customer + Technician API Integration Plan

Swagger source: [Backend API documentation](https://enhancement.softvenceomegaforce.cloud/api/docs#/)

## Summary

Customer ও technician—দুই role-এর signup, login এবং সম্পূর্ণ app flow API-backed করা হবে। Admin API mobile app-এ যুক্ত হবে না।

বর্তমান `NetworkCaller` production-ready নয়: এটি PATCH/DELETE/multipart সমর্থন করে না, Bearer token সঠিকভাবে পাঠায় না এবং শুধু HTTP 200 সফল ধরে। তাই feature integration-এর আগে network/auth foundation তৈরি করতে হবে।

## 1. Network ও Session Foundation

- Base URL: `https://enhancement.softvenceomegaforce.cloud`
- `ApiClient`-এ GET, POST, PATCH, DELETE ও multipart upload যোগ করা।
- যেকোনো `2xx` response সফল হিসেবে handle করা।
- `Authorization: Bearer <accessToken>` ব্যবহার করা।
- access এবং refresh token `flutter_secure_storage`-এ রাখা।
- `401` এ একবার `/api/auth/refresh` চালিয়ে request retry করা।
- refresh ব্যর্থ হলে token মুছে Login screen-এ পাঠানো।
- common loading, error, validation, pagination ও empty-state model যোগ করা।
- startup-এ saved session থাকলে `/api/auth/me` থেকে role নিয়ে সঠিক customer/technician UI খোলা।
- email-এ `tech` আছে কি না দেখে role নির্ধারণের dummy logic সরানো।

## 2. Authentication Flow

Customer ও technician signup screen-এ প্রথমে role selector থাকবে। Common fields shared হবে; technician form-এ অতিরিক্ত service area, skills, employee/license information থাকবে।

| Flow | Endpoint |
|---|---|
| Customer signup | `POST /api/auth/customer/signup` |
| Technician signup | `POST /api/auth/technician/signup` |
| Verify 5-digit OTP | `POST /api/auth/verify-email` |
| Resend verification OTP | `POST /api/auth/resend-verification` |
| Both-role login | `POST /api/auth/login` |
| Restore/verify session | `GET /api/auth/me` |
| Refresh session | `POST /api/auth/refresh` |
| Logout | `POST /api/auth/logout` |
| Forgot password OTP | `POST /api/auth/forgot-password` |
| Reset password | `POST /api/auth/reset-password` |
| Complete onboarding | `POST /api/users/me/onboarding/complete` |

- Login response-এর `user.role` হবে navigation-এর একমাত্র source of truth।
- `CUSTOMER` → customer bottom navigation।
- `TECHNICIAN` → technician bottom navigation।
- Technician `PENDING_VERIFICATION` হলে approval-pending screen দেখাবে; verified না হওয়া পর্যন্ত jobs UI খুলবে না।
- বর্তমান 6-digit OTP UI-কে Swagger অনুযায়ী 5-digit করতে হবে।

## 3. Profile, Address ও Account

| Feature | Endpoint |
|---|---|
| Load profile | `GET /api/auth/me` |
| Edit name/phone/company/avatar | `PATCH /api/users/me` |
| Technician details/availability | `PATCH /api/users/me/technician` |
| Notification preferences | `PATCH /api/users/me/preferences` |
| Saved addresses | `GET /api/users/me/addresses` |
| Add address | `POST /api/users/me/addresses` |
| Edit address | `PATCH /api/users/me/addresses/{id}` |
| Delete address | `DELETE /api/users/me/addresses/{id}` |
| Payment history | `GET /api/users/me/payments` |
| Payment/invoice details | `GET /api/payments/{id}`, `GET /api/payments/{id}/invoice` |
| Help/contact form | `POST /api/contact` |
| Business contact/settings | `GET /api/public/settings` |

Email edit আপাতত read-only থাকবে, কারণ `PATCH /api/users/me` email পরিবর্তন করে না।

## 4. Customer Service Request Lifecycle

ক্রম হবে: catalog → address → request creation → status/quote → negotiation/acceptance → Stripe authorization → appointment → completion/report।

| Step | Endpoint |
|---|---|
| Categories ও selectable issues | `GET /api/service-requests/catalog` |
| Create request with issue media | `POST /api/service-requests` |
| Add media after creation | `POST /api/service-requests/{id}/media` |
| My service requests | `GET /api/service-requests?status=...` |
| Request/quote/report/equipment details | `GET /api/service-requests/{id}` |
| Cancel before work starts | `POST /api/service-requests/{id}/cancel` |
| Accept quote and terms | `POST /api/service-requests/{id}/quotation/accept` |
| Submit negotiation | `POST /api/service-requests/{id}/quotation/counteroffers` |
| Negotiation history | `GET /api/service-requests/{id}/quotation/counteroffers` |
| Reject quote | `POST /api/service-requests/{id}/quotation/reject` |
| Start service-payment authorization | `POST /api/payments/service-requests/{requestId}/authorization` |
| Refresh payment status | `GET /api/payments/{id}` |
| Confirm completed report | `POST /api/service-requests/{id}/report/customer-confirm` |

### Customer service status mapping

- `NEW`, `UNDER_REVIEW` → Active/Under Review
- `QUOTE_SENT` → Quote Ready
- `ACCEPTED` → Payment Pending
- `SCHEDULED` → Scheduled
- `IN_PROGRESS`, `REPORT_SUBMITTED` → Active
- `COMPLETED` → Completed
- `CANCELLED` → Cancelled

Payment screen card number/CVV সংগ্রহ করবে না। Authorization response-এর `checkoutUrl` external Stripe Checkout-এ খুলবে এবং app callback/resume-এর পরে payment ও service-request details refresh করবে।

## 5. Shop, Cart, Checkout, Orders ও Returns

| Feature | Endpoint |
|---|---|
| Product categories | `GET /api/catalog/product-categories` |
| Search/filter/paginate products | `GET /api/catalog/products` |
| Product and related products | `GET /api/catalog/products/{idOrSlug}` |
| Load cart | `GET /api/cart` |
| Add product | `POST /api/cart/items` |
| Update quantity | `PATCH /api/cart/items/{productId}` |
| Remove item | `DELETE /api/cart/items/{productId}` |
| Clear cart | `DELETE /api/cart` |
| Preview tax/shipping/total | `POST /api/checkout/preview` |
| Checkout direct items | `POST /api/checkout/orders` |
| Checkout saved cart | `POST /api/checkout/cart` |
| List orders | `GET /api/orders` |
| Order tracking/detail | `GET /api/orders/{id}` |
| Cancel eligible order | `POST /api/orders/{id}/cancel` |
| Reorder | `POST /api/orders/{id}/reorder` |
| Request return | `POST /api/orders/{id}/return` |
| Returns for one order | `GET /api/orders/{id}/returns` |
| All customer returns | `GET /api/orders/returns` |

- Totals local tax calculation থেকে নেওয়া হবে না; checkout preview/cart response হবে source of truth।
- Checkout request-এ unique `idempotencyKey` ব্যবহার করতে হবে।
- `canCancel` ও `canReturn` response flags অনুযায়ী buttons দেখাতে হবে।
- Stripe Checkout শেষ হলে order details refresh করে success screen দেখাতে হবে।

## 6. Technician Core Flow

| Screen/Action | Endpoint |
|---|---|
| Home dashboard KPIs | `GET /api/technician/home-stats?timezone=...` |
| Today/Upcoming/Completed jobs | `GET /api/technician/service-requests?status=...` |
| Job details | `GET /api/technician/service-requests/{id}` |
| Mark in progress | `PATCH /api/technician/service-requests/{id}/status` |
| Load technician note | `GET /api/technician/service-requests/{id}/note` |
| Add note | `POST /api/technician/service-requests/{id}/note` |
| Update note | `PATCH /api/technician/service-requests/{id}/note` |
| Upload before/after/equipment/inlet photo | `POST /api/technician/service-requests/{id}/media` |
| Load equipment/inlet inventory | `GET /api/technician/service-requests/{id}/equipment` |
| Create/update equipment inventory | `POST /api/technician/service-requests/{id}/equipment` |
| Edit existing equipment | `PATCH /api/technician/service-requests/{id}/equipment/{equipmentId}` |
| Load service report | `GET /api/technician/service-requests/{id}/report` |
| Submit first report | `POST /api/technician/service-requests/{id}/report` |
| Save/edit existing report | `PATCH /api/technician/service-requests/{id}/report` |

- My Jobs tabs local dummy list ব্যবহার করবে না।
- Today/Upcoming grouping scheduled timestamps ও selected timezone থেকে হবে।
- Technician status endpoint বর্তমানে শুধু `IN_PROGRESS` গ্রহণ করে।
- Service report submit হলে job `REPORT_SUBMITTED` হবে; technician app নিজে `COMPLETED` করবে না। Office/admin approval-এর পরে backend থেকে `COMPLETED` আসবে।
- Report payload-এ repair status, work performed, notes, parts, follow-up, arrival এবং departure time যাবে।
- Uploaded files `BEFORE`, `AFTER`, `EQUIPMENT`, বা `INLET` kind ব্যবহার করবে।

## 7. Notifications

| Feature | Endpoint |
|---|---|
| Customer/technician notifications | `GET /api/notifications` |
| Read one | `PATCH /api/notifications/{id}/read` |
| Read all | `PATCH /api/notifications/read-all` |

Notification `data` object-এর `requestId`, `orderId`, `conversationId` অনুযায়ী correct detail screen deep-link করবে।

## 8. Phase 2: Realtime, Chat, Tracking ও Calls

### Chat

- `GET /api/conversations`
- `POST /api/conversations/support`
- `POST /api/conversations/service-requests/{requestId}`
- `GET /api/conversations/{id}/messages`
- `POST /api/conversations/{id}/messages`
- `PATCH /api/conversations/{id}/read`

### Realtime notification

- `GET /api/notifications/stream`
- authenticated SSE client, reconnect/backoff এবং last-event handling যোগ করা।

### Location tracking

- Technician: `POST /api/tracking/service-requests/{requestId}/location`
- Customer: `GET /api/tracking/service-requests/{requestId}/location`
- শুধু travelling/in-progress job-এর সময় এবং permission থাকলে technician location পাঠাবে।

### Agora calls

- `POST /api/calls/service-request/{requestId}/token`
- `POST /api/calls/{id}/token`
- `GET /api/calls/service-request/{requestId}`
- `POST /api/calls/{id}/end`

## Required Backend Additions

বর্তমান Swagger-এ নিম্নের mobile features-এর endpoint নেই; সংশ্লিষ্ট UI production-ready করার আগে backend team-কে যোগ করতে হবে।

### Change password

- `PATCH /api/users/me/password`
- Body: `currentPassword`, `newPassword`
- সব active sessions revoke করার option থাকতে হবে।

### Saved payment methods

- `GET /api/users/me/payment-methods`
- `POST /api/users/me/payment-methods/setup-session`
- `PATCH /api/users/me/payment-methods/{id}/default`
- `DELETE /api/users/me/payment-methods/{id}`

### Customer equipment

- `GET /api/users/me/equipment`
- `GET /api/users/me/equipment/{id}`
- `PATCH /api/users/me/equipment/{id}`
- প্রয়োজনে `POST /api/users/me/equipment/{id}/media`

### Push-device registration

- `POST /api/users/me/devices`
- `DELETE /api/users/me/devices/{deviceId}`

### Existing contract extensions

- `/api/public/settings` response-এ `termsVersion`, `termsUrl` এবং `privacyUrl` যোগ করা।
- Stripe Checkout-এর success/cancel return URL-কে mobile deep link বা universal link support করা।
- Notification `data` contract-এ stable `type`, `requestId`, `orderId`, `conversationId` keys document করা।

## Endpoints Not Needed in This Mobile App

- সব `/api/admin/**` endpoints
- `/api/users/admin/**`
- Admin payment capture/refund/order-status APIs
- Admin product/catalog write APIs
- `/api/webhooks/stripe`—এটি শুধু backend Stripe webhook
- `/api/catalog/services`—customer request flow-এর জন্য `/api/service-requests/catalog` ব্যবহার করলেই যথেষ্ট
- Health endpoints production UI থেকে call করার দরকার নেই

## Test Plan

- Customer ও technician signup payload, 5-digit OTP, resend এবং validation।
- Login response role অনুযায়ী সঠিক bottom navigation।
- App restart-এ token restore; expired access token-এ single refresh এবং retry।
- Refresh failure/logout-এ local credentials সম্পূর্ণ clear।
- Customer request multipart upload, quote accept/reject/negotiation এবং status transitions।
- Hosted Stripe success, cancel, browser close ও delayed webhook scenarios।
- Product pagination/filter, server-calculated totals, cart mutation এবং duplicate checkout prevention।
- Order cancel, reorder, delivered return ও return-status rendering।
- Technician jobs filtering, status update, notes, equipment quantities, media upload এবং report create/update।
- REST notification read/read-all ও deep-link routing।
- Offline, timeout, 400 validation, 401, 403, 404, 409 এবং 500 error states।
- Unit tests for DTO parsing/status mapping; repository/controller tests; mocked end-to-end customer ও technician happy paths।

## Assumptions

- Customer ও technician উভয়েই app থেকে signup করতে পারবে, তবে আলাদা endpoint/form ব্যবহার করবে।
- Admin role এই Flutter app-এর scope-এর বাইরে।
- Stripe hosted Checkout ব্যবহার হবে; app কখনও raw card/CVV data handle করবে না।
- Core REST integration প্রথম delivery; chat, SSE, tracking ও Agora calls দ্বিতীয় delivery।
- Backend থেকে ফেরত আসা IDs, totals, eligibility flags এবং statuses সবসময় UI-এর source of truth হবে।
