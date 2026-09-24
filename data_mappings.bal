
function PorductToProductwithMeta(Product[] products) returns ProductWithMeta[] => from var product in products
    select {id: product.id, name: product.name, qtz: product.qtz, meta: {create_date: product.create_date, update_date: product.update_date}};

function SingleProductToProductwithMeta(Product product) returns ProductWithMeta =>
{id: product.id, name: product.name, qtz: product.qtz, meta: {create_date: product.create_date, update_date: product.update_date}};

