resource "aws_iam_instance_profile" "managed-ad-terminal-profile" {
  name = "${local.iam_name_prefix}Profile"
  role = aws_iam_role.managed-ad-terminal-role.name
}

resource "aws_iam_role" "managed-ad-terminal-role" {
  name               = "${local.iam_name_prefix}Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "managed-ad-terminal-role-policy-attachment1" {
  role       = aws_iam_role.managed-ad-terminal-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "managed-ad-terminal-role-policy-attachment2" {
  role       = aws_iam_role.managed-ad-terminal-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}