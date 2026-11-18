# DHP DIGITAL – Bảng giá chữ ký số

Website giới thiệu bảng giá dịch vụ chữ ký số, giao diện responsive và thẻ gói dịch vụ dạng quyển sách lật.

## Cấu trúc
- `index.html`: website khách hàng và khu vực đăng nhập/quản trị.
- `supabase-schema.sql`: tạo bảng dữ liệu và chính sách bảo mật RLS.

## Thiết lập Supabase
1. Tạo một project tại https://supabase.com/.
2. Mở **SQL Editor → New query**, dán toàn bộ `supabase-schema.sql` và nhấn **Run**.
3. Vào **Authentication → Users → Add user**, tạo email và mật khẩu Admin.
4. Sao chép User UID của Admin. Trong SQL Editor chạy:
   ```sql
   insert into public.admins(user_id) values ('DAN-USER-UID-VAO-DAY');
   ```
5. Vào **Project Settings → API** (hoặc API Keys), sao chép Project URL và Publishable key (hoặc anon public key).
6. Mở `index.html`, thay hai giá trị `YOUR_SUPABASE_URL` và `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY` trong phần cấu hình.
7. Commit thay đổi lên GitHub.

**Không bao giờ đưa Service Role key vào mã nguồn frontend hoặc gửi qua chat.** Mật khẩu Admin chỉ nhập trong Supabase Authentication, không ghi cứng vào HTML.

## Đưa website lên GitHub Pages
1. Vào repository **Settings → Pages**.
2. Ở **Build and deployment**, chọn **Deploy from a branch**.
3. Chọn branch `main`, folder `/(root)`, nhấn **Save**.
4. Đợi GitHub Pages hoàn tất và mở URL được cung cấp.

## Lưu ý
- Các mức giá mẫu trong SQL/website chỉ để minh họa; cần thay bằng bảng giá thực tế trước khi công bố.
- Website hiện có quản lý gói dịch vụ (thêm/sửa/xóa) và đăng tin. Chức năng quản lý nhà cung cấp, tải ảnh/banner và cấu hình Zalo trực tiếp trên dashboard chưa được triển khai.
- Nếu đã chạy SQL một lần, các policy trong file được viết theo hướng có thể chạy lại an toàn.
