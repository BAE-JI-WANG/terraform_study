
resource "aws_iam_user" "test_user" {
	name = "test"
}

resource "aws_iam_user_policy" "art_devops_block" {
	name = "super-admin"
	user = aws_iam_user.test_user.name

	policy = <<EOF
{
	"Version" : "2012-10-17",
	"Statement" : [
		{
			"Effect" : "Allow",
			"Action" : [
				"*"
			],
			"Resource" : [
				"*"
			]
		}
	]
}
EOF
}
