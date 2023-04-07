
/**
In this code, we define a Mongoose schema for our data model, which has three fields: name, description, and price. We create a new Mongoose model called Item from the schema.
For each endpoint, we define an HTTP method and a URL path. For the create endpoint, we create a new instance of Item from the request body, save it to the database, and return the new item with a status code of 200 if successful or a status code of 400 if there was an error.
For the read endpoint, we find all items in the database and return them with a status code of 200 if successful or a status code of 400 if there was an error.
For the update endpoint, we use the item ID from the URL path to find the item in the database and update it with the request body. We return the updated item with a status code of 200 if successful or a status code of 400 if there was an error.
For the delete endpoint, we use the item ID from the URL path to find the item in the database and remove it. We return a message with a status code of 200 if successful or a status code of 400 if there was an error.
 */
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});

mongoose.connect('mongodb+srv://silviu:Silviu.00@cluster0.o3tdqlh.mongodb.net/?retryWrites=true&w=majority', { useNewUrlParser: true });

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', () => {
  console.log('Connected to the database');
});

const Schema = mongoose.Schema;

const ItemSchema = new Schema({
  name: String,
  description: String,
  price: Number,
});

const Item = mongoose.model('Item', ItemSchema);

// CREATE
app.post('/api/items', async (req, res) => {
//   const newItem = new Item(req.body);
//   newItem.save((err, item) => {
//     if (err) {
//       res.status(400).json(err);
//     } else {
//       res.status(200).json(item);
//     }
//   });
try {
    const newItem = new Item(req.body)
    await newItem.save()
    res.status(200).json(newItem)
} catch (err) {
    console.log(err)
    res.status(400).json(err)
}
});

// READ
app.get('/api/items', async (req, res) => {
try {
    const foundItems = await Item.find();
    console.log(foundItems)
    res.status(200).json(foundItems)
} catch(err) {
    console.log(err)
    res.status(400).json(err)
}
});

// UPDATE
app.put('/api/items/:id', async (req, res) => {
const id = req.params.id;
const updatedItem = req.body;
try {
const item = await Item.findByIdAndUpdate(id, updatedItem, {new: true})
console.log(updatedItem)
res.status(200).json(updatedItem)
} catch(err) {
    console.log(err)
    res.status(400).json(err)
}
});

// DELETE
app.delete('/api/items/:id', async (req, res) => {
const id = req.params.id;
try {
 await Item.findByIdAndRemove(id)
 res.status(200).json({message: 'Item deleted sucessfully'})
} catch(err) {
    console.log(err)
    res.status(400).json(err)
}
});


