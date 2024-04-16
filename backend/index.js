const express = require('express');
const mongoose = require('mongoose');

const app = express();
const PORT = 3000;

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/employeeDB', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Employee schema
const employeeSchema = new mongoose.Schema({
  name: String,
  workExperience: Number,
  isActive: Boolean,
});

const Employee = mongoose.model('Employee', employeeSchema);

// API endpoint to fetch all employees
app.get('/employees', async (req, res) => {
  try {
    const employees = await Employee.find({});
    res.json(employees);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'error' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server on port ${PORT}`);
});
