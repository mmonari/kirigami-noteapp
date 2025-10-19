# Documentation Guide

Welcome to the Kirigami NoteApp documentation! This guide helps you navigate the available documentation and find what you need.

## 📚 Documentation Structure

All project documentation is organized in the `assets/docs/` directory for easy access and maintenance.

### For Users

#### Getting Started
- **[QUICKSTART.md](QUICKSTART.md)** - Your first stop! Get the app running in 5 minutes
  - Installation instructions
  - First run guide
  - Basic usage examples

#### Feature Guides
- **[MIME_TYPES.md](MIME_TYPES.md)** - Complete reference for supported file formats
  - List of 50+ supported text file types
  - MIME type detection explanation
  - How to test file format support
  - Adding new file types

- **[UNSAVED_CHANGES_FEATURE.md](UNSAVED_CHANGES_FEATURE.md)** - Understanding save protection
  - How the feature works
  - User experience flows
  - Testing scenarios
  - Implementation details

### For Developers

#### Technical Documentation
- **[REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)** - MIME type implementation deep dive
  - Technical changes made
  - QMimeDatabase integration
  - Desktop file configuration
  - Build system updates
  - Verification checklist

- **[INDEX.md](INDEX.md)** - Complete project overview
  - Project history
  - Architecture overview
  - Component descriptions
  - Development roadmap

## 🗺️ Quick Navigation

### I want to...

**...get started quickly**
→ Start with [QUICKSTART.md](QUICKSTART.md)

**...know what file types are supported**
→ See [MIME_TYPES.md](MIME_TYPES.md)

**...understand the save protection feature**
→ Read [UNSAVED_CHANGES_FEATURE.md](UNSAVED_CHANGES_FEATURE.md)

**...understand the technical implementation**
→ Check [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md)

**...get a complete project overview**
→ Browse [INDEX.md](INDEX.md)

**...build from source**
→ Go back to [README.md](../../README.md#building) in the project root

## 📖 Reading Order

### For New Users
1. [README.md](../../README.md) - Overview and features
2. [QUICKSTART.md](QUICKSTART.md) - Installation and first use
3. [MIME_TYPES.md](MIME_TYPES.md) - Supported formats (optional)
4. [UNSAVED_CHANGES_FEATURE.md](UNSAVED_CHANGES_FEATURE.md) - Save protection (optional)

### For Developers
1. [README.md](../../README.md) - Project overview
2. [INDEX.md](INDEX.md) - Architecture and history
3. [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Technical implementation
4. [MIME_TYPES.md](MIME_TYPES.md) - MIME type system
5. [UNSAVED_CHANGES_FEATURE.md](UNSAVED_CHANGES_FEATURE.md) - Feature implementation

### For Contributors
1. [INDEX.md](INDEX.md) - Understand the project
2. [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Learn the codebase
3. [README.md](../../README.md) - Build and run

## 📝 Documentation Files

| File | Purpose | Audience | Length |
|------|---------|----------|--------|
| [QUICKSTART.md](QUICKSTART.md) | Get started guide | Users | ~100 lines |
| [MIME_TYPES.md](MIME_TYPES.md) | File format reference | Users/Devs | ~180 lines |
| [UNSAVED_CHANGES_FEATURE.md](UNSAVED_CHANGES_FEATURE.md) | Feature documentation | Users/Devs | ~200 lines |
| [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) | Technical notes | Developers | ~270 lines |
| [INDEX.md](INDEX.md) | Project overview | All | ~180 lines |

## 🔗 External Resources

- **Main README**: `/README.md` - Project home page
- **Desktop File**: `/NoteApp.desktop` - MIME type associations

## 🆕 Recent Updates

**2025-10-14**: Documentation reorganization
- All docs moved to `assets/docs/` directory
- Added Quick Links section to README
- Enhanced navigation with emojis and categories
- Added this guide for easier documentation discovery

**2025-10-14**: Unsaved Changes Protection
- New feature documentation added
- Complete user flows and testing scenarios

**2025-10-14**: MIME Type Refactoring
- Comprehensive MIME type support implemented
- Full technical documentation created

## 💡 Tips for Reading

- **Use the Quick Links**: The README has a Quick Links section at the top
- **Follow the emojis**: 📖 = Getting Started, 📚 = Features, 🔧 = Developer
- **Start small**: The QUICKSTART guide is your best entry point
- **Use search**: All markdown files are searchable with `grep` or your IDE

## 🤝 Contributing to Documentation

When adding or updating documentation:

1. Keep files in `assets/docs/` directory
2. Update the README Quick Links if adding new major docs
3. Cross-reference related documents
4. Use clear headings and structure
5. Include code examples where helpful
6. Update this guide if adding new documentation categories

## 📧 Getting Help

If you can't find what you're looking for:
- Check the [README.md](../../README.md) Quick Links section
- Browse all files in this directory
- Review the [INDEX.md](INDEX.md) for a complete overview

---

**Happy Reading!** 📚

*This guide was created on 2025-10-14 to help users and developers navigate the Kirigami NoteApp documentation.*
