new Vue({
  el: '#events',

  data: {
    event: { title: '', detail: '', date: '' },
    events: []
  },

  ready: function () {
    this.fetchEvents();
  },

  methods: {

    fetchEvents: function () {
      var events = [];
      this.$http.get('/api/events')
        .success(function (events) {
          this.$set('events', events);
          console.log(events);
        })
        .error(function (err) {
          console.log(err);
        });
    },

    addEvent: function () {
      if (this.event.title.trim()) {
        this.$http.post('/api/events', this.event)
          .then((res) => {
            this.events.push({ ...this.event }); // Create a new object to avoid reactivity issues
            this.event = { title: '', detail: '', date: '' }; // Reset form
            console.log('Event added!');
          })
          .catch((err) => {
            console.log(err);
          });
      }
    },

    deleteEvent: function (id) {
      console.log(`Sending DELETE request for event ID: ${id}`); // Log the ID for verification
    
      if (confirm('Are you sure you want to delete this event?')) {
        this.$http.delete(`/api/events/${id}`)
          .then((res) => {
            console.log('Event deleted successfully!');
            const index = this.events.findIndex((x) => x.id === id);
            if (index !== -1) {
              this.events.splice(index, 1); // Remove from local list
            }
          })
          .catch((err) => {
            console.error('Error deleting event:', err);
          });
      }
    }
    
    
  }
});
