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

mongoose.connect('mongodb://localhost/mydatabase', { useNewUrlParser: true });

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
app.post('/api/items', (req, res) => {
  const newItem = new Item(req.body);
  newItem.save((err, item) => {
    if (err) {
      res.status(400).json(err);
    } else {
      res.status(200).json(item);
    }
  });
});

// READ
app.get('/api/items', (req, res) => {
  Item.find((err, items) => {
    if (err) {
      res.status(400).json(err);
    } else {
        res.status(200).json(items);
}});
});

// UPDATE
app.put('/api/items/:id', (req, res) => {
const id = req.params.id;
const updatedItem = req.body;

Item.findByIdAndUpdate(id, updatedItem, { new: true }, (err, item) => {
if (err) {
res.status(400).json(err);
} else {
res.status(200).json(item);
}
});
});

// DELETE
app.delete('/api/items/:id', (req, res) => {
const id = req.params.id;

Item.findByIdAndRemove(id, (err, item) => {
if (err) {
res.status(400).json(err);
} else {
res.status(200).json({ message: 'Item deleted successfully' });
}
});
});


