import ballerina/http;
import ballerina/sql;
import ballerina/time;
import ballerinax/h2.driver as _;
import ballerinax/java.jdbc;

configurable DatabaseConfig databaseConfig = ?;
configurable int port = 9090;

final jdbc:Client dbClinet = check new (...databaseConfig);

sql:ParameterizedQuery DDLQurey = `CREATE TABLE IF NOT EXISTS products (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
qtz INT,
create_date DATETIME,
update_date DATETIME
)`;

// time:Utc tempDate = time:utcNow();
time:Civil now = time:utcToCivil(time:utcNow());

sql:ParameterizedQuery initProduct = `INSERT INTO products 
(name, qtz, create_date, update_date)
VALUES ('Iphone 18 pro max', 12, ${now}, ${now})`;

listener http:Listener productsListener = new (port = port, httpVersion = "1.1", timeout = 30);

service /products on productsListener {

    function init() returns error? {
        _ = check dbClinet->execute(DDLQurey);
        _ = check dbClinet->execute(initProduct);
    }

    resource function get .() returns ProductWithMeta[]|error {
        sql:ParameterizedQuery qurey = `SELECT * FROM products ORDER BY create_date DESC`;
        stream<Product, sql:Error?> productStream = dbClinet->query(qurey);
        Product[]|error products = from Product product in productStream
            select product;
        return PorductToProductwithMeta(check products);
    }

    resource function post .(@http:Payload NewProduct product) returns http:Created|error {
        time:Civil time = time:utcToCivil(time:utcNow());
        do {
            sql:ParameterizedQuery qurey = `INSERT INTO products (name, qtz, create_date, update_date) VALUES (${product.name}, ${product.qtz}, ${time}, ${time})`;
            _ = check dbClinet->execute(qurey);
            return http:CREATED;
        } on fail {
            return error("Product not saved");
        }
    }

    resource function get [int id]() returns http:NotFound|ProductWithMeta {
        sql:ParameterizedQuery query = `SELECT * FROM products where id=${id}`;
        Product|sql:Error product = dbClinet->queryRow(query);
        if product is Product {
            return SingleProductToProductwithMeta(product);
        }
        return <http:NotFound>{body: {message: "Product Not Found"}};
    }
}
