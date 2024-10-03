// src/order.js
function processOrder(order) {
    if (order.isPaid && order.isShipped) {
      return 'Order Completed';
    } else if (order.isPaid) {
      return 'Order Awaiting Shipment';
    } else {
      return 'Payment Required';
    }
}
module.exports = processOrder;
