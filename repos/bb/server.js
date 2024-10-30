const express = require('express');
const bodyParser = require('body-parser');
const methodOverride = require('method-override');
const errorHandler = require('errorhandler');
const morgan = require('morgan');
const routes = require('./backend');
const api = require('./backend/api'); // Updated imports

const app = express();

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');
app.use(morgan('dev'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(methodOverride());
app.use(express.static(__dirname + '/'));
app.use('/build', express.static('public'));

// Error handling based on environment
const env = process.env.NODE_ENV || 'development';
if (env === 'development') {
  app.use(
    errorHandler({
      dumpExceptions: true,
      showStack: true,
    })
  );
} else if (env === 'production') {
  app.use(errorHandler());
}

// Define routes
app.get('/', routes.index);
app.get('/api/events', api.events); // Get all events
app.post('/api/events', api.addEvent); // Add a new event
app.delete('/api/events/:eventId', api.deleteEvent); // Delete an event

// Start the server
const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Magic happens on port ${PORT}...`);
});
