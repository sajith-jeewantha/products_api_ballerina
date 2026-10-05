import ballerina/http;
import ballerina/log;
import ballerina/test;

final http:Client productsClient = check new ("http://localhost:9090", httpVersion = "1.1");

@test:BeforeSuite
function BeforeSuite() {
    log:printInfo("Test Started");
}

// ── Create product ──────────────────────────────────────────────────────────

@test:Config {}
function testCreateProduct() returns error? {
    log:printInfo("testCreateProduct");
    NewProduct newProduct = {name: "Galaxy S25", qtz: 10};
    http:Response response = check productsClient->post("/products", newProduct);
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 201, msg = "Expected 201 Created when posting a valid product");
}

// ── Get all products ────────────────────────────────────────────────────────

@test:Config {dependsOn: [testCreateProduct]}
function testGetAllProducts() returns error? {
    ProductWithMeta[] products = check productsClient->get("/products");
    boolean hasProducts = products.length() > 0;
    test:assertTrue(hasProducts, msg = "Expected at least one product in the list");
}

// ── Get product by ID ───────────────────────────────────────────────────────

@test:Config {dependsOn: [testCreateProduct]}
function testGetProductById() returns error? {
    // The seed product inserted on init always gets id=1
    ProductWithMeta product = check productsClient->get("/products/1");
    test:assertEquals(product.id, 1, msg = "Expected product id to be 1");
}

@test:Config {}
function testGetProductByIdNotFound() returns error? {
    http:Response response = check productsClient->get("/products/99999");
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 404, msg = "Expected 404 for a non-existent product id");
}

// ── Validation constraints ──────────────────────────────────────────────────

@test:Config {}
function testCreateProductNameTooShort() returns error? {
    // name length < 3 should be rejected
    json invalidProduct = {name: "AB", qtz: 5};
    http:Response response = check productsClient->post("/products", invalidProduct);
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 400, msg = "Expected 400 when product name is too short");
}

@test:Config {}
function testCreateProductNameTooLong() returns error? {
    // name length > 15 should be rejected
    json invalidProduct = {name: "ThisNameIsWayTooLong", qtz: 5};
    http:Response response = check productsClient->post("/products", invalidProduct);
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 400, msg = "Expected 400 when product name is too long");
}

@test:Config {}
function testCreateProductQtzTooLow() returns error? {
    // qtz < 1 should be rejected
    json invalidProduct = {name: "ValidName", qtz: 0};
    http:Response response = check productsClient->post("/products", invalidProduct);
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 400, msg = "Expected 400 when qtz is below minimum");
}

@test:Config {}
function testCreateProductQtzTooHigh() returns error? {
    // qtz > 25 should be rejected
    json invalidProduct = {name: "ValidName", qtz: 30};
    http:Response response = check productsClient->post("/products", invalidProduct);
    int statusCode = response.statusCode;
    test:assertEquals(statusCode, 400, msg = "Expected 400 when qtz exceeds maximum");
}

@test:AfterSuite
function afterSuite() {
    log:printInfo("Test Ended");
}
