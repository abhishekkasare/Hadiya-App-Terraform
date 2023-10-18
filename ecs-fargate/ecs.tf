#LoadBalancer-SG
resource "aws_security_group" "lb" {
  name        = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Loadbalancer and Target group
resource "aws_lb" "default" {
  name            = "tf-alb"
  subnets         = var.public_subnets
  security_groups = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "target_group" {
  name        = "tf-target-group"
  port        = "3000"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.id
    type             = "forward"
  }
}
# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

#TaskDefinition
resource "aws_ecs_task_definition" "task_def" {
  family                   = "hadiya-project"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn 

  container_definitions = <<DEFINITION
[
  {
    "image": "318988877498.dkr.ecr.eu-west-3.amazonaws.com/hadiya-backend:latest",               
    "cpu": 512,
    "memory": 1024,
    "name": "hadiya",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}

#SG for ECS service
resource "aws_security_group" "sg_service" {
  name        = "hadiya-svc-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ECS Cluster and service
resource "aws_ecs_cluster" "main" {
  name = "tf-cluster"
}

resource "aws_ecs_service" "svc" {
  name            = "hadiya-backend-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.sg_service.id]
    subnets         = var.private_subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.id
    container_name   = "hadiya"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.lb_listener]
}
