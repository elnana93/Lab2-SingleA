


data "aws_ami" "al2023" {
  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }
}

resource "aws_instance" "lab_ec2_app" {
  ami                  = data.aws_ami.al2023.id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.lab_ec2_profile.name

  vpc_security_group_ids = [aws_security_group.lab_web_sg.id]
  subnet_id = data.aws_subnets.default_vpc_subnets.ids[0]

  user_data_replace_on_change = true


  tags = merge(
    { Name = var.instance_name },
    var.extra_tags
  )

 user_data = <<EOF
#!/bin/bash
set -euxo pipefail

dnf -y update || true
dnf -y install nginx

systemctl enable --now nginx

cat > /usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Hello</title></head>
  <body style="font-family: Arial, sans-serif;">
    <h1>Hello World!</h1>
    <p>Served from EC2 via Nginx.</p>
  </body>
</html>
HTML

chmod -R a+rX /usr/share/nginx/html
systemctl restart nginx
echo "setup completed"
EOF


}


# IAM Role (EC2 can assume it)
resource "aws_iam_role" "lab_ec2_role" {
  name = "lab-ec2-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Instance Profile (this is what EC2 attaches)
resource "aws_iam_instance_profile" "lab_ec2_profile" {
  name = "lab-ec2-secrets-profile"
  role = aws_iam_role.lab_ec2_role.name
}

output "lab_ec2_instance_profile_name" {
  value = aws_iam_instance_profile.lab_ec2_profile.name
}




output "lab_ec2_public_ip" {
  value = aws_instance.lab_ec2_app.public_ip
}

output "lab_ec2_public_dns" {
  value = aws_instance.lab_ec2_app.public_dns
}

output "lab_ec2_public_url" {
  value = "http://${coalesce(aws_instance.lab_ec2_app.public_dns, aws_instance.lab_ec2_app.public_ip)}"
}


# git commit -m "first commit"