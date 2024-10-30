const fs = require('fs');
const path = require('path');
const eventsPath = path.join(__dirname, 'events.js');

// Helper: Read events from the file
function getEvents() {
  delete require.cache[require.resolve('./events.js')]; // Clear the cache to get fresh data
  return require('./events.js');
}

// Helper: Write events to the file
function saveEvents(events) {
  const content = `module.exports = ${JSON.stringify(events, null, 2)};`;
  fs.writeFileSync(eventsPath, content, 'utf8');
}

// Get all events
exports.events = (req, res) => {
  const events = getEvents();
  res.json(events);
};

// Add a new event
exports.addEvent = (req, res) => {
  const events = getEvents();
  const newEvent = { ...req.body, id: events.length + 1 };
  events.push(newEvent);
  saveEvents(events); // Save the updated events to the file
  res.status(201).json(newEvent);
};

// Delete an event by ID
exports.deleteEvent = (req, res) => {
  const events = getEvents();
  const eventId = parseInt(req.params.eventId, 10); // Ensure the ID is a number

  const index = events.findIndex((e) => e.id === eventId);

  if (index !== -1) {
    events.splice(index, 1); // Remove the event
    saveEvents(events); // Save the updated events to the file
    res.status(204).send(); // No content response
  } else {
    console.log(`Event with ID ${eventId} not found.`);
    res.status(404).send('Event not found'); // Return 404 if not found
  }
};

