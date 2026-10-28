// This file is intentionally vulnerable for testing purposes.
const express = require('express');
const app = express();

app.post('/execute', (req, res) => {
  // Intentional Remote Code Execution (RCE) vulnerability
  // Semgrep rule: javascript.express.security.audit.express-check-req-body.express-eval-req-body
  const userInput = req.body.command;
  const result = eval(userInput); 
  res.send(result);
});

app.listen(3000);