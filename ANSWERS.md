# Design Review Answers

## Milestone 01
**Q: Why is remote state with locking important when working in a team?**
A: Remote state ensures all team members share a single, up-to-date source of truth for the infrastructure's current state, preventing configuration drift. State locking guarantees that only one team member or CI/CD pipeline can modify the infrastructure at a time, preventing race conditions.

**Q: What happens if you and Sam run `terraform apply` at the same time without locking?**
A: Without locking, both Terraform processes will attempt to read and write to the state file concurrently. This leads to state corruption, race conditions where both try to provision or delete the same AWS resources simultaneously, and orphaned infrastructure that must be manually untangled.

## Milestone 02
**Q: Why do the app servers live in private subnets yet still reach the internet?**
A: App servers live in private subnets so they cannot be accessed directly from the internet, protecting them from inbound attacks (no public IP addresses). However, they still need to reach the internet for outgoing traffic (like downloading packages or API calls). They achieve this outbound-only internet access by routing their traffic through the NAT Gateway located in the public subnet.

**Q: What is the trade-off between a single NAT Gateway and one per AZ?**
A: A single NAT Gateway is cheaper, which is ideal for a `dev` environment, but it creates a single point of failure (if that AZ goes down, the other AZ loses outbound internet access). Deploying one NAT Gateway per AZ (for `prod`) provides High Availability and fault tolerance, ensuring servers can always reach the internet, but doubles the hourly and data-processing costs.

## Milestone 03
**Q: Why is referencing a security group ID safer than allowing a CIDR range?**
A: Referencing a security group ID dynamically trusts any resource attached to that group, regardless of its IP address. In an Auto Scaling environment, IP addresses change constantly as instances are created or destroyed. Using a CIDR block would require trusting entire subnets, which violates least privilege, whereas SG referencing explicitly strictly links the tiers (e.g., only traffic originating from the ALB is allowed to hit the App layer).

**Q: If the ALB is compromised, what can an attacker reach directly? Explain using your rules.**
A: If the ALB is compromised, an attacker can only reach the App servers on port 80, as defined by the `app_http_from_alb` ingress rule. They cannot reach the database directly because the Database SG strictly allows traffic only from the App SG, isolating the data tier from the public-facing load balancer.