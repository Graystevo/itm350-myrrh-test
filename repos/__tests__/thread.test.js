// __tests__/thread.test.js
const performAsyncTasks = require('../src/thread');

test('should handle multiple async tasks', async () => {
  const tasks = [
    () => Promise.resolve('Task 1 completed'),
    () => Promise.resolve('Task 2 completed')
  ];

  const results = await performAsyncTasks(tasks);
  expect(results).toEqual(['Task 1 completed', 'Task 2 completed']);
});