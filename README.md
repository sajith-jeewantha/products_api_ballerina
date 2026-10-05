# Products API - Ballerina

A simple RESTful Products API built with Ballerina, backed by an H2 in-memory database using JDBC.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) `2201.13.4` or compatible version

## Configuration

### Running the service (`Config.toml`)

Create a `Config.toml` file in the project root:

```toml
port = 9090

[databaseConfig]
url      = "jdbc:h2:mem:productsdb;DB_CLOSE_DELAY=-1"
user     = "sa"
password = ""
```

### Running tests (`tests/Config.toml`)

Create a separate `tests/Config.toml` file for the test suite:

```toml
port = 9090

[databaseConfig]
url      = "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1"
user     = "sa"
password = ""
```

> **Note:** Ballerina uses `Config.toml` for `bal run` and `tests/Config.toml` for `bal test`. Both files are required.

[H2 Database Documentation](https://h2database.com/html/main.html)


## Running the Service

```bash
bal run
```

The service starts on `http://localhost:9090` (or the port configured above).

## Running Tests

```bash
bal test
```

The test suite starts the service automatically and runs all test cases against `http://localhost:9090`. Make sure `tests/Config.toml` exists before running tests.

## API Endpoints

Base URL: `http://localhost:9090/products`

### Get All Products

Retrieves all products ordered by creation date (newest first).

```
GET /products
```

**Response `200 OK`**
```json
[
  {
    "id": 1,
    "name": "Iphone 18 pro max",
    "qtz": 12,
    "meta": {
      "create_date": { "year": 2026, "month": 9, "day": 24 },
      "update_date": { "year": 2026, "month": 9, "day": 24 }
    }
  }
]
```

---

### Get Product by ID

Retrieves a single product by its ID.

```
GET /products/{id}
```

| Parameter | Type  | Description        |
|-----------|-------|--------------------|
| `id`      | `int` | ID of the product  |

**Response `200 OK`**
```json
{
  "id": 1,
  "name": "Iphone 18 pro max",
  "qtz": 12,
  "meta": {
    "create_date": { "year": 2026, "month": 9, "day": 24 },
    "update_date": { "year": 2026, "month": 9, "day": 24 }
  }
}
```

**Response `404 Not Found`**
```json
{
  "message": "Product Not Found"
}
```

---

### Create a Product

Creates a new product.

```
POST /products
Content-Type: application/json
```

**Request Body**

| Field  | Type     | Constraints                  |
|--------|----------|------------------------------|
| `name` | `string` | Min length: 3, Max length: 15 |
| `qtz`  | `int`    | Min value: 1, Max value: 25   |

```json
{
  "name": "Galaxy S25",
  "qtz": 10
}
```

**Response `201 Created`**

Returns an empty `201 Created` response on success.

**Response `500 Internal Server Error`**

Returns an error if the product could not be saved.

---

## Project Structure

| File                      | Description                                           |
|---------------------------|-------------------------------------------------------|
| `main.bal`                | Service definition, listeners, and resource functions |
| `types.bal`               | Type definitions (records)                            |
| `data_mappings.bal`       | Data transformation/mapping functions                 |
| `connections.bal`         | External connection configurations                    |
| `config.bal`              | Configurable declarations                             |
| `functions.bal`           | Utility/helper functions                              |
| `agents.bal`              | Agent definitions (if any)                            |
| `automation.bal`          | Automation logic (if any)                             |
| `tests/main_test.bal`     | Integration test cases for all API endpoints          |
| `tests/Config.toml`       | Configuration used exclusively by `bal test`          |
| `.github/workflows/ci.yml`| GitHub Actions CI — runs tests on PRs to `main`       |

## CI/CD

A GitHub Actions workflow is configured at `.github/workflows/ci.yml`. It automatically runs the full test suite on every pull request targeting the `main` branch.

**Workflow steps:**
1. Checkout the repository
2. Install Ballerina `2201.13.4`
3. Write `Config.toml` with the H2 in-memory database settings
4. Run `bal test`
