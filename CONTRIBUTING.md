# Maintaining this setup

For each new setup change or fix:

1. Keep only the relevant source or sanitized configuration in its folder. Never copy the whole home directory or system configuration tree.
2. Explain the symptom, hardware and Fedora version, commands, dependencies, verification, and rollback in its guide.
3. Add a dated entry to `CHANGELOG.md`. Separate confirmed behavior from pending tests.
4. Preserve upstream copyright notices, licenses, and modification records.
5. Run `bash -n` on changed shell scripts and appropriate configuration checks. Do not apply all hardware fixes merely to validate a documentation change.
6. Review `git diff --cached` for credentials, personal paths, logs, downloaded firmware, and build artifacts before committing and publishing.

Use descriptive commits and push normal fast-forward updates to `main`. Hardware testing is manual; documentation and syntax checks cannot prove working suspend, camera streaming, or faster visible startup.

Suggested issue information: model identifier, Fedora release, kernel version, symptom, recent changes, and sanitized relevant journal lines. Exclude serial numbers, personal filenames, and credentials.
