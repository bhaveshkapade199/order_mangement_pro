const express = require('express');


const cors = require('cors');
const morgan = require('morgan');
const env = require('./config/env');
const connectDB = require('./config/db');
const routes = require('./routes');
const { errorHandler, notFoundHandler } = require('./middlewares/errorMiddleware');
const Product = require('./models/Product');
const seedDatabase = require('./seeds/seedData');

const app = express();


app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));


app.use('/api', routes);

// Base Route
app.get('/', (req, res) => {
  res.json({
    project: 'Mobile App Development – Multi-Role Commerce Engine',
    rolesSupported: ['Customer', 'Dealer', 'Plumber', 'Admin'],
    integrations: ['Zoho CRM', 'Zoho Workbook', 'OTP Gateway'],
    apiBaseUrl: '/api',
    documentation: 'See README.md for endpoint specifications & Postman collection',
  });
});





//called the Database connection

connectDB()



//Now Create the Server

app.listen(env.PORT, () => {
  console.log(`Server Will be Start On Port ${env.PORT}`);

})



