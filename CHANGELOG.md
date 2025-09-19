# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-09-19

### Added
- Initial implementation of AshStripe extension
- Stripe API client using Req HTTP library
- Core Stripe resources as Ash resources:
  - Customer
  - Subscription  
  - PaymentMethod
  - Invoice
  - Product
  - Price
- Custom Ash data layer for Stripe API integration
- Extension DSL for adding Stripe relationships to existing Ash resources
- Comprehensive documentation and examples
- Helper functions for common Stripe operations
- Test suite covering core functionality
- Configuration system supporting environment variables

### Features
- **API Client**: Full HTTP client for Stripe API with proper authentication and versioning
- **Ash Resources**: Pre-built resources matching Stripe's API structure
- **Extension System**: Easy integration of Stripe relationships into existing resources
- **Relationship Management**: Automatic relationship setup via transformers
- **Error Handling**: Proper error propagation from Stripe API to Ash
- **Pagination Support**: Built-in pagination for list operations
- **Flexible Configuration**: Support for custom API keys, versions, and endpoints

### Developer Experience  
- Comprehensive README with usage examples
- Example application demonstrating integration patterns
- Test helpers and mocking support
- Type documentation for all resources
- Consistent API following Ash conventions