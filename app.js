var cron = require('node-cron');
const { syncDB } = require('./tasks/sync-db');

cron.schedule('1-59/5 * * * * *', syncDB);
