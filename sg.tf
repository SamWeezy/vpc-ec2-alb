resource "aws_security_group" "sg1" {
  name        = "terraform-sg"
  description = "Allow ssh and httpd"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]  ##We cannot leave ec2 instance opened to the world because then it would not be secured.
    security_groups = [ aws_security_group.sg2.id ] ##We are attaching thais sg2 to the ec2 instance and only want the load balancer to have access to the ec2 via port 80.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    env = "Dev"
  }


}

resource "aws_security_group" "sg2" {
  name        = "terraform-sg-lb"
  description = "Allow ssh and httpd"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ## We want it opened to the world because the load balancer needs access to the world.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    env                  = "Dev"
    created-by-Terraform = "yes"
  }


}
