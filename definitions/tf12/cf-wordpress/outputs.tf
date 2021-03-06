output "website" {
    value = aws_cloudformation_stack.wordpress.outputs["WebsiteURL"]
}
