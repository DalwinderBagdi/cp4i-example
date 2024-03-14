// Create a sample database
db = db.getSiblingDB('sample');

// Create a user
db.createUser({
    user: 'user123',
    pwd: 'password123',
    roles: [{ role: 'readWrite', db: 'sample' }]
});

// Insert customer details into the sample database
db.customerDetails.insertOne({
    "last_updated": "2020-05-19T09:05:33.501Z",
    "first_name": "John",
    "last_name": "Doe",
    "address": "123 Main Street",
    "customer_number": "123"
});

db.customerDetails.insertOne({
    "last_updated": "2020-05-19T08:59:18.926Z",
    "first_name": "Jane",
    "last_name": "Doe",
    "address": "456 Main Street",
    "customer_number": "456"
});

db.customerDetails.insertOne({
    "last_updated": "2020-05-19T08:59:18.926Z",
    "first_name": "Jane",
    "last_name": "Doe",
    "address": "456 Main Street",
    "customer_number": "456"
});

db.customerDetails.insertOne({
    "last_updated": "2020-05-19T08:57:39.010Z",
    "first_name": "Max",
    "last_name": "Payne",
    "address": "789 Main Street",
    "customer_number": "789"
});
