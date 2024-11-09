// __tests__/heavyComputation.test.js
const heavyComputation = require('../src/heavyComputation');

test('should compute result within 100ms', () => {
  const start = performance.now();
  heavyComputation(1000000);
  const end = performance.now();
  expect(end - start).toBeLessThan(100);
});