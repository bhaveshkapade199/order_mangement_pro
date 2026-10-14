
const ROLES = {
  CUSTOMER: 'customer',
  DEALER: 'dealer',
  PLUMBER: 'plumber',
  ADMIN: 'admin'
};

const PAYMENT_METHODS = {
  UPFRONT: 'upfront',
  CREDIT_30: 'credit_30',
  CREDIT_90: 'credit_90'
};

const PAYMENT_STATUSES = {
  PENDING: 'pending',
  PAID: 'paid',
  CREDIT_APPROVED: 'credit_approved',
  OVERDUE: 'overdue'
};

const ORDER_STATUSES = {
  PLACED: 'placed',
  CONFIRMED: 'confirmed',
  DISPATCHED: 'dispatched',
  OUT_FOR_DELIVERY: 'out_for_delivery',
  DELIVERED: 'delivered',
  CANCELLED: 'cancelled'
};

const TASK_STATUSES = {
  ASSIGNED: 'assigned',
  IN_PROGRESS: 'in_progress',
  COMPLETED: 'completed',
  CANCELLED: 'cancelled'
};

module.exports = {
  ROLES,
  PAYMENT_METHODS,
  PAYMENT_STATUSES,
  ORDER_STATUSES,
  TASK_STATUSES
};
