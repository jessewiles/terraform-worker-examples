{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": "sts:AssumeRole",
      "Principal": {
      %{ if length(services) > 0 ~}
        "Service": ${services}%{if length(accounts) > 0 ~},%{endif ~}
      %{endif ~}%{if length(accounts) > 0 ~}
        "AWS": ${accounts}
      %{endif ~}
      },
      "Effect": "Allow"
    }
  ]
}
