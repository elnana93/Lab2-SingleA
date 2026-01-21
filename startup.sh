#!/bin/bash
set -euxo pipefail

# ✅ Put YOUR name here
NAME="Ali Cloud"

# Update + install nginx + curl (curl used to fetch an image)
dnf -y update || true
dnf -y install nginx

systemctl enable --now nginx

# Make an assets folder and download an image (embedded on the page)
mkdir -p /usr/share/nginx/html/assets
curl -fsSL -o /usr/share/nginx/html/assets/image.png \
  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/640px-Amazon_Web_Services_Logo.svg.png" || true

# Write the webpage (✅ name, ✅ background color, ✅ embedded image, ✅ 3 sections)
cat > /usr/share/nginx/html/index.html <<HTML
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>$NAME - EC2 Web Page</title>
  </head>
  <body style="font-family: Arial, sans-serif; margin:0; background:#f3f6ff; color:#111;">
    <div style="max-width:900px; margin:0 auto; padding:24px;">

      <div style="background:white; border-radius:14px; padding:18px; box-shadow:0 10px 25px rgba(0,0,0,.08); display:flex; gap:16px; align-items:center;">
        <img src="assets/image.png" alt="Embedded image" style="width:140px; height:auto;">
        <div>
          <h1 style="margin:0;">$NAME</h1>
          <p style="margin:6px 0 0 0;">My startup.sh installs and starts Nginx on the EC2 instance, downloads an image, and creates an index.html page (with my name, background color) I will later improve this site as time passes!!!</p>
        </div>
      </div>

      <div style="background:white; border-radius:14px; padding:18px; box-shadow:0 10px 25px rgba(0,0,0,.08); margin-top:18px;">
        <h2 style="margin:0 0 8px 0;">About Me</h2>
        <p style="margin:0;">Hi, I'm $NAME. Finally got my ec2 to work properly after moving my user data script to a seperate file using startup.sh this stuff finally worked!!!!!!!.</p>
      </div>

      <div style="background:white; border-radius:14px; padding:18px; box-shadow:0 10px 25px rgba(0,0,0,.08); margin-top:18px;">
        <h2 style="margin:0 0 8px 0;">Deliverables</h2>
        <p style="margin:0;">Bash startup script file using (startup.sh).</p>
      </div>

      <div style="background:white; border-radius:14px; padding:18px; box-shadow:0 10px 25px rgba(0,0,0,.08); margin-top:18px;">
        <h2 style="margin:0 0 8px 0;">Contact / Footer</h2>
        <p style="margin:0;">Contact: <a href="mailto:your@email.com">e5leadsusa@gmail.com</a></p>
        <p style="margin:8px 0 0 0; opacity:.7;">© $(date +%Y) $NAME</p>
      </div>

    </div>
  </body>
</html>
HTML

chmod -R a+rX /usr/share/nginx/html
systemctl restart nginx
echo "setup completed"
