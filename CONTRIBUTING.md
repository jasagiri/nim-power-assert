# Contributing to PowerAssert for Nim

Thank you for your interest in contributing to PowerAssert for Nim! This document provides guidelines and information for contributors.

## 🚀 Quick Start

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/power_assert_nim.git
   cd power_assert_nim
   ```
3. **Install dependencies**:
   ```bash
   nimble install
   ```
4. **Run tests** to ensure everything works:
   ```bash
   nimble test
   ```

## 📋 Development Guidelines

### Code Style

- Follow standard Nim conventions
- Use meaningful variable and function names
- Add documentation for public APIs
- Keep functions focused and concise
- Use type annotations where helpful

### Testing

- Add tests for all new functionality
- Ensure existing tests continue to pass
- Test edge cases and error conditions
- Use descriptive test names

### Documentation

- Update README.md for user-facing changes
- Add examples for new features
- Document API changes in the appropriate docs/ files
- Update CLAUDE.md if build/test commands change

## 🧪 Running Tests

### Full Test Suite
```bash
nimble test
```

### Individual Test Files
```bash
cd tests
nim c -r test_power_assert.nim
nim c -r test_operators.nim
nim c -r test_custom_types.nim
```

### Format Verification
```bash
nim c -r examples/format_demo.nim
nim c -r examples/enhanced_demo.nim
```

## 🏗️ Project Structure

```
power_assert_nim/
├── src/                    # Source code
│   ├── power_assert.nim    # Main implementation
│   └── power_assert_enhanced_output.nim  # Enhanced formatting
├── tests/                  # Test files
├── examples/               # Usage examples
├── docs/                   # Documentation
├── scripts/                # Build and utility scripts
└── benchmarks/            # Performance benchmarks
```

## 📝 Making Changes

### 1. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes
- Write your code
- Add tests
- Update documentation
- Ensure all tests pass

### 3. Commit Your Changes
```bash
git add .
git commit -m "Add feature: brief description"
```

### 4. Push and Create PR
```bash
git push origin feature/your-feature-name
```
Then create a Pull Request on GitHub.

## 🎯 Types of Contributions

### Bug Fixes
- Create an issue describing the bug
- Include steps to reproduce
- Write a test that fails before your fix
- Fix the bug
- Ensure the test now passes

### New Features
- Discuss the feature in an issue first
- Follow the existing code patterns
- Add comprehensive tests
- Update documentation
- Provide usage examples

### Documentation
- Fix typos and improve clarity
- Add missing documentation
- Update outdated information
- Add more examples

### Performance Improvements
- Include benchmarks showing the improvement
- Ensure no functionality is broken
- Document any API changes

## 🔍 Code Review Process

1. **Automated Checks**: All PRs must pass automated tests
2. **Code Review**: Maintainers will review your code
3. **Feedback**: Address any feedback or suggestions
4. **Approval**: Once approved, your PR will be merged

### Review Criteria
- Code follows project conventions
- All tests pass
- Documentation is updated
- Changes are backward compatible (or breaking changes are justified)
- Performance impact is acceptable

## 🏷️ Release Process

Releases follow semantic versioning (SemVer):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

## 📞 Getting Help

- **Questions**: Create a GitHub issue with the "question" label
- **Bugs**: Create a GitHub issue with the "bug" label
- **Features**: Create a GitHub issue with the "enhancement" label

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help newcomers get started
- Focus on what's best for the project

## 📋 Checklist for Contributors

Before submitting a PR, ensure:

- [ ] Code follows the style guidelines
- [ ] Tests are added for new functionality
- [ ] All tests pass locally
- [ ] Documentation is updated
- [ ] CLAUDE.md is updated if build commands changed
- [ ] Examples are added for new features
- [ ] Commit messages are clear and descriptive

## 🏆 Recognition

Contributors will be:
- Listed in the project's README.md
- Mentioned in release notes
- Given appropriate credit for their contributions

Thank you for contributing to PowerAssert for Nim! 🎉