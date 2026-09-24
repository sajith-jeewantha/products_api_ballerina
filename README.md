# Products API - Ballerina

A simple RESTful Products API built with Ballerina, backed by an H2 in-memory database using JDBC.

## Prerequisites

- [Ballerina](https://ballerina.io/downloads/) `2201.13.4` or compatible version

## Configuration

Create a `Config.toml` file in the project root with the following content:

```toml
port = 9090

[databaseConfig]
url      = "jdbc:h2:mem:productsdb;DB_CLOSE_DELAY=-1"
user     = "sa"
password = ""
```
[H2 Database Documentation](https://h2database.com/html/main.html)


## Running the Service

```bash
bal run
```

The service starts on `http://localhost:9090` (or the port configured above).

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

| File               | Description                                      |
|--------------------|--------------------------------------------------|
| `main.bal`         | Service definition, listeners, and resource functions |
| `types.bal`        | Type definitions (records)                       |
| `data_mappings.bal`| Data transformation/mapping functions           |
| `connections.bal`  | External connection configurations               |
| `config.bal`       | Configurable declarations                        |
| `functions.bal`    | Utility/helper functions                         |
| `agents.bal`       | Agent definitions (if any)                       |
| `automation.bal`   | Automation logic (if any)                        |
