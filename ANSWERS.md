# Design Review Answers

## Milestone 01
**Q: Why is remote state with locking important when working in a team?**
A: Remote state ensures all team members share a single, up-to-date source of truth for the infrastructure's current state, preventing configuration drift. State locking guarantees that only one team member or CI/CD pipeline can modify the infrastructure at a time, preventing race conditions.

**Q: What happens if you and Sam run `terraform apply` at the same time without locking?**
A: Without locking, both Terraform processes will attempt to read and write to the state file concurrently. This leads to state corruption, race conditions where both try to provision or delete the same AWS resources simultaneously, and orphaned infrastructure that must be manually untangled.