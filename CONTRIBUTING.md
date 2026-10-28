# Contribution Guide

🎉 Thanks for taking the time to contribute to Shield Aegis Shift Trigger! 🎉

## Issues, pull requests, and support

You are welcome to fork or clone the repository, make changes, and open a pull
request. Issues are also welcome for bug reports, questions, and suggestions.

For a change to the code:

1. Create a branch for your change.
2. Keep the change focused and explain the reason for it.
3. Update relevant documentation when behavior or configuration changes.
4. Test your changes and describe the checks you ran in the pull request.
5. Open a pull request with a clear summary and any relevant context.

## Testing

The GitHub Actions workflows run checks for the shell scripts, GitHub Actions
configuration, and scanner behavior. Please review their results and make sure
the relevant checks pass before requesting review.

The files under `tests/fixtures/` contain intentionally vulnerable examples
used to verify scanner behavior. Keep them limited to testing; do not use them
in production.

## Security reports

Please do not report security vulnerabilities in public issues or pull
requests. Follow the private reporting instructions in
[SECURITY.md](./SECURITY.md).
