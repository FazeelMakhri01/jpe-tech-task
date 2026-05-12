# Release Status Dashboard

This repository contains a small Node.js application and a simple CI/CD pipeline used as part of a Junior Platform Engineer technical task.

## The Task

Please fork this repository and work from your own fork.

Spend no more than **60–90 minutes** on the task.

Your objectives are to:

* get the application running
* review and improve the CI/CD pipeline
* make any improvements you feel are appropriate
* document your thinking and decisions

You may use AI tools, documentation, Stack Overflow, or any other online resources.

We are more interested in your reasoning, prioritisation, and decision-making than overly complex solutions.

Doing more and more things does not necessarily score higher. We are much more interested in sensible, impactful improvements that you can clearly explain and justify.

---

## Running the Application

Install dependencies:

```bash
npm install
```

Start the application:

```bash
npm start
```

The application will run on:

```text
http://localhost:3000
```

---

## Running Tests

```bash
npm test
```

---

## Docker

Build the image:

```bash
docker build -t release-status-dashboard .
```

Run the container:

```bash
docker run -p 3000:3000 release-status-dashboard
```

---

## Infrastructure

The `infra/` folder contains a small Terraform example for discussion.

You do not need to deploy this infrastructure or have AWS credentials.

Please review it as part of the task and include any observations, concerns, or improvements in your notes.

---

## Submission

Please send us:

* a link to your forked repository
* a short README describing:

  * how you ran the application
  * any issues or improvements you identified
  * any changes you made and why
  * any additional improvements you would make with more time

We will use your submission as the basis for a follow-up technical discussion.

Good luck, and thank you for your time.
