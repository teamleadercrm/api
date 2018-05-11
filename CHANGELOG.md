# Changelog

## 2018-05-15
### Changed
- Renamed `address` to `primary_address` in contacts.list and companies.list
- The `customer` property is now embedded inside a `lead` property with an optional `contact_person` for deal endpoints
### Removed
- The `address` property in contacts.list and companies.list
- The `customer` property in deals.list and deals.info