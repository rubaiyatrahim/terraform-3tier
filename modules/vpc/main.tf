# 1. VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "novacart-${var.environment}-vpc"
  }
}

# 2. Subnets (using cidrsubnet for dynamic calculation)
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "novacart-${var.environment}-public-${var.azs[count.index]}" }
}

resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = var.azs[count.index]

  tags = { Name = "novacart-${var.environment}-private-${var.azs[count.index]}" }
}

resource "aws_subnet" "database" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 4)
  availability_zone = var.azs[count.index]

  tags = { Name = "novacart-${var.environment}-database-${var.azs[count.index]}" }
}

# 3. Internet Gateway & Public Routing
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "novacart-${var.environment}-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "novacart-${var.environment}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 4. NAT Gateways (Controlled by single_nat_gateway variable)
resource "aws_eip" "nat" {
  count  = var.single_nat_gateway ? 1 : length(var.azs)
  domain = "vpc"
  tags   = { Name = "novacart-${var.environment}-nat-eip-${count.index + 1}" }
}

resource "aws_nat_gateway" "nat" {
  count         = var.single_nat_gateway ? 1 : length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = { Name = "novacart-${var.environment}-nat-${count.index + 1}" }

  depends_on = [aws_internet_gateway.igw]
}

# 5. Private & Database Routing
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    # If single_nat_gateway is true, all private subnets route to the 0th NAT.
    # Otherwise, each private subnet routes to the NAT in its own AZ.
    nat_gateway_id = aws_nat_gateway.nat[var.single_nat_gateway ? 0 : count.index].id
  }

  tags = { Name = "novacart-${var.environment}-private-rt-${var.azs[count.index]}" }
}

resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  # No default route to IGW or NAT (strictly internal)
  tags   = { Name = "novacart-${var.environment}-database-rt" }
}

resource "aws_route_table_association" "database" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}