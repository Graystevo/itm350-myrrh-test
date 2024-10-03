// __tests__/api.test.js
const fetchUserData = require('../src/api');

global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve({ name: 'John Doe', age: 30 })
  })
);

test('should fetch user data from API', async () => {
  const data = await fetchUserData(1);
  expect(data).toEqual({ name: 'John Doe', age: 30 });
});