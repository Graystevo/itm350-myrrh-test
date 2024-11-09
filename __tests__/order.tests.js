// __tests__/order.test.js
const processOrder = require('../src/order');

test('should return "Order Completed" when paid and shipped', () => {
  const order = { isPaid: true, isShipped: true };
  expect(processOrder(order)).toBe('Order Completed');
});

test('should return "Order Awaiting Shipment" when paid but not shipped', () => {
  const order = { isPaid: true, isShipped: false };
  expect(processOrder(order)).toBe('Order Awaiting Shipment');
});

test('should return "Payment Required" when not paid', () => {
  const order = { isPaid: false, isShipped: false };
  expect(processOrder(order)).toBe('Payment Required');
});